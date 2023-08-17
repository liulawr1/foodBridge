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
    let listing_image: UIImageView = {
       let iv = UIImageView()
        iv.frame = CGRect(x: 10, y: 10, width: 135, height: 135)
        iv.backgroundColor = .gray
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 10
        iv.clipsToBounds = true
        return iv
    }()
    
    let title_lb: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 28)
        lb.textColor = .white
        lb.frame = CGRect(x: 155, y: 15, width: 500, height: 30)
        return lb
    }()
    
    let list_date_lb: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 16)
        lb.textColor = .white
        lb.frame = CGRect(x: 155, y: 60, width: 500, height: 20)
        return lb
    }()
    
    let list_author_lb: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 16)
        lb.textColor = .white
        lb.frame = CGRect(x: 155, y: 85, width: 500, height: 20)
        return lb
    }()
    
    let details_bt: UIButton = {
        let bt = UIButton()
        bt.tintColor = .white
        
        let innerImageView = UIImageView()
        innerImageView.image = UIImage(systemName: "plus.magnifyingglass")
        innerImageView.frame.size.width = 35
        innerImageView.frame.size.height = 35
        innerImageView.frame.origin.x = 0
        innerImageView.frame.origin.y = 0
        bt.addSubview(innerImageView)
        
        bt.frame = CGRect(x: 350, y: 10, width: 35, height: 35)
        return bt
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(listing_image)
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
    
    let title_lb: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 28)
        lb.textColor = .white
        lb.frame = CGRect(x: 155, y: 15, width: 500, height: 30)
        return lb
    }()
    
    func setup_UI() {
        let top_margin: CGFloat = 80
        let elem_w: CGFloat = view.frame.width - 2 * left_margin
        title_lb.frame = CGRect(x: left_margin, y: top_margin, width: elem_w, height: elem_h)
        
        view.addSubview(title_lb)
    }
}
