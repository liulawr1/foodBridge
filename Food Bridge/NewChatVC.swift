//
//  NewChatVC.swift
//  Food Bridge
//
//  Created by Lawrence Liu on 12/31/24.
//

import Foundation
import UIKit
import FirebaseFirestore

class NewChatVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = lightGreen
        setup_UI()
    }
    
    let header_lb: UILabel = {
        let lb = UILabel()
        lb.text = "Draft a Message"
        lb.font = UIFont.boldSystemFont(ofSize: 36)
        lb.textColor = forestGreen
        lb.textAlignment = .center
        return lb
    }()
    
    let email_field: UITextField = {
        let tf = UITextField()
        let attributedPlaceholder = NSAttributedString(
            string: "Recipient's Email",
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
    
    let message_field: UITextField = {
        let tf = UITextField()
        let attributedPlaceholder = NSAttributedString(
            string: "Message",
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
    
    let send_bt: UIButton = {
        let bt = UIButton()
        bt.setTitle("Send", for: .normal)
        bt.backgroundColor = lightGreen
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        bt.setTitleColor(forestGreen, for: .normal)
        bt.titleLabel?.textAlignment = .center
        bt.layer.borderColor = forestGreen.cgColor
        bt.layer.borderWidth = 2
        bt.layer.cornerRadius = 20
        return bt
    }()
    
    let success_alert = UIAlertController(title: "Success!", message: "Message successfully sent!", preferredStyle: .alert)
    let dismiss_alert = UIAlertAction(title: "OK", style: .default)
    
    func display_success() {
        present(success_alert, animated: true)
        success_alert.addAction(dismiss_alert)
    }
    
    @objc func handle_send(sender: UIButton) {
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        
        let senderID = USER_ID
        let message = message_field.text
        let timestamp = formatter.string(from: currentDateTime)
        let isSeen = 0
        
        // #1: use receiver email to find receiver id
        db.collection("users").getDocuments { [self] (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                var receiverID = ""
                for document in querySnapshot!.documents {
                    let email = document.get("email") as! String
                    if (email_field.text == email) {
                        receiverID = document.documentID
                    }
                }
                
                // #2: now, we have the complete info to store into firestore
                var ref: DocumentReference? = nil
                
                ref = db.collection("messages").addDocument(data: [
                    "senderID": senderID,
                    "receiverID": receiverID,
                    "message": message!,
                    "timestamp": timestamp,
                    "isSeen": isSeen
                ]) { [self] err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Document added with ID: \(ref!.documentID)")
                        display_success()
                    }
                }
            }
        }
    }
    
    func setup_UI() {
        let top_margin: CGFloat = 45
        let elem_w: CGFloat = view.frame.width - 2 * left_margin
        header_lb.frame = CGRect(x: left_margin, y: top_margin, width: elem_w, height: elem_h)
        email_field.frame = CGRect(x: left_margin, y: header_lb.center.y + header_lb.frame.height / 2 + elem_margin + 10, width: elem_w, height: elem_h)
        message_field.frame = CGRect(x: left_margin, y: email_field.center.y + email_field.frame.height / 2 + elem_margin, width: elem_w, height: elem_h)
        send_bt.frame = CGRect(x: left_margin, y: message_field.center.y + message_field.frame.height / 2 + elem_margin + 20, width: elem_w, height: elem_h)
        
        // connect @objc func to buttons
        send_bt.addTarget(self, action: #selector(handle_send(sender: )), for: .touchUpInside)
        
        view.addSubview(header_lb)
        view.addSubview(email_field)
        view.addSubview(message_field)
        view.addSubview(send_bt)
    }
}
