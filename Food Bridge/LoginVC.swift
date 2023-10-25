//
//  LoginVC.swift
//  Food Bridge
//
//  Created by Lawrence Liu on 6/15/23.
//

import Foundation
import UIKit
import FirebaseAuth

class LoginVC: UIViewController {
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
    
    let password_field: UITextField = {
        let tf = UITextField()
        let attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: forestGreen]
        )
        tf.attributedPlaceholder = attributedPlaceholder
        tf.isSecureTextEntry = true
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
    
    let submit_bt: UIButton = {
        let bt = UIButton()
        bt.setTitle("Submit", for: .normal)
        bt.setTitleColor(forestGreen, for: .normal)
        bt.backgroundColor = lightGreen
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        bt.titleLabel?.textAlignment = .center
        bt.layer.borderColor = forestGreen.cgColor
        bt.layer.borderWidth = 2
        bt.layer.cornerRadius = 20
        return bt
    }()
    
    let bg_iv: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "fruitsnveggies")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let warning1_alert = UIAlertController(title: "Failure!", message: "Incorrect email or password. Try again or create new account.", preferredStyle: .alert)
    let warning2_alert = UIAlertController(title: "Failure!", message: "Please fill in all required fields!", preferredStyle: .alert)
    let dismiss_alert = UIAlertAction(title: "OK", style: .default)
    
    func display_warning1() {
        present(warning1_alert, animated: true)
        warning1_alert.addAction(dismiss_alert)
    }
    
    func display_warning2() {
        present(warning2_alert, animated: true)
        warning2_alert.addAction(dismiss_alert)
    }
    
    func login(email: String, password: String) {
        let cb = ControlBar()
        let nav = UINavigationController(rootViewController: cb)
        nav.modalPresentationStyle = .fullScreen
        
        Auth.auth().signIn(withEmail: email, password: password) {
            [self] (result, error) in
            if let error = error {
                print(error.localizedDescription)
                display_warning1()
            } else {
                print("Login successful")
                
                if let currentUser = Auth.auth().currentUser {
                    USER_EMAIL = currentUser.email ?? ""
                    USER_ID = currentUser.uid
                }
                
                self.present(nav, animated: true)
            }
        }
    }

    @objc func handle_submit(sender: UIButton) {
        let email = email_field.text
        let password = password_field.text
        
        if (email != "" && password != "") {
            login(email: email!, password: password!)
        } else {
            display_warning2()
        }
    }
    
    func setup_UI() {
        let top_margin: CGFloat = 50
        let elem_w: CGFloat = view.frame.width - 2 * left_margin
        email_field.frame = CGRect(x: left_margin, y: top_margin, width: elem_w, height: elem_h)
        password_field.frame = CGRect(x: left_margin, y: email_field.center.y + email_field.frame.height / 2 + elem_margin, width: elem_w, height: elem_h)
        submit_bt.frame = CGRect(x: left_margin, y: password_field.center.y + password_field.frame.height / 2 + elem_margin, width: elem_w, height: elem_h)
        bg_iv.frame = CGRect(x: (view.frame.width - elem_w) / 2, y: view.frame.height - 300, width: elem_w, height: elem_h)
        
        // connect @objc func to buttons
        submit_bt.addTarget(self, action: #selector(handle_submit(sender: )), for: .touchUpInside)
        
        view.addSubview(email_field)
        view.addSubview(password_field)
        view.addSubview(submit_bt)
        view.addSubview(bg_iv)
    }
}
