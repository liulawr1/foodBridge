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
        self.title = "Account"
        
    }
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        return sv
    }()
    
    let myProfile_view: UIView = {
        let v = UIView()
        v.backgroundColor = skyBlue
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
        v.backgroundColor = skyBlue
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
        v.backgroundColor = skyBlue
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

    func setup_UI() {
        let top_margin: CGFloat = 75
        let elem_w: CGFloat = view.frame.width - 2 * left_margin
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + 1000)
        myProfile_view.frame = CGRect(x: left_margin, y: top_margin, width: elem_w, height: 250)
        myProfile_lb.frame = CGRect(x: left_margin, y: top_margin, width: elem_w, height: elem_h)
        myListings_view.frame = CGRect(x: left_margin, y: myProfile_view.center.y + myProfile_view.frame.height / 2 + elem_margin, width: elem_w, height: 400)
        myListings_lb.frame = CGRect(x: left_margin, y: myProfile_view.center.y + myProfile_view.frame.height / 2 + elem_margin, width: elem_w, height: elem_h)
        savedListings_view.frame = CGRect(x: left_margin, y: myListings_view.center.y + myListings_view.frame.height / 2 + elem_margin, width: elem_w, height: 400)
        savedListings_lb.frame = CGRect(x: left_margin, y: myListings_view.center.y + myListings_view.frame.height / 2 + elem_margin, width: elem_w, height: elem_h)
        
        view.addSubview(scrollView)
        scrollView.addSubview(myProfile_view)
        scrollView.addSubview(myProfile_lb)
        scrollView.addSubview(myListings_view)
        scrollView.addSubview(myListings_lb)
        scrollView.addSubview(savedListings_view)
        scrollView.addSubview(savedListings_lb)
    }
}
