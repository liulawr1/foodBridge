//
//  Profile.swift
//  Food Bridge
//
//  Created by Lawrence Liu on 8/5/23.
//

import Foundation
import UIKit

class ProfileView: UIView {
    let email_lb: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 22)
        lb.textColor = .white
        lb.frame = CGRect(x: 15, y: 5, width: 500, height: elem_h)
        return lb
    }()
    
    let donor_type_lb: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 22)
        lb.textColor = .white
        lb.frame = CGRect(x: 15, y: 40, width: 500, height: elem_h)
        return lb
    }()
    
    let location_lb: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 22)
        lb.textColor = .white
        lb.frame = CGRect(x: 15, y: 75, width: 500, height: elem_h)
        return lb
    }()
    
    let active_listings_lb: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 22)
        lb.textColor = .white
        lb.frame = CGRect(x: 15, y: 110, width: 500, height: elem_h)
        return lb
    }()
    
    let total_listings_lb: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 22)
        lb.textColor = .white
        lb.frame = CGRect(x: 15, y: 145, width: 500, height: elem_h)
        return lb
    }()
    
    func display_user_info() {
        db.collection("users").getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if ((document.get("email") as! String) == USER_EMAIL) {
                        email_lb.text = "Email: \(USER_EMAIL ?? "Loading")"
                        donor_type_lb.text = "Donor Type: \(document.get("donor_type") as! String)"
                        location_lb.text = "Location: \(document.get("location") as! String)"
                        
                        guard let active_listings = (document.get("active_listings") as? Int) else { return }
                        let converted_int_active_listings = String(active_listings)
                        active_listings_lb.text = "Active Listings: \(converted_int_active_listings)"
                        
                        guard let total_listings = (document.get("total_listings") as? Int) else { return }
                        let converted_int_total_listings = String(total_listings)
                        total_listings_lb.text = "Total Listings: \(converted_int_total_listings)"
                    }
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        display_user_info()
        self.addSubview(email_lb)
        self.addSubview(donor_type_lb)
        self.addSubview(location_lb)
        self.addSubview(active_listings_lb)
        self.addSubview(total_listings_lb)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
