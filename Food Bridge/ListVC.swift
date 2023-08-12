//
//  ListVC.swift
//  Food Bridge
//
//  Created by Lawrence Liu on 7/8/23.
//

import Foundation
import UIKit
import FirebaseFirestore

class ListVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var image_data = Data()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = robinBlue
        setup_UI()
    }
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        return sv
    }()
    
    let header_lb: UILabel = {
        let lb = UILabel()
        lb.text = "Create a Listing"
        lb.font = UIFont.boldSystemFont(ofSize: 45)
        lb.textColor = .white
        lb.textAlignment = .center
        return lb
    }()
    
    let title_field: UITextField = {
        let tf = UITextField()
        let attributedPlaceholder = NSAttributedString(
            string: "Title",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        tf.attributedPlaceholder = attributedPlaceholder
        tf.backgroundColor = lightRobinBlue
        tf.font = UIFont.boldSystemFont(ofSize: 20)
        tf.textColor = .white
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.layer.borderColor = UIColor.white.cgColor
        tf.layer.borderWidth = 2
        tf.layer.cornerRadius = 20
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: tf.frame.height))
        tf.leftView = paddingView
        tf.leftViewMode = .always
        
        return tf
    }()
    
    let description_field: UITextField = {
        let tf = UITextField()
        let attributedPlaceholder = NSAttributedString(
            string: "Description",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        tf.attributedPlaceholder = attributedPlaceholder
        tf.backgroundColor = lightRobinBlue
        tf.font = UIFont.boldSystemFont(ofSize: 20)
        tf.textColor = .white
        tf.contentVerticalAlignment = .top
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.layer.borderColor = UIColor.white.cgColor
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
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        tf.attributedPlaceholder = attributedPlaceholder
        tf.backgroundColor = lightRobinBlue
        tf.font = UIFont.boldSystemFont(ofSize: 20)
        tf.textColor = .white
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.layer.borderColor = UIColor.white.cgColor
        tf.layer.borderWidth = 2
        tf.layer.cornerRadius = 20
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: tf.frame.height))
        tf.leftView = paddingView
        tf.leftViewMode = .always
        
        return tf
    }()
    
    let start_time_picker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .time
        dp.minuteInterval = 15
        dp.backgroundColor = lightRobinBlue
        dp.tintColor = .white
        dp.layer.borderColor = UIColor.white.cgColor
        dp.layer.borderWidth = 2
        dp.layer.cornerRadius = 20
        dp.clipsToBounds = true
        dp.setValue(UIColor.white, forKeyPath: "textColor")
        return dp
    }()

    let end_time_picker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .time
        dp.minuteInterval = 15
        dp.backgroundColor = lightRobinBlue
        dp.tintColor = .white
        dp.layer.borderColor = UIColor.white.cgColor
        dp.layer.borderWidth = 2
        dp.layer.cornerRadius = 20
        dp.clipsToBounds = true
        return dp
    }()
    
    @objc func startTimeChanged(picker: UIDatePicker) {
        let startTime = picker.date
        print("Selected start time: \(startTime)")
    }

    @objc func endTimeChanged(picker: UIDatePicker) {
        let endTime = picker.date
        print("Selected end time: \(endTime)")
        
        if (endTime < start_time_picker.date) {
            let calendar = Calendar.current
            let newEndTime = calendar.date(byAdding: .minute, value: 15, to: start_time_picker.date) ?? Date()
            end_time_picker.setDate(newEndTime, animated: true)
        }
    }
    
    let contact_info_field: UITextField = {
        let tf = UITextField()
        let attributedPlaceholder = NSAttributedString(
            string: "Contact Info",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        tf.attributedPlaceholder = attributedPlaceholder
        tf.backgroundColor = lightRobinBlue
        tf.font = UIFont.boldSystemFont(ofSize: 20)
        tf.textColor = .white
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.layer.borderColor = UIColor.white.cgColor
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
        iv.backgroundColor = robinBlue
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 2
        iv.layer.cornerRadius = 10
        iv.clipsToBounds = true
        return iv
    }()
    
    let upload_listing_image_bt: UIButton = {
        let bt = UIButton()
        bt.setTitle("Upload Listing Image", for: .normal)
        bt.backgroundColor = robinBlue
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        bt.setTitleColor(.white, for: .normal)
        bt.titleLabel?.textAlignment = .center
        bt.layer.borderColor = UIColor.white.cgColor
        bt.layer.borderWidth = 2
        bt.layer.cornerRadius = 20
        bt.titleLabel?.numberOfLines = 0
        return bt
    }()
    
    @objc func handle_pfp_upload(sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        self.present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let selected_image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {return}
        listing_image.image = selected_image
        image_data = selected_image.pngData()!
        self.dismiss(animated: true) {
            self.upload_image_to_firebase_storage()
        }
    }
    
    func upload_image_to_firebase_storage() {
        storage_ref.child("listings/\(USER_ID)").child(LISTING_IMAGE_PATH).child("\(USER_ID)_image.png").putData(image_data) { (metadata, err) in
            if let err = err {
                print(err.localizedDescription)
                return
            } else {
                print("successfully uploaded image to firebase storage")
            }
        }
    }
    
    func download_image_to_app() {
        storage_ref.child("listings/\(USER_ID)").child(LISTING_IMAGE_PATH).child("\(USER_ID)_image.png").downloadURL { (url, err) in
            if let err = err {
                print(err.localizedDescription)
                return
            } else {
                guard let downloadURL = url else {return}
                self.listing_image.image = UIImage(systemName: "camera")
                
                if let data = try? Data(contentsOf: downloadURL) {
                    self.listing_image.image = UIImage(data: data)
                }
                print("successfully downloaded image to app")
            }
        }
    }
    
    let create_listing_bt: UIButton = {
        let bt = UIButton()
        bt.setTitle("Create Listing", for: .normal)
        bt.backgroundColor = robinBlue
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        bt.setTitleColor(.white, for: .normal)
        bt.titleLabel?.textAlignment = .center
        bt.layer.borderColor = UIColor.white.cgColor
        bt.layer.borderWidth = 2
        bt.layer.cornerRadius = 20
        return bt
    }()
    
    let error_lb: UILabel = {
        let lb = UILabel()
        lb.text = "Error occurred while creating listing!"
        lb.font = UIFont.boldSystemFont(ofSize: 20)
        lb.backgroundColor = robinBlue
        lb.textColor = .red
        lb.textAlignment = .center
        return lb
    }()
    
    let success_lb: UILabel = {
        let lb = UILabel()
        lb.text = "Listing successfully created!"
        lb.font = UIFont.boldSystemFont(ofSize: 20)
        lb.backgroundColor = robinBlue
        lb.textColor = .green
        lb.textAlignment = .center
        return lb
    }()
    
    func display_error() {
        let elem_w: CGFloat = view.frame.width - 2 * left_margin
        error_lb.frame = CGRect(x: left_margin, y: create_listing_bt.center.y + create_listing_bt.frame.height / 2 + elem_margin, width: elem_w, height: elem_h)
        view.addSubview(error_lb)
    }
    
    func display_success() {
        let elem_w: CGFloat = view.frame.width - 2 * left_margin
        success_lb.frame = CGRect(x: left_margin, y: create_listing_bt.center.y + create_listing_bt.frame.height / 2 + elem_margin, width: elem_w, height: elem_h)
        view.addSubview(success_lb)
    }
    
    func increase_listings_counter() {
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if ((document.get("email") as! String) == USER_EMAIL) {
                        let listingRef = db.collection("users").document("DC")
                        
                        listingRef.updateData([
                            "active_listings": true
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
        var ref: DocumentReference? = nil
        ref = db.collection("listings").addDocument(data: [
            "title": title_field.text!,
            "description": description_field.text!,
            "pickup_location": pickup_location_field.text!,
            "start_time": start_time_picker.date,
            "end_time": end_time_picker.date,
            "contact_info": (contact_info_field.text!)
        ]) { [self] err in
            if let err = err {
                print("Error adding document: \(err)")
                display_error()
            } else {
                print("Document added with ID: \(ref!.documentID)")
                display_success()
                increase_listings_counter()
            }
        }
    }
    
    func setup_UI() {
        let top_margin: CGFloat = 80
        let elem_w: CGFloat = view.frame.width - 2 * left_margin
        header_lb.frame = CGRect(x: left_margin, y: top_margin, width: elem_w, height: elem_h)
        title_field.frame = CGRect(x: left_margin, y: header_lb.center.y + header_lb.frame.height / 2 + elem_margin + 10, width: elem_w, height: elem_h)
        description_field.frame = CGRect(x: left_margin, y: title_field.center.y + title_field.frame.height / 2 + elem_margin, width: elem_w, height: elem_h * 5)
        pickup_location_field.frame = CGRect(x: left_margin, y: description_field.center.y + description_field.frame.height / 2 + elem_margin, width: elem_w, height: elem_h)
        start_time_picker.frame = CGRect(x: left_margin, y: pickup_location_field.center.y + pickup_location_field.frame.height / 2 + elem_margin, width: elem_w / 2 - 10, height: elem_h)
        end_time_picker.frame = CGRect(x: left_margin + elem_w / 2 + 10, y: pickup_location_field.center.y + pickup_location_field.frame.height / 2 + elem_margin, width: elem_w / 2 - 10, height: elem_h)
        contact_info_field.frame = CGRect(x: left_margin, y: start_time_picker.center.y + start_time_picker.frame.height / 2 + elem_margin, width: elem_w, height: elem_h)
        create_listing_bt.frame = CGRect(x: left_margin, y: contact_info_field.center.y + contact_info_field.frame.height / 2 + elem_margin, width: elem_w, height: elem_h)
        
        let startTimeLabel = UILabel(frame: CGRect(x: 5, y: 0, width: start_time_picker.frame.width, height: start_time_picker.frame.height))
        startTimeLabel.text = "Start Time:"
        startTimeLabel.font = UIFont.boldSystemFont(ofSize: 17)
        startTimeLabel.textColor = .white
        startTimeLabel.textAlignment = .left
        start_time_picker.addSubview(startTimeLabel)
        
        let endTimeLabel = UILabel(frame: CGRect(x: 5, y: 0, width: end_time_picker.frame.width, height: end_time_picker.frame.height))
        endTimeLabel.text = "End Time:"
        endTimeLabel.font = UIFont.boldSystemFont(ofSize: 17)
        endTimeLabel.textColor = .white
        endTimeLabel.textAlignment = .left
        end_time_picker.addSubview(endTimeLabel)
        
        // connect @objc func to buttons
        start_time_picker.addTarget(self, action: #selector(startTimeChanged(picker: )), for: .valueChanged)
        end_time_picker.addTarget(self, action: #selector(endTimeChanged(picker: )), for: .valueChanged)
        create_listing_bt.addTarget(self, action: #selector(handle_create(sender: )), for: .touchUpInside)
        
        view.addSubview(header_lb)
        view.addSubview(title_field)
        view.addSubview(description_field)
        view.addSubview(pickup_location_field)
        view.addSubview(start_time_picker)
        view.addSubview(end_time_picker)
        view.addSubview(contact_info_field)
        view.addSubview(create_listing_bt)
    }
}
