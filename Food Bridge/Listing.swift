//
//  Listing.swift
//  Food Bridge
//
//  Created by Lawrence Liu on 7/15/23.
//

import Foundation
import UIKit
import FirebaseFirestore

let listing_db = Firestore.firestore()

class Listing: UIView {
    let product_view: UIImageView = {
       let iv = UIImageView()
        iv.frame = CGRect(x: 10, y: 10, width: 100, height: 100)
        iv.backgroundColor = UIColor.gray
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(product_view)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
