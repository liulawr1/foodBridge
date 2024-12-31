//
//  LaunchVC.swift
//  Food Bridge
//
//  Created by Lawrence Liu on 6/14/23.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import GoogleSignIn

let left_margin: CGFloat = 20
let elem_margin: CGFloat = 15
let elem_h: CGFloat = 48

class LaunchVC: UIViewController {
//    private let googleSignInConfig = GIDConfiguration(clientID: "982254282417-htfvgocha22449hu18b1r3qm7ikl0b5j.apps.googleusercontent.com")
    
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
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 26)
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
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 26)
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
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 26)
        bt.titleLabel?.textAlignment = .center
        bt.layer.borderColor = forestGreen.cgColor
        bt.layer.borderWidth = 2
        bt.layer.cornerRadius = 20
        return bt
    }()
    
    let guest_bt: UIButton = {
        let bt = UIButton()
        bt.setTitle("Continue as Guest", for: .normal)
        bt.setTitleColor(forestGreen, for: .normal)
        bt.backgroundColor = lightGreen
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 26)
        bt.titleLabel?.textAlignment = .center
        bt.layer.borderColor = forestGreen.cgColor
        bt.layer.borderWidth = 2
        bt.layer.cornerRadius = 20
        return bt
    }()
    
    let googlelogin_bt: UIButton = {
        let bt = UIButton()
        bt.setTitle("Sign in with Google", for: .normal)
        bt.setTitleColor(UIColor.white, for: .normal)
        bt.backgroundColor = googleRed
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 26)
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
    
    @objc func handle_guest(sender: UIButton) {
        let cb = GuestControlBar()
        let nav = UINavigationController(rootViewController: cb)
        nav.modalPresentationStyle = .fullScreen
        isGuest = true
        self.present(nav, animated: true)
    }
    
    @objc func handle_googlelogin(sender: UIButton) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
                
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
                print("Sign in error")
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                print("Failed to get user")
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
            // Sign in with Firebase
            Auth.auth().signIn(with: credential) { [weak self] result, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Firebase sign in error: \(error.localizedDescription)")
                    return
                }
                
                // Successfully signed in
                let user = result?.user
                let newuserID = user?.uid
                let newemail = user?.email
                print("Signed in! UserId: \(newuserID!), Email: \(newemail!)")
                
                USER_ID = newuserID!
                USER_EMAIL = newemail!
                print(USER_ID + " " + USER_EMAIL)
                
                UserDefaults.standard.setValue(USER_EMAIL, forKey: "LastUserEmail")
                UserDefaults.standard.setValue(USER_ID, forKey: "LastUserID")
                
                db.collection("users").getDocuments { (querySnapshot, error) in
                    if let error = error {
                        print("Error getting documents: \(error)")
                    } else {
                        var isNewUser = true
                        
                        // check if user already exists
                        for document in querySnapshot!.documents {
                            if (USER_ID == document.documentID) {
                                let cb = ControlBar()
                                let nav = UINavigationController(rootViewController: cb)
                                nav.modalPresentationStyle = .fullScreen
                                self.present(nav, animated: true)
                                UserDefaults.standard.setValue(true, forKey: isLoggedIn)
                                isNewUser = false
                                break
                            }
                        }
                        
                        // if new user, add info to database
                        if (isNewUser) {
                            db.collection("users").document(USER_ID).setData([
                                "email": USER_EMAIL,
                                "user_type": "Individual",
                                "active_listings": 0,
                                "total_listings": 0
                            ]) { [self] err in
                                if let err = err {
                                    print("Error adding document: \(err)")
                                } else {
                                    print("Document successfully written!")
                                    
                                    let cb = ControlBar()
                                    let nav = UINavigationController(rootViewController: cb)
                                    nav.modalPresentationStyle = .fullScreen
                                    self.present(nav, animated: true)
                                    UserDefaults.standard.setValue(true, forKey: isLoggedIn)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    let bg_iv: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "FoodBridgeLogoinverted2")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    func setup_UI() {
        let top_margin: CGFloat = 75
        let elem_w: CGFloat = view.frame.width - 2 * left_margin
        let half_w = (elem_w - elem_margin) / 2
        let bottom_y: CGFloat = view.frame.height - 220
        title_lb.frame = CGRect(x: left_margin, y: top_margin, width: elem_w, height: 110)
        about_bt.frame = CGRect(x: left_margin, y: title_lb.center.y + title_lb.frame.height / 2 + elem_margin, width: elem_w, height: 48)
//        signup_bt.frame = CGRect(x: left_margin, y: bottom_y, width: half_w, height: 48)
//        login_bt.frame = CGRect(x: signup_bt.frame.maxX + elem_margin, y: bottom_y, width: half_w, height: 48)
        googlelogin_bt.frame = CGRect(x: left_margin, y: bottom_y, width: elem_w, height: 48)
        guest_bt.frame = CGRect(x: left_margin, y: googlelogin_bt.center.y + googlelogin_bt.frame.height / 2 + elem_margin, width: elem_w, height: 48)
        
        let bgX = (view.frame.width - elem_w) / 2
        let bgY = (view.frame.height - (about_bt.center.y + about_bt.frame.height / 2 + elem_margin + elem_w)) + 20
        bg_iv.frame = CGRect(x: bgX, y: bgY, width: elem_w, height: elem_w)
        
        // connect @objc func to buttons
        about_bt.addTarget(self, action: #selector(handle_about(sender: )), for: .touchUpInside)
        signup_bt.addTarget(self, action: #selector(handle_signup(sender: )), for: .touchUpInside)
        login_bt.addTarget(self, action: #selector(handle_login(sender: )), for: .touchUpInside)
        googlelogin_bt.addTarget(self, action: #selector(handle_googlelogin(sender: )), for: .touchUpInside)
        guest_bt.addTarget(self, action: #selector(handle_guest(sender: )), for: .touchUpInside)
        
        view.addSubview(bg_iv)
        view.addSubview(title_lb)
        view.addSubview(about_bt)
        //view.addSubview(signup_bt)
        //view.addSubview(login_bt)
        view.addSubview(googlelogin_bt)
        view.addSubview(guest_bt)
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
