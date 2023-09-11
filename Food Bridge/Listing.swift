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
        iv.backgroundColor = .gray
        iv.contentMode = .scaleAspectFill
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 2
        iv.layer.cornerRadius = 10
        iv.clipsToBounds = true
        return iv
    }()
    
    let title_lb: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 28)
        lb.textColor = .white
        return lb
    }()
    
    let list_date_lb: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 16)
        lb.textColor = .white
        return lb
    }()
    
    let list_author_lb: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 16)
        lb.textColor = .white
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
    
    let description_lb: UILabel = {
        let lb = UILabel()
        return lb
    }()

    let pickup_location_lb: UILabel = {
        let lb = UILabel()
        return lb
    }()

    let start_time_lb: UILabel = {
        let lb = UILabel()
        return lb
    }()

    let end_time_lb: UILabel = {
        let lb = UILabel()
        return lb
    }()

    let contact_info_lb: UILabel = {
        let lb = UILabel()
        return lb
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
    let scrollView = UIScrollView()
    var title_string: String?
    var description_string: String?
    var pickup_location_string: String?
    var start_time_string: String?
    var end_time_string: String?
    var contact_info_string: String?
    var list_date_string: String?
    var list_author_string: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = robinBlue
        setup_UI()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        let back_bt = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(handle_back))
        back_bt.tintColor = .white
        navigationItem.leftBarButtonItem = back_bt
        
        title_lb.text = title_string
        description_lb.text = description_string
        pickup_location_lb.text = pickup_location_string
        start_time_lb.text = start_time_string
        end_time_lb.text = end_time_string
        contact_info_lb.text = contact_info_string
        list_date_lb.text = list_date_string
        list_author_lb.text = list_author_string
    }
    
    @objc func handle_back() {
        let cb = ControlBar()
        let nav = UINavigationController(rootViewController: cb)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: false)
    }
    
    let listing_image: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .gray
        iv.contentMode = .scaleAspectFill
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 2
        iv.layer.cornerRadius = 15
        iv.clipsToBounds = true
        return iv
    }()
    
    let title_lb: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 35)
        lb.textColor = .white
        lb.textAlignment = .center
        return lb
    }()
    
    let description_lb: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 18)
        lb.textColor = .white
        lb.numberOfLines = 0
        return lb
    }()
    
    let pickup_location_lb: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 18)
        lb.textColor = .white
        lb.numberOfLines = 0
        return lb
    }()
    
    let start_time_lb: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 18)
        lb.textColor = .white
        return lb
    }()
    
    let end_time_lb: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 18)
        lb.textColor = .white
        return lb
    }()
    
    let contact_info_lb: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 18)
        lb.textColor = .white
        return lb
    }()
    
    let list_date_lb: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 18)
        lb.textColor = .white
        return lb
    }()
    
    let list_author_lb: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 18)
        lb.textColor = .white
        return lb
    }()
    
    let end_listing_bt: UIButton = {
        let bt = UIButton()
        bt.setTitle("End Listing", for: .normal)
        bt.backgroundColor = robinBlue
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        bt.setTitleColor(.white, for: .normal)
        bt.titleLabel?.textAlignment = .center
        bt.layer.borderColor = UIColor.white.cgColor
        bt.layer.borderWidth = 2
        bt.layer.cornerRadius = 20
        return bt
    }()
    
    func setup_UI() {
        let top_margin: CGFloat = 0
        let elem_w: CGFloat = view.frame.width - 2 * left_margin
        let listing_image_dim: CGFloat = view.frame.width / 2 - left_margin * 2
        scrollView.frame = view.bounds
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + 75)
        title_lb.frame = CGRect(x: left_margin, y: top_margin, width: elem_w, height: elem_h)
        listing_image.frame = CGRect(x: left_margin, y: title_lb.center.y + title_lb.frame.height / 2 + elem_margin, width: listing_image_dim, height: listing_image_dim)
        list_date_lb.frame = CGRect(x: view.frame.width / 2 - 10, y: title_lb.center.y + title_lb.frame.height / 2 + elem_margin, width: elem_w, height: elem_h)
        list_author_lb.frame = CGRect(x: view.frame.width / 2 - 10, y: list_date_lb.center.y + list_date_lb.frame.height / 2 + elem_margin, width: elem_w, height: elem_h)
        description_lb.frame = CGRect(x: left_margin, y: listing_image.center.y + listing_image.frame.height / 2 + elem_margin, width: elem_w, height: elem_h * 3.5)
        pickup_location_lb.frame = CGRect(x: left_margin, y: description_lb.center.y + description_lb.frame.height / 2 + elem_margin, width: elem_w, height: elem_h)
        start_time_lb.frame = CGRect(x: left_margin, y: pickup_location_lb.center.y + pickup_location_lb.frame.height / 2 + elem_margin, width: elem_w, height: elem_h)
        end_time_lb.frame = CGRect(x: left_margin, y: start_time_lb.center.y + start_time_lb.frame.height / 2 + elem_margin, width: elem_w, height: elem_h)
        contact_info_lb.frame = CGRect(x: left_margin, y: end_time_lb.center.y + end_time_lb.frame.height / 2 + elem_margin, width: elem_w, height: elem_h)
        end_listing_bt.frame = CGRect(x: left_margin, y: contact_info_lb.center.y + contact_info_lb.frame.height / 2 + elem_margin, width: elem_w, height: elem_h)
        
        view.addSubview(scrollView)
        scrollView.addSubview(title_lb)
        scrollView.addSubview(listing_image)
        scrollView.addSubview(list_date_lb)
        scrollView.addSubview(list_author_lb)
        scrollView.addSubview(description_lb)
        scrollView.addSubview(pickup_location_lb)
        scrollView.addSubview(start_time_lb)
        scrollView.addSubview(end_time_lb)
        scrollView.addSubview(contact_info_lb)
        scrollView.addSubview(end_listing_bt)
    }
}
