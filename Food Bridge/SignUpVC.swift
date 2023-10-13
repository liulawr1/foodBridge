//
//  SignUpVC.swift
//  Food Bridge
//
//  Created by Lawrence Liu on 6/14/23.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignUpVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = lightGreen
        setup_UI()
        
        self.hideKeyboardWhenTappedAround()
    }
    
    let email_field: UITextField = {
        let tf = UITextField()
        let attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        tf.attributedPlaceholder = attributedPlaceholder
        tf.backgroundColor = lightGreen
        tf.font = UIFont.boldSystemFont(ofSize: 20)
        tf.textColor = forestGreen
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
    
    let password_field: UITextField = {
        let tf = UITextField()
        let attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        tf.attributedPlaceholder = attributedPlaceholder
        tf.isSecureTextEntry = true
        tf.backgroundColor = lightGreen
        tf.font = UIFont.boldSystemFont(ofSize: 20)
        tf.textColor = forestGreen
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
    
    let password_confirmation_field: UITextField = {
        let tf = UITextField()
        let attributedPlaceholder = NSAttributedString(
            string: "Password Confirmation",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        tf.attributedPlaceholder = attributedPlaceholder
        tf.isSecureTextEntry = true
        tf.backgroundColor = lightGreen
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
    
    let user_type_field: UITextField = {
        let tf = UITextField()
        let attributedPlaceholder = NSAttributedString(
            string: "User Type",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        tf.attributedPlaceholder = attributedPlaceholder
        tf.backgroundColor = lightGreen
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
    
    let submit_bt: UIButton = {
        let bt = UIButton()
        bt.setTitle("Submit", for: .normal)
        bt.backgroundColor = lightGreen
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        bt.setTitleColor(.white, for: .normal)
        bt.titleLabel?.textAlignment = .center
        bt.layer.borderColor = UIColor.white.cgColor
        bt.layer.borderWidth = 2
        bt.layer.cornerRadius = 20
        return bt
    }()
    
    let success_alert = UIAlertController(title: "Success!", message: "Account successfully created!", preferredStyle: .alert)
    let warning1_alert = UIAlertController(title: "Failure!", message: "Passwords do not match!", preferredStyle: .alert)
    let warning2_alert = UIAlertController(title: "Failure!", message: "Please fill in all required fields!", preferredStyle: .alert)
    let error_alert = UIAlertController(title: "Error!", message: "Error occurred while creating account!", preferredStyle: .alert)
    let dismiss_alert = UIAlertAction(title: "OK", style: .default)
    
    func display_success() {
        present(success_alert, animated: true)
        success_alert.addAction(dismiss_alert)
    }
    
    func display_warning1() {
        present(warning1_alert, animated: true)
        warning1_alert.addAction(dismiss_alert)
    }
    
    func display_warning2() {
        present(warning2_alert, animated: true)
        warning2_alert.addAction(dismiss_alert)
    }
    
    func display_error() {
        present(error_alert, animated: true)
        error_alert.addAction(dismiss_alert)
    }
    
    func sign_up(email: String, password: String, user_type: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [self] (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let authResult = authResult {
                print("Sign-up successful")
                let uid = authResult.user.uid
                
                db.collection("users").document(uid).setData([
                    "email": email,
                    "user_type": user_type,
                    "active_listings": 0,
                    "total_listings": 0
                ]) { [self] err in
                    if let err = err {
                        print("Error adding document: \(err)")
                        display_error()
                    } else {
                        print("Document successfully written!")
                        
                        let vc = LaunchVC()
                        let nav = UINavigationController(rootViewController: vc)
                        nav.modalPresentationStyle = .fullScreen
                        self.present(nav, animated: true)
                    }
                }
            }
        }
    }
    
    @objc func handle_submit(sender: UIButton) {
        let email = email_field.text
        let password = password_field.text
        let password_confirmation = password_confirmation_field.text
        let user_type = user_type_field.text
        
        if (email != "" && password != "" && password_confirmation != "") {
            if (password == password_confirmation) {
                sign_up(email: email!, password: password!, user_type: user_type!)
                display_success()
            } else {
                display_warning1()
            }
        } else {
            display_warning2()
        }
    }
    
    func setup_UI() {
        let top_margin: CGFloat = 50
        let elem_w: CGFloat = view.frame.width - 2 * left_margin
        email_field.frame = CGRect(x: left_margin, y: top_margin, width: elem_w, height: elem_h)
        password_field.frame = CGRect(x: left_margin, y: email_field.center.y + email_field.frame.height / 2 + elem_margin, width: elem_w, height: elem_h)
        password_confirmation_field.frame = CGRect(x: left_margin, y: password_field.center.y + password_field.frame.height / 2 + elem_margin, width: elem_w, height: elem_h)
        user_type_field.frame = CGRect(x: left_margin, y: password_confirmation_field.center.y + password_confirmation_field.frame.height / 2 + elem_margin, width: elem_w, height: elem_h)
        submit_bt.frame = CGRect(x: left_margin, y: user_type_field.center.y + user_type_field.frame.height / 2 + elem_margin, width: elem_w, height: elem_h)
        
        // connect @objc func to buttons
        submit_bt.addTarget(self, action: #selector(handle_submit(sender: )), for: .touchUpInside)
        
        view.addSubview(email_field)
        view.addSubview(password_field)
        view.addSubview(password_confirmation_field)
        view.addSubview(user_type_field)
        view.addSubview(submit_bt)
    }
}
