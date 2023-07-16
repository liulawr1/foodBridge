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
        view.backgroundColor = robinBlue
        setup_UI()
        display_admin()
    }
    
    let title_lb: UILabel = {
        let lb = UILabel()
        lb.text = "Welcome to Food Bridge!"
        lb.font = UIFont.boldSystemFont(ofSize: 40)
        lb.textColor = .white
        lb.textAlignment = .center
        lb.numberOfLines = 0
        return lb
    }()
    
    let about_bt: UIButton = {
        let bt = UIButton()
        bt.setTitle("About Us", for: .normal)
        bt.backgroundColor = robinBlue
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        bt.setTitleColor(.white, for: .normal)
        bt.titleLabel?.textAlignment = .center
        bt.layer.borderColor = UIColor.white.cgColor
        bt.layer.borderWidth = 2
        bt.layer.cornerRadius = 20
        return bt
    }()
    
    let signup_bt: UIButton = {
        let bt = UIButton()
        bt.setTitle("Sign Up", for: .normal)
        bt.backgroundColor = robinBlue
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        bt.setTitleColor(.white, for: .normal)
        bt.titleLabel?.textAlignment = .center
        bt.layer.borderColor = UIColor.white.cgColor
        bt.layer.borderWidth = 2
        bt.layer.cornerRadius = 20
        return bt
    }()
    
    let login_bt: UIButton = {
        let bt = UIButton()
        bt.setTitle("Login", for: .normal)
        bt.backgroundColor = robinBlue
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        bt.setTitleColor(.white, for: .normal)
        bt.titleLabel?.textAlignment = .center
        bt.layer.borderColor = UIColor.white.cgColor
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
        iv.image = UIImage(named: "bridge")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    func display_admin() {
        print(user_db.dictionary(forKey: "user_0")!["email"]!)
        print(user_db.dictionary(forKey: "user_0")!["password"]!)
        users.append(user_db.dictionary(forKey: "user_0")!)
        print(users)
    }
    
    func setup_UI() {
        let top_margin: CGFloat = 75
        let elem_w: CGFloat = view.frame.width - 2 * left_margin
        title_lb.frame = CGRect(x: left_margin, y: top_margin, width: elem_w, height: 110)
        about_bt.frame = CGRect(x: left_margin, y: title_lb.center.y + title_lb.frame.height / 2 + elem_margin, width: elem_w, height: 48)
        signup_bt.frame = CGRect(x: left_margin, y: title_lb.center.y + title_lb.frame.height / 2 + 550, width: elem_w, height: 48)
        login_bt.frame = CGRect(x: left_margin, y: signup_bt.center.y + signup_bt.frame.height / 2 + elem_margin, width: elem_w, height: 48)
        bg_iv.frame = view.frame
        
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
