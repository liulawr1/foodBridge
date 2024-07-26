//
//  ListVC.swift
//  Food Bridge
//
//  Created by Lawrence Liu on 7/8/23.
//

import Foundation
import UIKit
import FirebaseFirestore


class LimitedTextField: UITextField, UITextFieldDelegate {
    
    var characterLimit: Int = 50 // default char limit
    private var characterCountLabel: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
        setupCharacterCountLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.delegate = self
        setupCharacterCountLabel()
    }
    
    private func setupCharacterCountLabel() {
        characterCountLabel = UILabel()
        characterCountLabel?.textColor = .gray
        characterCountLabel?.font = UIFont.systemFont(ofSize: 12)
        characterCountLabel?.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(characterCountLabel!)
        updateCharacterCountLabel()

        NSLayoutConstraint.activate([
            characterCountLabel!.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            characterCountLabel!.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5)
        ])
    }
    
    private func updateCharacterCountLabel() {
        guard let currentText = self.text else { return }
        characterCountLabel?.text = "\(currentText.count)/\(characterLimit)"
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text else { return true }
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        if newText.count <= characterLimit {
            updateCharacterCountLabel()
            return true
        } else {
            return false
        }
    }
    
    override var text: String? {
        didSet {
            updateCharacterCountLabel()
        }
    }
}

class ListVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var image_data = Data()
    let scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = lightGreen
        setup_UI()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.hideKeyboardWhenTappedAround()
    }
    
    let header_lb: UILabel = {
        let lb = UILabel()
        lb.text = "Create a Listing"
        lb.font = UIFont.boldSystemFont(ofSize: 45)
        lb.textColor = forestGreen
        lb.textAlignment = .center
        return lb
    }()
    
    let title_field: LimitedTextField = {
        let tf = LimitedTextField()
        tf.characterLimit = 25
        let attributedPlaceholder = NSAttributedString(
            string: "Title",
            attributes: [NSAttributedString.Key.foregroundColor: forestGreen]
        )
        tf.attributedPlaceholder = attributedPlaceholder
        tf.backgroundColor = lightGreen
        tf.font = UIFont.boldSystemFont(ofSize: 20)
        tf.textColor = forestGreen
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.layer.borderColor = forestGreen.cgColor
        tf.layer.borderWidth = 2
        tf.layer.cornerRadius = 20
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: tf.frame.height))
        tf.leftView = paddingView
        tf.leftViewMode = .always
        
        return tf
    }()
    
    let description_field: UITextView = {
        let tv = UITextView()
        let attributedPlaceholder = NSAttributedString(
            string: "Description",
            attributes: [NSAttributedString.Key.foregroundColor: forestGreen]
        )
        tv.attributedText = attributedPlaceholder
        tv.backgroundColor = lightGreen
        tv.font = UIFont.boldSystemFont(ofSize: 20)
        tv.textColor = forestGreen
        tv.autocapitalizationType = .none
        tv.autocorrectionType = .no
        tv.layer.borderColor = forestGreen.cgColor
        tv.layer.borderWidth = 2
        tv.layer.cornerRadius = 20
        
//        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: tv.frame.height))
//        tv.leftView = paddingView
//        tv.leftViewMode = .always
        
        return tv
    }()
    
    let item_quantity_field: LimitedTextField = {
        let tf = LimitedTextField()
        tf.characterLimit = 10
        let attributedPlaceholder = NSAttributedString(
            string: "Title",
            attributes: [NSAttributedString.Key.foregroundColor: forestGreen]
        )
        tf.attributedPlaceholder = attributedPlaceholder
        tf.backgroundColor = lightGreen
        tf.font = UIFont.boldSystemFont(ofSize: 20)
        tf.textColor = forestGreen
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.layer.borderColor = forestGreen.cgColor
        tf.layer.borderWidth = 2
        tf.layer.cornerRadius = 20
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: tf.frame.height))
        tf.leftView = paddingView
        tf.leftViewMode = .always
        
        return tf
    }()
    
    let item_weight_field: UITextField = {
        let tf = UITextField()
        let attributedPlaceholder = NSAttributedString(
            string: "Item Weight",
            attributes: [NSAttributedString.Key.foregroundColor: forestGreen]
        )
        tf.attributedPlaceholder = attributedPlaceholder
        tf.backgroundColor = lightGreen
        tf.font = UIFont.boldSystemFont(ofSize: 20)
        tf.textColor = forestGreen
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.layer.borderColor = forestGreen.cgColor
        tf.layer.borderWidth = 2
        tf.layer.cornerRadius = 20
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: tf.frame.height))
        tf.leftView = paddingView
        tf.leftViewMode = .always
        
        return tf
    }()
    
    let pickup_location_field: UITextField = {
        let tf = UITextField()
        let attributedPlaceholder = NSAttributedString(
            string: "Pickup Location",
            attributes: [NSAttributedString.Key.foregroundColor: forestGreen]
        )
        tf.attributedPlaceholder = attributedPlaceholder
        tf.backgroundColor = lightGreen
        tf.font = UIFont.boldSystemFont(ofSize: 20)
        tf.textColor = forestGreen
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.layer.borderColor = forestGreen.cgColor
        tf.layer.borderWidth = 2
        tf.layer.cornerRadius = 20
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: tf.frame.height))
        tf.leftView = paddingView
        tf.leftViewMode = .always
        
        return tf
    }()
    
    let start_date_picker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .dateAndTime
        dp.minuteInterval = 15
        dp.backgroundColor = lightGreen
        dp.tintColor = forestGreen
        dp.layer.borderColor = forestGreen.cgColor
        dp.layer.borderWidth = 2
        dp.layer.cornerRadius = 20
        dp.clipsToBounds = true
        return dp
    }()

    let end_date_picker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .dateAndTime
        dp.minuteInterval = 15
        dp.backgroundColor = lightGreen
        dp.tintColor = forestGreen
        dp.layer.borderColor = forestGreen.cgColor
        dp.layer.borderWidth = 2
        dp.layer.cornerRadius = 20
        dp.clipsToBounds = true
        return dp
    }()
    
    @objc func startDateChanged(picker: UIDatePicker) {
        let startDate = picker.date
        print("Selected start date: \(startDate)")
    }

    @objc func endDateChanged(picker: UIDatePicker) {
        let endDate = picker.date
        print("Selected end date: \(endDate)")

        if endDate < start_date_picker.date {
            let calendar = Calendar.current
            let newEndDate = calendar.date(byAdding: .minute, value: 15, to: start_date_picker.date) ?? Date()
            end_date_picker.setDate(newEndDate, animated: true)
        }
    }
    
    let contact_info_field: UITextField = {
        let tf = UITextField()
        let attributedPlaceholder = NSAttributedString(
            string: "Contact Info",
            attributes: [NSAttributedString.Key.foregroundColor: forestGreen]
        )
        tf.attributedPlaceholder = attributedPlaceholder
        tf.backgroundColor = lightGreen
        tf.font = UIFont.boldSystemFont(ofSize: 20)
        tf.textColor = forestGreen
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.layer.borderColor = forestGreen.cgColor
        tf.layer.borderWidth = 2
        tf.layer.cornerRadius = 20
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: tf.frame.height))
        tf.leftView = paddingView
        tf.leftViewMode = .always
        
        return tf
    }()
    
    let listing_image: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = lightGreen
        iv.layer.borderColor = forestGreen.cgColor
        iv.layer.borderWidth = 2
        iv.layer.cornerRadius = 15
        iv.clipsToBounds = true
        return iv
    }()
    
    let set_listing_image_bt: UIButton = {
        let bt = UIButton()
        bt.setTitle("Set Listing Image", for: .normal)
        bt.backgroundColor = lightGreen
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        bt.setTitleColor(forestGreen, for: .normal)
        bt.titleLabel?.textAlignment = .center
        bt.layer.borderColor = forestGreen.cgColor
        bt.layer.borderWidth = 2
        bt.layer.cornerRadius = 20
        bt.titleLabel?.numberOfLines = 0
        return bt
    }()
    
    @objc func handle_listing_image_upload(sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        self.present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let selected_image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        listing_image.image = selected_image
        image_data = selected_image.pngData()!
        self.dismiss(animated: true)
    }
    
    let create_listing_bt: UIButton = {
        let bt = UIButton()
        bt.setTitle("Create Listing", for: .normal)
        bt.backgroundColor = lightGreen
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        bt.setTitleColor(forestGreen, for: .normal)
        bt.titleLabel?.textAlignment = .center
        bt.layer.borderColor = forestGreen.cgColor
        bt.layer.borderWidth = 2
        bt.layer.cornerRadius = 20
        return bt
    }()
    
    let list_date: String = {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.string(from: date)
    }()
    
    let success_alert = UIAlertController(title: "Success!", message: "Listing successfully created!", preferredStyle: .alert)
    let failure_alert = UIAlertController(title: "Failure!", message: "Please fill in all required fields!", preferredStyle: .alert)
    let error_alert = UIAlertController(title: "Error!", message: "Error occurred while creating listing!", preferredStyle: .alert)
    let dismiss_alert = UIAlertAction(title: "OK", style: .default)
    
    func display_success() {
        present(success_alert, animated: true)
        success_alert.addAction(dismiss_alert)
    }
    
    func display_failure() {
        present(failure_alert, animated: true)
        failure_alert.addAction(dismiss_alert)
    }
    
    func display_error() {
        present(error_alert, animated: true)
        error_alert.addAction(dismiss_alert)
    }
    
    func increase_listings_counter() {
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if ((document.get("email") as! String) == USER_EMAIL) {
                        let listingRef = db.collection("users").document(USER_ID)
                        
                        let active_listings_data = document.get("active_listings") as! Int
                        let total_listings_data = document.get("total_listings") as! Int
                        
                        listingRef.updateData([
                            "active_listings": active_listings_data + 1,
                            "total_listings": total_listings_data + 1
                        ]) { err in
                            if let err = err {
                                print("Error updating document: \(err)")
                            } else {
                                print("Document successfully updated")
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc func handle_create(sender: UIButton) {
        let title = title_field.text
        let description = description_field.text
        let item_quantity = item_quantity_field.text
        let item_weight = item_weight_field.text
        let pickup_location = pickup_location_field.text
        let start_date = start_date_picker.date
        let end_date = end_date_picker.date
        let contact_info = contact_info_field.text
        let list_author = USER_EMAIL!.split(separator: "@").first ?? ""
        
        if (title != "" && description != "" && pickup_location != "" && contact_info != "") {
            var ref: DocumentReference? = nil
            
            ref = db.collection("listings").addDocument(data: [
                "title": title!,
                "description": description!,
                "item_quantity": item_quantity!,
                "item_weight": item_weight!,
                "pickup_location": pickup_location!,
                "start_date": start_date,
                "end_date": end_date,
                "contact_info": contact_info!,
                "list_date": list_date,
                "list_author": list_author
            ]) { [self] err in
                if let err = err {
                    print("Error adding document: \(err)")
                    display_error()
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                    title_field.text = ""
                    description_field.text = ""
                    item_quantity_field.text = ""
                    item_weight_field.text = ""
                    pickup_location_field.text = ""
                    contact_info_field.text = ""
                    listing_image.image = nil
                    increase_listings_counter()
                    
                    storage_ref.child("listings/\(ref!.documentID)").child(LISTING_IMAGE_PATH).child("\(ref!.documentID)_image.png").putData(image_data) { [self] (metadata, err) in
                        if let err = err {
                            print(err.localizedDescription)
                            display_error()
                            return
                        } else {
                            print("successfully uploaded image to firebase storage")
                        }
                    }
                    
                    display_success()
                }
            }
        } else {
            display_failure()
        }
    }
    
    func setup_UI() {
        let top_margin: CGFloat = 0
        let elem_w: CGFloat = view.frame.width - 2 * left_margin
        let listing_image_dim: CGFloat = 150
        scrollView.frame = view.bounds
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + 200)
        header_lb.frame = CGRect(x: left_margin, y: top_margin, width: elem_w, height: elem_h)
        title_field.frame = CGRect(x: left_margin, y: header_lb.center.y + header_lb.frame.height / 2 + elem_margin + 10, width: elem_w, height: elem_h)
        description_field.frame = CGRect(x: left_margin, y: title_field.center.y + title_field.frame.height / 2 + elem_margin, width: elem_w, height: elem_h * 3.5)
        item_quantity_field.frame = CGRect(x: left_margin, y: description_field.center.y + description_field.frame.height / 2 + elem_margin, width: elem_w, height: elem_h)
        item_weight_field.frame = CGRect(x: left_margin, y: item_quantity_field.center.y + item_quantity_field.frame.height / 2 + elem_margin, width: elem_w, height: elem_h)
        pickup_location_field.frame = CGRect(x: left_margin, y: item_weight_field.center.y + item_weight_field.frame.height / 2 + elem_margin, width: elem_w, height: elem_h)
        start_date_picker.frame = CGRect(x: left_margin, y: pickup_location_field.center.y + pickup_location_field.frame.height / 2 + elem_margin, width: elem_w, height: elem_h)
        end_date_picker.frame = CGRect(x: left_margin, y: start_date_picker.center.y + start_date_picker.frame.height / 2 + elem_margin, width: elem_w, height: elem_h)
        contact_info_field.frame = CGRect(x: left_margin, y: end_date_picker.center.y + end_date_picker.frame.height / 2 + elem_margin, width: elem_w, height: elem_h)
        listing_image.frame = CGRect(x: left_margin, y: contact_info_field.center.y + contact_info_field.frame.height / 2 + elem_margin, width: listing_image_dim, height: listing_image_dim)
        set_listing_image_bt.frame = CGRect(x: view.frame.width / 2, y: listing_image.center.y - 15, width: elem_w / 2, height: elem_h)
        create_listing_bt.frame = CGRect(x: left_margin, y: listing_image.center.y + listing_image.frame.height / 2 + elem_margin, width: elem_w, height: elem_h)
        
        let startDateLabel = UILabel(frame: CGRect(x: 10, y: 0, width: start_date_picker.frame.width, height: start_date_picker.frame.height))
        startDateLabel.text = "Start Date:"
        startDateLabel.font = UIFont.boldSystemFont(ofSize: 20)
        startDateLabel.textColor = forestGreen
        startDateLabel.textAlignment = .left
        start_date_picker.addSubview(startDateLabel)
        
        let endDateLabel = UILabel(frame: CGRect(x: 10, y: 0, width: end_date_picker.frame.width, height: end_date_picker.frame.height))
        endDateLabel.text = "End Date:"
        endDateLabel.font = UIFont.boldSystemFont(ofSize: 20)
        endDateLabel.textColor = forestGreen
        endDateLabel.textAlignment = .left
        end_date_picker.addSubview(endDateLabel)
        
        // connect @objc func to buttons
        start_date_picker.addTarget(self, action: #selector(startDateChanged(picker: )), for: .valueChanged)
        end_date_picker.addTarget(self, action: #selector(endDateChanged(picker: )), for: .valueChanged)
        set_listing_image_bt.addTarget(self, action: #selector(handle_listing_image_upload(sender: )), for: .touchUpInside)
        create_listing_bt.addTarget(self, action: #selector(handle_create(sender: )), for: .touchUpInside)
        
        view.addSubview(scrollView)
        scrollView.addSubview(header_lb)
        scrollView.addSubview(title_field)
        scrollView.addSubview(description_field)
        scrollView.addSubview(item_quantity_field)
        scrollView.addSubview(item_weight_field)
        scrollView.addSubview(pickup_location_field)
        scrollView.addSubview(start_date_picker)
        scrollView.addSubview(end_date_picker)
        scrollView.addSubview(contact_info_field)
        scrollView.addSubview(listing_image)
        scrollView.addSubview(set_listing_image_bt)
        scrollView.addSubview(create_listing_bt)
    }
}
