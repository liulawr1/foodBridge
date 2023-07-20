//
//  AccountVC.swift
//  Food Bridge
//
//  Created by Lawrence Liu on 7/8/23.
//

import Foundation
import UIKit

class AccountVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = robinBlue
        setup_UI()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        return sv
    }()
    
    let myProfile_view: UIView = {
        let v = UIView()
        v.backgroundColor = lightRobinBlue
        v.layer.borderColor = UIColor.white.cgColor
        v.layer.borderWidth = 2
        v.layer.cornerRadius = 20
        return v
    }()
    
    let myProfile_lb: UILabel = {
        let lb = UILabel()
        lb.text = "My Profile"
        lb.font = UIFont.boldSystemFont(ofSize: 20)
        lb.textColor = .white
        lb.textAlignment = .center
        return lb
    }()
    
    let myListings_view: UIView = {
        let v = UIView()
        v.backgroundColor = lightRobinBlue
        v.layer.borderColor = UIColor.white.cgColor
        v.layer.borderWidth = 2
        v.layer.cornerRadius = 10
        return v
    }()
    
    let myListings_lb: UILabel = {
        let lb = UILabel()
        lb.text = "My Listings"
        lb.font = UIFont.boldSystemFont(ofSize: 20)
        lb.textColor = .white
        lb.textAlignment = .center
        return lb
    }()
    
    let savedListings_view: UIView = {
        let v = UIView()
        v.backgroundColor = lightRobinBlue
        v.layer.borderColor = UIColor.white.cgColor
        v.layer.borderWidth = 2
        v.layer.cornerRadius = 10
        return v
    }()
    
    let savedListings_lb: UILabel = {
        let lb = UILabel()
        lb.text = "Saved Listings"
        lb.font = UIFont.boldSystemFont(ofSize: 20)
        lb.textColor = .white
        lb.textAlignment = .center
        return lb
    }()
    
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
        let vc = LaunchVC()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: false)
    }

    func setup_UI() {
        let top_margin: CGFloat = 0
        let elem_w: CGFloat = view.frame.width - 2 * left_margin
        scrollView.frame = view.frame
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + 275)
        myProfile_view.frame = CGRect(x: left_margin, y: top_margin, width: elem_w, height: 250)
        myProfile_lb.frame = CGRect(x: left_margin, y: top_margin, width: elem_w, height: elem_h)
        myListings_view.frame = CGRect(x: left_margin, y: myProfile_view.center.y + myProfile_view.frame.height / 2 + elem_margin, width: elem_w, height: 400)
        myListings_lb.frame = CGRect(x: left_margin, y: myProfile_view.center.y + myProfile_view.frame.height / 2 + elem_margin, width: elem_w, height: elem_h)
        savedListings_view.frame = CGRect(x: left_margin, y: myListings_view.center.y + myListings_view.frame.height / 2 + elem_margin, width: elem_w, height: 400)
        savedListings_lb.frame = CGRect(x: left_margin, y: myListings_view.center.y + myListings_view.frame.height / 2 + elem_margin, width: elem_w, height: elem_h)
        signout_bt.frame = CGRect(x: left_margin, y: savedListings_view.center.y + savedListings_view.frame.height / 2 + elem_margin, width: elem_w, height: elem_h)
        
        // connect @objc func to buttons
        signout_bt.addTarget(self, action: #selector(handle_signout(sender: )), for: .touchUpInside)
        
        view.addSubview(scrollView)
        scrollView.addSubview(myProfile_view)
        scrollView.addSubview(myProfile_lb)
        scrollView.addSubview(myListings_view)
        scrollView.addSubview(myListings_lb)
        scrollView.addSubview(savedListings_view)
        scrollView.addSubview(savedListings_lb)
        scrollView.addSubview(signout_bt)
    }
}
