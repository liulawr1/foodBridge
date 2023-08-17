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
    let scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = robinBlue
        setup_UI()
    }
    
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
    
    let description_field: UITextView = {
        let tv = UITextView()
        let attributedPlaceholder = NSAttributedString(
            string: "Description",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        tv.attributedText = attributedPlaceholder
        tv.backgroundColor = lightRobinBlue
        tv.font = UIFont.boldSystemFont(ofSize: 20)
        tv.textColor = .white
        tv.autocapitalizationType = .none
        tv.autocorrectionType = .no
        tv.layer.borderColor = UIColor.white.cgColor
        tv.layer.borderWidth = 2
        tv.layer.cornerRadius = 20
        
//        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: tv.frame.height))
//        tv.leftView = paddingView
//        tv.leftViewMode = .always
        
        return tv
    }()
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
    
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
        iv.backgroundColor = .gray
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 2
        iv.layer.cornerRadius = 15
        iv.clipsToBounds = true
        return iv
    }()
    
    let set_listing_image_bt: UIButton = {
        let bt = UIButton()
        bt.setTitle("Set Listing Image", for: .normal)
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
        bt.backgroundColor = robinBlue
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        bt.setTitleColor(.white, for: .normal)
        bt.titleLabel?.textAlignment = .center
        bt.layer.borderColor = UIColor.white.cgColor
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
    
//    let error_lb: UILabel = {
//        let lb = UILabel()
//        lb.text = "Error occurred while creating listing!"
//        lb.font = UIFont.boldSystemFont(ofSize: 20)
//        lb.backgroundColor = robinBlue
//        lb.textColor = .red
//        lb.textAlignment = .center
//        return lb
//    }()
//
//    let success_lb: UILabel = {
//        let lb = UILabel()
//        lb.text = "Listing successfully created!"
//        lb.font = UIFont.boldSystemFont(ofSize: 20)
//        lb.backgroundColor = robinBlue
//        lb.textColor = .green
//        lb.textAlignment = .center
//        return lb
//    }()
//
//    func display_error() {
//        let elem_w: CGFloat = view.frame.width - 2 * left_margin
//        error_lb.frame = CGRect(x: left_margin, y: create_listing_bt.center.y + create_listing_bt.frame.height / 2 + elem_margin, width: elem_w, height: elem_h)
//        view.addSubview(error_lb)
//    }
//
//    func display_success() {
//        let elem_w: CGFloat = view.frame.width - 2 * left_margin
//        success_lb.frame = CGRect(x: left_margin, y: create_listing_bt.center.y + create_listing_bt.frame.height / 2 + elem_margin, width: elem_w, height: elem_h)
//        view.addSubview(success_lb)
//    }
    
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
        var ref: DocumentReference? = nil
        ref = db.collection("listings").addDocument(data: [
            "title": title_field.text!,
            "description": description_field.text!,
            "pickup_location": pickup_location_field.text!,
            "start_time": start_time_picker.date,
            "end_time": end_time_picker.date,
            "contact_info": contact_info_field.text!,
            "list_date": list_date,
            "list_author": USER_EMAIL!.split(separator: "@").first ?? ""
        ]) { [self] err in
            if let err = err {
                print("Error adding document: \(err)")
                //display_error()
            } else {
                print("Document added with ID: \(ref!.documentID)")
                title_field.text = ""
                description_field.text = ""
                pickup_location_field.text = ""
                contact_info_field.text = ""
                increase_listings_counter()
                
                storage_ref.child("listings/\(ref!.documentID)").child(LISTING_IMAGE_PATH).child("\(ref!.documentID)_image.png").putData(image_data) { (metadata, err) in
                    if let err = err {
                        print(err.localizedDescription)
                        return
                    } else {
                        print("successfully uploaded image to firebase storage")
                    }
                }
                //display_success()
            }
        }
    }
    
    func setup_UI() {
        let top_margin: CGFloat = 0
        let elem_w: CGFloat = view.frame.width - 2 * left_margin
        let listing_image_dim: CGFloat = 150
        scrollView.frame = view.bounds
        header_lb.frame = CGRect(x: left_margin, y: top_margin, width: elem_w, height: elem_h)
        title_field.frame = CGRect(x: left_margin, y: header_lb.center.y + header_lb.frame.height / 2 + elem_margin + 10, width: elem_w, height: elem_h)
        description_field.frame = CGRect(x: left_margin, y: title_field.center.y + title_field.frame.height / 2 + elem_margin, width: elem_w, height: elem_h * 3.5)
        pickup_location_field.frame = CGRect(x: left_margin, y: description_field.center.y + description_field.frame.height / 2 + elem_margin, width: elem_w, height: elem_h)
        start_time_picker.frame = CGRect(x: left_margin, y: pickup_location_field.center.y + pickup_location_field.frame.height / 2 + elem_margin, width: elem_w / 2 - 10, height: elem_h)
        end_time_picker.frame = CGRect(x: left_margin + elem_w / 2 + 10, y: pickup_location_field.center.y + pickup_location_field.frame.height / 2 + elem_margin, width: elem_w / 2 - 10, height: elem_h)
        contact_info_field.frame = CGRect(x: left_margin, y: start_time_picker.center.y + start_time_picker.frame.height / 2 + elem_margin, width: elem_w, height: elem_h)
        listing_image.frame = CGRect(x: left_margin, y: contact_info_field.center.y + contact_info_field.frame.height / 2 + elem_margin, width: listing_image_dim, height: listing_image_dim)
        set_listing_image_bt.frame = CGRect(x: view.frame.width / 2 - 15, y: listing_image.center.y - 15, width: elem_w / 2, height: elem_h)
        create_listing_bt.frame = CGRect(x: left_margin, y: listing_image.center.y + listing_image.frame.height / 2 + elem_margin, width: elem_w, height: elem_h)
        
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
        set_listing_image_bt.addTarget(self, action: #selector(handle_listing_image_upload(sender: )), for: .touchUpInside)
        create_listing_bt.addTarget(self, action: #selector(handle_create(sender: )), for: .touchUpInside)
        
        view.addSubview(scrollView)
        scrollView.addSubview(header_lb)
        scrollView.addSubview(title_field)
        scrollView.addSubview(description_field)
        scrollView.addSubview(pickup_location_field)
        scrollView.addSubview(start_time_picker)
        scrollView.addSubview(end_time_picker)
        scrollView.addSubview(contact_info_field)
        scrollView.addSubview(listing_image)
        scrollView.addSubview(set_listing_image_bt)
        scrollView.addSubview(create_listing_bt)
    }
}
