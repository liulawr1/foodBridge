//
//  LaunchVC.swift
//  Food Bridge
//
//  Created by Lawrence Liu on 6/14/23.
//

import Foundation
import UIKit

let left_margin: CGFloat = 20
let elem_margin: CGFloat = 15
let elem_h: CGFloat = 48

class LaunchVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = lightGreen
        setup_UI()
    }
    
    let title_lb: UILabel = {
        let lb = UILabel()
        lb.text = "Food Bridge"
        lb.font = UIFont.boldSystemFont(ofSize: 60)
        lb.textColor = forestGreen
        lb.textAlignment = .center
        lb.numberOfLines = 0
        return lb
    }()
    
    let about_bt: UIButton = {
        let bt = UIButton()
        bt.setTitle("About Us", for: .normal)
        bt.setTitleColor(forestGreen, for: .normal)
        bt.backgroundColor = lightGreen
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        bt.titleLabel?.textAlignment = .center
        bt.layer.borderColor = forestGreen.cgColor
        bt.layer.borderWidth = 2
        bt.layer.cornerRadius = 20
        return bt
    }()
    
    let signup_bt: UIButton = {
        let bt = UIButton()
        bt.setTitle("Sign Up", for: .normal)
        bt.setTitleColor(forestGreen, for: .normal)
        bt.backgroundColor = lightGreen
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        bt.titleLabel?.textAlignment = .center
        bt.layer.borderColor = forestGreen.cgColor
        bt.layer.borderWidth = 2
        bt.layer.cornerRadius = 20
        return bt
    }()
    
    let login_bt: UIButton = {
        let bt = UIButton()
        bt.setTitle("Login", for: .normal)
        bt.setTitleColor(forestGreen, for: .normal)
        bt.backgroundColor = lightGreen
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        bt.titleLabel?.textAlignment = .center
        bt.layer.borderColor = forestGreen.cgColor
        bt.layer.borderWidth = 2
        bt.layer.cornerRadius = 20
        return bt
    }()
    
    @objc func handle_about(sender: UIButton) {
        let vc = AboutVC()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: false)
    }
    
    @objc func handle_signup(sender: UIButton) {
        let vc = SignUpVC()
        self.present(vc, animated: true)
    }
    
    @objc func handle_login(sender: UIButton) {
        let vc = LoginVC()
        self.present(vc, animated: true)
    }
    
    let bg_iv: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "FoodBridgeLogoinverted")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    func setup_UI() {
        let top_margin: CGFloat = 75
        let elem_w: CGFloat = view.frame.width - 2 * left_margin
        title_lb.frame = CGRect(x: left_margin, y: top_margin, width: elem_w, height: 110)
        about_bt.frame = CGRect(x: left_margin, y: title_lb.center.y + title_lb.frame.height / 2 + elem_margin, width: elem_w, height: 48)
        signup_bt.frame = CGRect(x: left_margin, y: view.frame.height - 210, width: elem_w, height: 48)
        login_bt.frame = CGRect(x: left_margin, y: signup_bt.center.y + signup_bt.frame.height / 2 + elem_margin, width: elem_w, height: 48)
        
        let bgX = (view.frame.width - elem_w) / 2
        let bgY = (view.frame.height - (about_bt.center.y + about_bt.frame.height / 2 + elem_margin + elem_w)) + 40
        bg_iv.frame = CGRect(x: bgX, y: bgY, width: elem_w, height: elem_w)
        
        // connect @objc func to buttons
        about_bt.addTarget(self, action: #selector(handle_about(sender: )), for: .touchUpInside)
        signup_bt.addTarget(self, action: #selector(handle_signup(sender: )), for: .touchUpInside)
        login_bt.addTarget(self, action: #selector(handle_login(sender: )), for: .touchUpInside)
        
        view.addSubview(bg_iv)
        view.addSubview(title_lb)
        view.addSubview(about_bt)
        view.addSubview(signup_bt)
        view.addSubview(login_bt)
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest = 0
        case low = 0.25
        case medium = 0.5
        case high = 0.75
        case highest = 1
    }
    
    func jpeg(_ jpegQuality : JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}
