//
//  MessagesVC.swift
//  Food Bridge
//
//  Created by Lawrence Liu on 12/31/24.
//

import Foundation
import UIKit
import FirebaseFirestore

class MessagesVC: UIViewController {
    struct Message {
        let messageKey: String        // e.g. "uidA_uidB" as a stable identifier
        let otherUserID: String       // The user’s ID you’re chatting with
        let lastMessage: String       // The most recent text
        let lastTimestamp: Date       // The time of the most recent text
    }
    
    // MARK: - UI
    let header_lb: UILabel = {
        let lb = UILabel()
        lb.text = "Messages"
        lb.font = UIFont.boldSystemFont(ofSize: 45)
        lb.textColor = forestGreen
        lb.textAlignment = .center
        return lb
    }()
    
    // Table to display the chat rows
    let tableView = UITableView()
    
    // MARK: - Data
    var messages: [Message] = []  // Each item is one "chat" with the other user
    var listener: ListenerRegistration?
    
    // Current user’s ID (assumes you have a global USER_ID or similar)
    let currentUserID: String = USER_ID
    
    // Firestore reference
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = lightGreen
        
        setup_UI()
        setupTableView()
        setupNavBar()
        
        observeMessages()
    }
    
    deinit {
        // Stop listening when VC is deallocated
        listener?.remove()
    }
    
    // MARK: - Firestore Observer
    
    /// Observes all message documents involving `currentUserID`, then groups them
    /// so that multiple A↔B messages appear as one chat row.
    func observeMessages() {
        listener = db.collection("messages")
            .whereField("participants", arrayContains: currentUserID)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error fetching messages: \(error.localizedDescription)")
                    return
                }
                
                // We'll collect chats in a dictionary keyed by "messageKey"
                var msgDict: [String: Message] = [:]
                
                snapshot?.documents.forEach { doc in
                    let data = doc.data()
                    
                    guard let participants = data["participants"] as? [String],
                          participants.count == 2 else {
                        return
                    }
                    
                    // Sort participants to unify "A_B" == "B_A"
                    let sortedParts = participants.sorted()
                    let messageKey = sortedParts.joined(separator: "_")
                    
                    // Identify the other user
                    let otherID = (sortedParts[0] == self.currentUserID)
                        ? sortedParts[1]
                        : sortedParts[0]
                    
                    let lastMessageText = data["message"] as? String ?? ""
                    
                    // Timestamp of this doc
                    let ts = data["timestamp"] as? Timestamp ?? Timestamp(date: Date(timeIntervalSince1970: 0))
                    let messageDate = ts.dateValue()
                    
                    // If we already have an entry, keep the newest (latest) message
                    if let existing = msgDict[messageKey] {
                        if messageDate > existing.lastTimestamp {
                            // Update with newer message info
                            let updated = Message(
                                messageKey: messageKey,
                                otherUserID: otherID,
                                lastMessage: lastMessageText,
                                lastTimestamp: messageDate
                            )
                            msgDict[messageKey] = updated
                        }
                    } else {
                        // First time we see this chat
                        let newEntry = Message(
                            messageKey: messageKey,
                            otherUserID: otherID,
                            lastMessage: lastMessageText,
                            lastTimestamp: messageDate
                        )
                        msgDict[messageKey] = newEntry
                    }
                }
                
                // Convert dictionary to array, sort by newest
                let sorted = Array(msgDict.values).sorted { $0.lastTimestamp > $1.lastTimestamp }
                
                self.messages = sorted
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
    }
    
    // MARK: - UI Setup
    
    func setup_UI() {
        let top_margin: CGFloat = 100
        let elem_w: CGFloat = view.frame.width - 2 * left_margin
        
        header_lb.frame = CGRect(
            x: left_margin,
            y: top_margin,
            width: elem_w,
            height: elem_h
        )
        view.addSubview(header_lb)
    }
    
    private func setupTableView() {
        tableView.frame = CGRect(
            x: 0,
            y: header_lb.frame.maxY + elem_margin,
            width: view.frame.width,
            height: view.frame.height - (header_lb.frame.maxY + elem_margin)
        )
        tableView.backgroundColor = lightGreen
        tableView.dataSource = self
        tableView.delegate = self
        
        // Register a basic cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        view.addSubview(tableView)
    }
    
    private func setupNavBar() {
        // Make nav bar transparent
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        // Right bar button: create new chat
        let new_chat_bt = UIBarButtonItem(
            image: UIImage(systemName: "square.and.pencil"),
            style: .plain,
            target: self,
            action: #selector(handle_new_chat)
        )
        new_chat_bt.tintColor = forestGreen
        navigationItem.rightBarButtonItem = new_chat_bt
    }
    
    @objc func handle_new_chat() {
        let vc = NewChatVC()
        present(vc, animated: true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension MessagesVC: UITableViewDataSource, UITableViewDelegate {
    
    // Number of rows = number of user-to-user chats
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    // Display each chat row with the other user’s ID and the last message
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = lightGreen
        
        let msg = messages[indexPath.row]
        cell.textLabel?.text = "\(msg.otherUserID) - \(msg.lastMessage)"
        cell.textLabel?.textColor = forestGreen
        
        return cell
    }
    
    // Tapping a row -> open the actual chat with that other user
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        
        let msg = messages[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Push or present your ChatVC, passing the other user’s ID
//        let chatVC = ChatVC()
//        chatVC.otherUserID = msg.otherUserID
//        navigationController?.pushViewController(chatVC, animated: true)
    }
}
