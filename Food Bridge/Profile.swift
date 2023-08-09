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
        lb.text = "Email: \(USER_EMAIL ?? "Loading")"
        lb.font = UIFont.boldSystemFont(ofSize: 22)
        lb.textColor = .white
        lb.frame = CGRect(x: 15, y: 5, width: 500, height: elem_h)
        return lb
    }()
    
    let donor_type_lb: UILabel = {
        let lb = UILabel()
        lb.text = "Donor Type: "
        lb.font = UIFont.boldSystemFont(ofSize: 22)
        lb.textColor = .white
        lb.frame = CGRect(x: 15, y: 40, width: 500, height: elem_h)
        return lb
    }()
    
    let location_lb: UILabel = {
        let lb = UILabel()
        lb.text = "Location: "
        lb.font = UIFont.boldSystemFont(ofSize: 22)
        lb.textColor = .white
        lb.frame = CGRect(x: 15, y: 75, width: 500, height: elem_h)
        return lb
    }()
    
    let active_listings_lb: UILabel = {
        let lb = UILabel()
        lb.text = "Active Listings: "
        lb.font = UIFont.boldSystemFont(ofSize: 22)
        lb.textColor = .white
        lb.frame = CGRect(x: 15, y: 110, width: 500, height: elem_h)
        return lb
    }()
    
    let total_listings_lb: UILabel = {
        let lb = UILabel()
        lb.text = "Total Listings: "
        lb.font = UIFont.boldSystemFont(ofSize: 22)
        lb.textColor = .white
        lb.frame = CGRect(x: 15, y: 145, width: 500, height: elem_h)
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
