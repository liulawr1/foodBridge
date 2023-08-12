//
//  Listing.swift
//  Food Bridge
//
//  Created by Lawrence Liu on 7/15/23.
//

import Foundation
import UIKit
import FirebaseFirestore

class ListingView: UIView {
    let product_view: UIImageView = {
       let iv = UIImageView()
        iv.frame = CGRect(x: 10, y: 10, width: 135, height: 135)
        iv.backgroundColor = UIColor.gray
        iv.layer.cornerRadius = 10
        return iv
    }()
    
    let title_lb: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 28)
        lb.textColor = .white
        lb.frame = CGRect(x: 160, y: 10, width: 500, height: 30)
        return lb
    }()
    
    let list_date_lb: UILabel = {
        let lb = UILabel()
        lb.text = "Listed on: mm/dd/yy"
        lb.font = UIFont.boldSystemFont(ofSize: 18)
        lb.textColor = .white
        lb.frame = CGRect(x: 160, y: 45, width: 500, height: 20)
        return lb
    }()
    
    let list_author_lb: UILabel = {
        let lb = UILabel()
        lb.text = "Listed by: "
        lb.font = UIFont.boldSystemFont(ofSize: 18)
        lb.textColor = .white
        lb.frame = CGRect(x: 160, y: 70, width: 500, height: 20)
        return lb
    }()
    
    let details_bt: UIButton = {
        let bt = UIButton()
        bt.setTitle("Details", for: .normal)
        bt.backgroundColor = robinBlue
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        bt.setTitleColor(.white, for: .normal)
        bt.titleLabel?.textAlignment = .center
        bt.layer.borderColor = UIColor.white.cgColor
        bt.layer.borderWidth = 2
        bt.layer.cornerRadius = 15
        bt.frame = CGRect(x: 190, y: 105, width: 150, height: 40)
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
        self.addSubview(list_author_lb)
        self.addSubview(details_bt)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ListingVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = robinBlue
        setup_UI()
        
        let back_bt = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(handle_back))
        back_bt.tintColor = .white
        navigationItem.leftBarButtonItem = back_bt
    }
    
    @objc func handle_back() {
        let cb = ControlBar()
        let nav = UINavigationController(rootViewController: cb)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: false)
    }
    
    func setup_UI() {
//        let top_margin: CGFloat = 80
//        let elem_w: CGFloat = view.frame.width - 2 * left_margin
        
        
    }
}
