//
//  MainVC.swift
//  Food Bridge
//
//  Created by Lawrence Liu on 6/13/23.
//

import Foundation
import UIKit

class MainVC: UIViewController {
    var user_email: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = lightGreen
        setup_UI()
    }
    
    let user_info: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 18)
        lb.textColor = .white
        return lb
    }()
    
    let logout_bt: UIButton = {
        let bt = UIButton()
        bt.setTitle("Logout", for: .normal)
        bt.backgroundColor = lightGreen
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        bt.setTitleColor(.white, for: .normal)
        bt.titleLabel?.textAlignment = .center
        bt.layer.borderColor = UIColor.white.cgColor
        bt.layer.borderWidth = 2
        bt.layer.cornerRadius = 20
        return bt
    }()
    
    @objc func handle_logout(sender: UIButton) {
        let vc = LaunchVC()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: false)
    }
    
    func setup_UI() {
        print("Current user's email: \(user_email)")
        let top_margin: CGFloat = 90
        let elem_w: CGFloat = view.frame.width - 2 * left_margin
        let username = user_email.split(separator: "@").first ?? ""
        user_info.frame = CGRect(x: left_margin, y: top_margin, width: elem_w, height: elem_h)
        user_info.text = "Welcome, \(username)!"
        logout_bt.frame = CGRect(x: view.frame.width / 2, y: top_margin, width: elem_w / 2, height: elem_h)
        
        // connect @objc func to buttons
        logout_bt.addTarget(self, action: #selector(handle_logout(sender: )), for: .touchUpInside)
        
        view.addSubview(user_info)
        view.addSubview(logout_bt)
        
        /*
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
         let vc = storyboard.instantiateViewController(withIdentifier: "Demo")
         let nav = UINavigationController(rootViewController: vc)
         nav.modalPresentationStyle = .fullScreen
         self.present(nav, animated: true)
         */
    }
}
