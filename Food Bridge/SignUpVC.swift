//
//  SignUpVC.swift
//  Food Bridge
//
//  Created by Lawrence Liu on 6/14/23.
//

import Foundation
import UIKit
import FirebaseAuth

class SignUpVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = robinBlue
        setup_UI()
    }
    
    let email_field: UITextField = {
        let tf = UITextField()
        let attributedPlaceholder = NSAttributedString(
            string: "Email",
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
    
    let password_field: UITextField = {
        let tf = UITextField()
        let attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        tf.attributedPlaceholder = attributedPlaceholder
        tf.isSecureTextEntry = true
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
    
    let password_confirmation_field: UITextField = {
        let tf = UITextField()
        let attributedPlaceholder = NSAttributedString(
            string: "Password Confirmation",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        tf.attributedPlaceholder = attributedPlaceholder
        tf.isSecureTextEntry = true
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
    
    let submit_bt: UIButton = {
        let bt = UIButton()
        bt.setTitle("Submit", for: .normal)
        bt.backgroundColor = robinBlue
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        bt.setTitleColor(.white, for: .normal)
        bt.titleLabel?.textAlignment = .center
        bt.layer.borderColor = UIColor.white.cgColor
        bt.layer.borderWidth = 2
        bt.layer.cornerRadius = 20
        return bt
    }()
    
    let warning1_lb: UILabel = {
        let lb = UILabel()
        lb.text = "Passwords do not match!"
        lb.font = UIFont.boldSystemFont(ofSize: 16)
        lb.backgroundColor = robinBlue
        lb.textColor = .red
        lb.textAlignment = .center
        return lb
    }()
    
    let warning2_lb: UILabel = {
        let lb = UILabel()
        lb.text = "Please fill in all required fields!"
        lb.font = UIFont.boldSystemFont(ofSize: 16)
        lb.backgroundColor = robinBlue
        lb.textColor = .red
        lb.textAlignment = .center
        return lb
    }()
    
    func display_warning1() {
        let elem_w: CGFloat = view.frame.width - 2 * left_margin
        warning1_lb.frame = CGRect(x: left_margin, y: submit_bt.center.y + submit_bt.frame.height / 2 + elem_margin, width: elem_w, height: elem_h)
        view.addSubview(warning1_lb)
    }
    
    func display_warning2() {
        let elem_w: CGFloat = view.frame.width - 2 * left_margin
        warning2_lb.frame = CGRect(x: left_margin, y: submit_bt.center.y + submit_bt.frame.height / 2 + elem_margin, width: elem_w, height: elem_h)
        view.addSubview(warning2_lb)
    }
    
    func sign_up(email: String, password: String) {
        let vc = LaunchVC()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        
        Auth.auth().createUser(withEmail: email, password: password) {
            (result, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Sign-up successful")
                self.present(nav, animated: true)
            }
        }
    }
    
    @objc func handle_submit(sender: UIButton) {
        let email = email_field.text
        let password = password_field.text
        let password_confirmation = password_confirmation_field.text
        
        if (email != "" && password != "" && password_confirmation != "") {
            if (password == password_confirmation) {
                sign_up(email: email!, password: password!)
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
        submit_bt.frame = CGRect(x: left_margin, y: password_confirmation_field.center.y + password_confirmation_field.frame.height / 2 + elem_margin, width: elem_w, height: elem_h)
        
        // connect @objc func to buttons
        submit_bt.addTarget(self, action: #selector(handle_submit(sender: )), for: .touchUpInside)
        
        view.addSubview(email_field)
        view.addSubview(password_field)
        view.addSubview(password_confirmation_field)
        view.addSubview(submit_bt)
    }
}
