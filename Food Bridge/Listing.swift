//
//  Listing.swift
//  Food Bridge
//
//  Created by Lawrence Liu on 7/15/23.
//

import Foundation
import UIKit
import FirebaseFirestore

class Listing: UIView {
    let product_view: UIImageView = {
       let iv = UIImageView()
        iv.frame = CGRect(x: 10, y: 10, width: 165, height: 165)
        iv.backgroundColor = UIColor.gray
        return iv
    }()
    
    let title_lb: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 30)
        lb.textColor = .white
        lb.frame = CGRect(x: 190, y: 15, width: 500, height: 35)
        return lb
    }()
    
    let list_date_lb: UILabel = {
        let lb = UILabel()
        lb.text = "Listed on: mm/dd/yy"
        lb.font = UIFont.boldSystemFont(ofSize: 20)
        lb.textColor = .white
        lb.frame = CGRect(x: 190, y: 50, width: 500, height: 25)
        return lb
    }()
    
    let view_bt: UIButton = {
        let bt = UIButton()
        bt.setTitle("Tap to view →", for: .normal)
        bt.backgroundColor = robinBlue
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        bt.setTitleColor(.white, for: .normal)
        bt.titleLabel?.textAlignment = .center
        bt.layer.borderColor = UIColor.white.cgColor
        bt.layer.borderWidth = 2
        bt.layer.cornerRadius = 20
        bt.frame = CGRect(x: 190, y: 125, width: 200, height: 45)
        return bt
    }()
    
    let donor_lb: UILabel = {
        let lb = UILabel()
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(product_view)
        self.addSubview(title_lb)
        self.addSubview(list_date_lb)
        self.addSubview(view_bt)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ListingVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = robinBlue
    }
    
    func setup_UI() {
        
    }
}
