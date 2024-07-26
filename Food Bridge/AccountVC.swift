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
    let scrollView = UIScrollView()
    
    func setup_refresh_control() {
        scrollView.refreshControl = UIRefreshControl()
        scrollView.refreshControl!.tintColor = .white
        scrollView.refreshControl?.addTarget(self, action: #selector(handle_refresh), for: .valueChanged)
    }
    
    @objc func handle_refresh() {
        if let profileView = scrollView.subviews.first(where: { $0 is ProfileView }) as? ProfileView {
            profileView.display_user_info()
        }
        print("refreshing...")
        
        DispatchQueue.main.async {
            self.scrollView.refreshControl?.endRefreshing()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = lightGreen
        download_image_to_app()
        setup_UI()
        setup_refresh_control()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    let header_lb: UILabel = {
        let lb = UILabel()
        lb.text = "My Profile"
        lb.font = UIFont.boldSystemFont(ofSize: 45)
        lb.textColor = forestGreen
        lb.textAlignment = .center
        return lb
    }()
    
    let pfp_view: UIView = {
        let v = UIView()
        v.backgroundColor = lightGreen
        v.layer.borderColor = forestGreen.cgColor
        v.layer.borderWidth = 2
        v.layer.cornerRadius = 20
        return v
    }()
    
    let profile_picture: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = lightGreen
        iv.contentMode = .scaleAspectFill
        iv.layer.borderColor = forestGreen.cgColor
        iv.layer.borderWidth = 2
        iv.layer.cornerRadius = 100
        iv.clipsToBounds = true
        return iv
    }()
    
    let set_pfp_bt: UIButton = {
        let bt = UIButton()
        bt.setTitle("Set Profile Picture", for: .normal)
        bt.backgroundColor = lightGreen
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        bt.setTitleColor(forestGreen, for: .normal)
        bt.titleLabel?.textAlignment = .center
        bt.layer.borderColor = forestGreen.cgColor
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
        guard let selected_image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
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
                guard let downloadURL = url else { return }
                self.profile_picture.image = UIImage(systemName: "person.slash")
                
                URLSession.shared.dataTask(with: downloadURL) { (data, response, error) in
                    if let error = error {
                        print("Error downloading image: \(error)")
                        return
                    }
                    
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async { [self] in
                            print(image.pngData()?.count as Any)
                            let compressedImage = image.jpeg(UIImage.JPEGQuality.lowest)
                            print(compressedImage?.count as Any)
                            self.profile_picture.image = UIImage(data: compressedImage!)
                        }
                    }
                }.resume()
                
                print("successfully downloaded image to app")
            }
        }
    }
    
    let signout_bt: UIButton = {
        let bt = UIButton()
        bt.setTitle("Sign Out", for: .normal)
        bt.backgroundColor = lightGreen
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        bt.setTitleColor(forestGreen, for: .normal)
        bt.titleLabel?.textAlignment = .center
        bt.layer.borderColor = forestGreen.cgColor
        bt.layer.borderWidth = 2
        bt.layer.cornerRadius = 20
        return bt
    }()
    
    let delete_account_bt: UIButton = {
        let bt = UIButton()
        bt.setTitle("Delete Account", for: .normal)
        bt.backgroundColor = lightGreen
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        bt.setTitleColor(forestGreen, for: .normal)
        bt.titleLabel?.textAlignment = .center
        bt.layer.borderColor = forestGreen.cgColor
        bt.layer.borderWidth = 2
        bt.layer.cornerRadius = 20
        return bt
    }()
    
    let warning_alert = UIAlertController(title: "Warning!", message: "Are you sure you want to delete your account?", preferredStyle: .alert)
    let success_alert = UIAlertController(title: "Success!", message: "Account successfully deleted", preferredStyle: .alert)
    let error_alert = UIAlertController(title: "Error!", message: "Error occurred while creating listing!", preferredStyle: .alert)
    let dismiss_alert = UIAlertAction(title: "OK", style: .default)
    
    func display_warning() {
        warning_alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(warning_alert, animated: true)
    }
    
    func display_success() {
        present(success_alert, animated: true)
        success_alert.addAction(dismiss_alert)
    }
    
    func display_error() {
        present(error_alert, animated: true)
        error_alert.addAction(dismiss_alert)
    }
    
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
    
    @objc func handle_delete_account(sender: UIButton) {
        let confirmAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.deleteAccount()
        }

        warning_alert.addAction(confirmAction)
        display_warning()
    }
    
    func deleteAccount() {
        let user = Auth.auth().currentUser

        user?.delete { [weak self] error in
            guard let self = self else { return }

            if let error = error {
                self.display_error()
            } else {
                let vc = LaunchVC()
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: false)
                self.display_success()
            }
        }
    }
    
    func setup_UI() {
        let top_margin: CGFloat = 0
        let elem_w: CGFloat = view.frame.width - 2 * left_margin
        let pfp_dim: CGFloat = 200
        
        scrollView.frame = view.bounds
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
        header_lb.frame = CGRect(x: left_margin, y: top_margin, width: elem_w, height: elem_h)
        pfp_view.frame = CGRect(x: left_margin, y: header_lb.center.y + header_lb.frame.height / 2 + elem_margin + 5, width: elem_w, height: 225)
        profile_picture.frame = CGRect(x: left_margin + 12, y: header_lb.center.y + header_lb.frame.height / 2 + elem_margin + 17, width: pfp_dim, height: pfp_dim)
        set_pfp_bt.frame = CGRect(x: view.frame.width / 2 + 40, y: header_lb.center.y + header_lb.frame.height / 2 + elem_margin + 85, width: elem_w / 3, height: elem_h + 10)
        let my_profile_view = ProfileView()
        my_profile_view.frame = CGRect(x: left_margin, y: pfp_view.center.y + pfp_view.frame.height / 2 + elem_margin, width: elem_w, height: 130)
        my_profile_view.backgroundColor = lightGreen
        my_profile_view.layer.borderColor = forestGreen.cgColor
        my_profile_view.layer.borderWidth = 2
        my_profile_view.layer.cornerRadius = 20
        signout_bt.frame = CGRect(x: left_margin, y: my_profile_view.center.y + my_profile_view.frame.height / 2 + elem_margin, width: elem_w, height: elem_h)
        delete_account_bt.frame = CGRect(x: left_margin, y: signout_bt.center.y + signout_bt.frame.height / 2 + elem_margin, width: elem_w, height: elem_h)
        
        // connect @objc func to buttons
        signout_bt.addTarget(self, action: #selector(handle_signout(sender: )), for: .touchUpInside)
        delete_account_bt.addTarget(self, action: #selector(handle_delete_account(sender: )), for: .touchUpInside)
        set_pfp_bt.addTarget(self, action: #selector(handle_pfp_upload(sender: )), for: .touchUpInside)
        
        view.addSubview(scrollView)
        scrollView.addSubview(header_lb)
        scrollView.addSubview(pfp_view)
        scrollView.addSubview(profile_picture)
        scrollView.addSubview(set_pfp_bt)
        scrollView.addSubview(my_profile_view)
        scrollView.addSubview(signout_bt)
        scrollView.addSubview(delete_account_bt)
    }
}
