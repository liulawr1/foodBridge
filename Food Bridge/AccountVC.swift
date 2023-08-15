//
//  AccountVC.swift
//  Food Bridge
//
//  Created by Lawrence Liu on 7/8/23.
//

import Foundation
import UIKit
import FirebaseAuth

class AccountVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var image_data = Data()
    
    let refresher = UIRefreshControl()
    
    @objc func handle_refresh(sender: UIView) {
        let v = ProfileView()
        v.display_user_info()
        refresher.endRefreshing()
        print("refreshing...")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = robinBlue
        download_image_to_app()
        setup_UI()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handle_refresh(sender: )))
        view.addGestureRecognizer(tap)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    let header_lb: UILabel = {
        let lb = UILabel()
        lb.text = "My Profile"
        lb.font = UIFont.boldSystemFont(ofSize: 45)
        lb.textColor = .white
        lb.textAlignment = .center
        return lb
    }()
    
    let pfp_view: UIView = {
        let v = UIView()
        v.backgroundColor = lightRobinBlue
        v.layer.borderColor = UIColor.white.cgColor
        v.layer.borderWidth = 2
        v.layer.cornerRadius = 20
        return v
    }()
    
    let profile_picture: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = robinBlue
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 2
        iv.layer.cornerRadius = 100
        iv.clipsToBounds = true
        return iv
    }()
    
    let set_pfp_bt: UIButton = {
        let bt = UIButton()
        bt.setTitle("Set Profile Picture", for: .normal)
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
        profile_picture.image = selected_image
        image_data = selected_image.pngData()!
        self.dismiss(animated: true) {
            self.upload_image_to_firebase_storage()
        }
    }
    
    func upload_image_to_firebase_storage() {
        storage_ref.child("users/\(USER_ID)").child(PROFILE_PICTURE_PATH).child("\(USER_ID)_image.png").putData(image_data) { (metadata, err) in
            if let err = err {
                print(err.localizedDescription)
                return
            } else {
                print("successfully uploaded image to firebase storage")
            }
        }
    }
    
    func download_image_to_app() {
        storage_ref.child("users/\(USER_ID)").child(PROFILE_PICTURE_PATH).child("\(USER_ID)_image.png").downloadURL { (url, err) in
            if let err = err {
                print(err.localizedDescription)
                return
            } else {
                guard let downloadURL = url else {return}
                self.profile_picture.image = UIImage(systemName: "camera")
                
                if let data = try? Data(contentsOf: downloadURL) {
                    self.profile_picture.image = UIImage(data: data)
                }
                print("successfully downloaded image to app")
            }
        }
    }
    
    let signout_bt: UIButton = {
        let bt = UIButton()
        bt.setTitle("Sign Out", for: .normal)
        bt.backgroundColor = robinBlue
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        bt.setTitleColor(.white, for: .normal)
        bt.titleLabel?.textAlignment = .center
        bt.layer.borderColor = UIColor.white.cgColor
        bt.layer.borderWidth = 2
        bt.layer.cornerRadius = 20
        return bt
    }()
    
    @objc func handle_signout(sender: UIButton) {
        do {
            try Auth.auth().signOut()
            USER_EMAIL = ""
            USER_ID = ""
            let vc = LaunchVC()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: false)
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
    func setup_UI() {
        let top_margin: CGFloat = 80
        let elem_w: CGFloat = view.frame.width - 2 * left_margin
        let pfp_dim: CGFloat = 200
        header_lb.frame = CGRect(x: left_margin, y: top_margin, width: elem_w, height: elem_h)
        pfp_view.frame = CGRect(x: left_margin, y: header_lb.center.y + header_lb.frame.height / 2 + elem_margin, width: elem_w, height: 225)
        profile_picture.frame = CGRect(x: left_margin + 12, y: header_lb.center.y + header_lb.frame.height / 2 + elem_margin + 12, width: pfp_dim, height: pfp_dim)
        set_pfp_bt.frame = CGRect(x: view.frame.width / 2 + 40, y: header_lb.center.y + header_lb.frame.height / 2 + elem_margin + 80, width: elem_w / 3, height: elem_h + 10)
        let my_profile_view = ProfileView()
        my_profile_view.frame = CGRect(x: left_margin, y: pfp_view.center.y + pfp_view.frame.height / 2 + elem_margin, width: elem_w, height: 350)
        my_profile_view.backgroundColor = lightRobinBlue
        my_profile_view.layer.borderColor = UIColor.white.cgColor
        my_profile_view.layer.borderWidth = 2
        my_profile_view.layer.cornerRadius = 20
        signout_bt.frame = CGRect(x: left_margin, y: my_profile_view.center.y + my_profile_view.frame.height / 2 + elem_margin, width: elem_w, height: elem_h)
        
        // connect @objc func to buttons
        signout_bt.addTarget(self, action: #selector(handle_signout(sender: )), for: .touchUpInside)
        set_pfp_bt.addTarget(self, action: #selector(handle_pfp_upload(sender: )), for: .touchUpInside)
        
        view.addSubview(header_lb)
        view.addSubview(pfp_view)
        view.addSubview(profile_picture)
        view.addSubview(set_pfp_bt)
        view.addSubview(my_profile_view)
        view.addSubview(signout_bt)
    }
}
