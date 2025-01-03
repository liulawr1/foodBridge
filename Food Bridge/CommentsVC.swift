//
//  CommentsVC.swift
//  Food Bridge
//
//  Created by Lawrence Liu on 1/1/25.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage  // Needed if you're using Storage directly

class CommentsVC: UIViewController {
    // The listing for which we’re displaying comments
    var listingID: String = ""   // Set this before presenting/pushing CommentsVC
    
    // Table view
    let tableView = UITableView()
    
    // A container that holds the text field + post button at bottom
    let bottomContainer = UIView()
    
    let commentTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Add a comment..."
        tf.borderStyle = .roundedRect
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        return tf
    }()
    
    let postButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setTitle("Post", for: .normal)
        return bt
    }()
    
    // Data
    var comments: [Comment] = []
    var listener: ListenerRegistration?
    
    // We store the bottom constraint of the container to move it with the keyboard
    var bottomContainerBottomConstraint: NSLayoutConstraint?
    
    // Image cache: userID -> UIImage
    var profileImageCache = [String: UIImage]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = lightGreen
        
        setupUI()
        observeComments()
        
        // Handle post button tap
        postButton.addTarget(self, action: #selector(handlePostComment), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Listen for keyboard notifications
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Remove keyboard notifications
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    deinit {
        // Stop Firestore listener if this VC is deallocated
        listener?.remove()
    }
    
    // MARK: - Firestore
    
    /// Listen to the comments sub-collection in real-time, sorted by timestamp.
    func observeComments() {
        listener = db.collection("listings")
            .document(listingID)
            .collection("comments")
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error listening to comments: \(error.localizedDescription)")
                    return
                }
                
                var temp: [Comment] = []
                snapshot?.documents.forEach({ doc in
                    let data = doc.data()
                    let userID = data["userID"] as? String ?? ""
                    let text = data["text"] as? String ?? ""
                    let ts = data["timestamp"] as? Timestamp ?? Timestamp(date: Date(timeIntervalSince1970: 0))
                    
                    // We'll store userEmail optionally or skip if we don't need it:
                    let userEmail = data["userEmail"] as? String ?? "No Email"
                    
                    let newComment = Comment(
                        commentID: doc.documentID,
                        userID: userID,
                        userEmail: userEmail,
                        text: text,
                        timestamp: ts.dateValue()
                    )
                    temp.append(newComment)
                })
                
                self.comments = temp
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    // Scroll to bottom if you want the newest comment visible
                    if !self.comments.isEmpty {
                        let indexPath = IndexPath(row: self.comments.count - 1, section: 0)
                        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                    }
                }
            }
    }
    
    // MARK: - Post New Comment
    
    @objc func handlePostComment() {
        guard let text = commentTextField.text,
              !text.isEmpty else { return }
        
        // Build comment data
        let commentData: [String: Any] = [
            "userID": USER_ID,         // from your global or Auth
            "userEmail": USER_EMAIL,   // in case you need it
            "text": text,
            "timestamp": Timestamp(date: Date())
        ]
        
        // Add a new doc in the sub-collection
        db.collection("listings")
            .document(listingID)
            .collection("comments")
            .addDocument(data: commentData) { [weak self] error in
                if let error = error {
                    print("Failed to post comment: \(error.localizedDescription)")
                    return
                }
                DispatchQueue.main.async {
                    self?.commentTextField.text = ""
                }
            }
    }
    
    // MARK: - Keyboard
    
    @objc func handleKeyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let frameEnd = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        // Convert keyboard frame to our view
        let keyboardFrame = view.convert(frameEnd, from: nil)
        
        // How tall is it relative to safe area
        let bottomSafeArea = view.safeAreaInsets.bottom
        let keyboardHeight = keyboardFrame.height - bottomSafeArea
        
        UIView.animate(withDuration: 0.3) {
            self.bottomContainerBottomConstraint?.constant = -keyboardHeight
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func handleKeyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.bottomContainerBottomConstraint?.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - UI Setup
    
    func setupUI() {
        title = "Comments"
        
        // Register custom cell
        tableView.register(CommentCell.self, forCellReuseIdentifier: "CommentCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = lightGreen
        
        // Add subviews
        view.addSubview(tableView)
        view.addSubview(bottomContainer)
        bottomContainer.addSubview(commentTextField)
        bottomContainer.addSubview(postButton)
        
        // Auto Layout
        tableView.translatesAutoresizingMaskIntoConstraints = false
        bottomContainer.translatesAutoresizingMaskIntoConstraints = false
        commentTextField.translatesAutoresizingMaskIntoConstraints = false
        postButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Table constraints
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        // Bottom container constraints
        // store bottom anchor in bottomContainerBottomConstraint
        bottomContainerBottomConstraint = bottomContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        
        NSLayoutConstraint.activate([
            bottomContainerBottomConstraint!,
            bottomContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomContainer.heightAnchor.constraint(equalToConstant: 60),
            
            // tableView bottom pinned to top of container
            tableView.bottomAnchor.constraint(equalTo: bottomContainer.topAnchor)
        ])
        
        bottomContainer.backgroundColor = .secondarySystemBackground
        
        // commentTextField + postButton inside bottomContainer
        NSLayoutConstraint.activate([
            // Text field
            commentTextField.centerYAnchor.constraint(equalTo: bottomContainer.centerYAnchor),
            commentTextField.leadingAnchor.constraint(equalTo: bottomContainer.leadingAnchor, constant: 16),
            commentTextField.heightAnchor.constraint(equalToConstant: 40),
            
            // Post button
            postButton.centerYAnchor.constraint(equalTo: bottomContainer.centerYAnchor),
            postButton.leadingAnchor.constraint(equalTo: commentTextField.trailingAnchor, constant: 8),
            postButton.trailingAnchor.constraint(equalTo: bottomContainer.trailingAnchor, constant: -16),
            postButton.widthAnchor.constraint(equalToConstant: 60),
            postButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension CommentsVC: UITableViewDataSource, UITableViewDelegate {
    // numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    // cellForRowAt
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "CommentCell",
            for: indexPath
        ) as? CommentCell else {
            return UITableViewCell()
        }
        
        let cmt = comments[indexPath.row]
        cell.backgroundColor = lightGreen
        
        // Assign the comment text
        cell.messageLabel.text = cmt.text
        
        // If we already have the user's image in cache, use it
        if let cachedImage = profileImageCache[cmt.userID] {
            cell.profileImageView.image = cachedImage
        } else {
            // Fetch from Storage, store in cache
            fetchProfilePicture(for: cmt.userID) { [weak self] image in
                guard let self = self else { return }
                // Update cache
                self.profileImageCache[cmt.userID] = image
                // If this cell is still displaying the same user, update
                if cell.commentUserID == cmt.userID {
                    DispatchQueue.main.async {
                        cell.profileImageView.image = image
                    }
                }
            }
        }
        
        // Keep track of which userID this cell is for (used above)
        cell.commentUserID = cmt.userID
        
        return cell
    }
    
    // MARK: - Trailing Swipe to Delete
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
                   -> UISwipeActionsConfiguration? {
        
        let cmt = comments[indexPath.row]
        
        // Show "Delete" only if this comment belongs to the current user
        guard cmt.userID == USER_ID else {
            return nil
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {
            [weak self] (_, _, completion) in
            guard let self = self else { return }
            
            // 2) Call the delete function
            self.deleteComment(cmt)
            
            // Let the system know we're done
            completion(true)
        }
        
        deleteAction.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    // MARK: - Delete a comment
    func deleteComment(_ comment: Comment) {
        db.collection("listings")
            .document(listingID)
            .collection("comments")
            .document(comment.commentID)
            .delete { error in
                if let error = error {
                    print("Error deleting comment: \(error.localizedDescription)")
                } else {
                    print("Comment deleted successfully!")
                    // Firestore snapshot listener will handle UI update
                }
            }
    }
}

// MARK: - Fetch Profile Picture

extension CommentsVC {
    /// Fetch user's profile picture from Firebase Storage
    func fetchProfilePicture(for userID: String, completion: @escaping (UIImage) -> Void) {
        // A default placeholder image
        let placeholder = UIImage(systemName: "person.circle") ?? UIImage()
        
        // If userID is blank, return placeholder
        if userID.isEmpty {
            completion(placeholder)
            return
        }
        
        let storageRef = Storage.storage().reference()
        let path = "users/\(userID)/profile_picture/\(userID)_image.png"
        
        // Download URL
        storageRef.child(path).downloadURL { (url, err) in
            if let _ = err {
                // If error, just return placeholder
                completion(placeholder)
                return
            }
            
            guard let downloadURL = url else {
                completion(placeholder)
                return
            }
            
            // Download the actual image data
            URLSession.shared.dataTask(with: downloadURL) { (data, response, error) in
                if let _ = error {
                    completion(placeholder)
                    return
                }
                
                if let data = data, let image = UIImage(data: data) {
                    // Optionally compress if needed
                    completion(image)
                } else {
                    completion(placeholder)
                }
            }.resume()
        }
    }
}

// MARK: - Comment Struct

struct Comment {
    let commentID: String
    let userID: String
    let userEmail: String  // optional if you need it
    let text: String
    let timestamp: Date
}
