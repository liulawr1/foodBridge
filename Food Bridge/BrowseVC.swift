//
//  BrowseVC.swift
//  Food Bridge
//
//  Created by Lawrence Liu on 7/8/23.
//

import Foundation
import UIKit

class BrowseVC: UIViewController {
    var arr = [1, 2, 3, 4, 5]
    var listings_arr = [Listing]()
    lazy var h: CGFloat = view.frame.height / 5
    lazy var w: CGFloat = view.frame.width - 20
    var margin: CGFloat = 1.2
    lazy var sv_h: CGFloat = CGFloat(arr.count) * h * margin + 100
    
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
    
    let search_bar: UITextField = {
        let tf = UITextField()
        let attributedPlaceholder = NSAttributedString(
            string: "🔎 Search",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        tf.attributedPlaceholder = attributedPlaceholder
        tf.backgroundColor = lightRobinBlue
        tf.font = UIFont.boldSystemFont(ofSize: 20)
        tf.textColor = .white
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.layer.borderColor = UIColor.white.cgColor
        tf.layer.borderWidth = 2
        tf.layer.cornerRadius = 20
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: tf.frame.height))
        tf.leftView = paddingView
        tf.leftViewMode = .always
        
        return tf
    }()
    
    let enter_bt: UIButton = {
        let bt = UIButton()
        bt.setTitle("→", for: .normal)
        bt.backgroundColor = robinBlue
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        bt.setTitleColor(.white, for: .normal)
        bt.titleLabel?.textAlignment = .center
        bt.layer.borderColor = UIColor.white.cgColor
        bt.layer.borderWidth = 2
        bt.layer.cornerRadius = 15
        return bt
    }()
    
    @objc func handle_enter(sender: UIButton) {
        
    }
    
    func create_rows(n : Int) {
        for i in 0 ..< n {
            let listing = Listing()
            // fx = ax + b
            let x_cor: CGFloat = 10
            let y_cor: CGFloat = CGFloat(i) * h * margin + 75
            listing.frame = CGRect(x: x_cor, y: y_cor, width: w, height: h)
            listing.tag = i
            listings_arr.append(listing)
        }
    }
    
    func display_rows() {
        for i in 0 ..< listings_arr.count {
            listings_arr[i].backgroundColor = lightRobinBlue
            listings_arr[i].layer.borderColor = UIColor.white.cgColor
            listings_arr[i].layer.borderWidth = 2
            listings_arr[i].layer.cornerRadius = 10
            scrollView.addSubview(listings_arr[i])
        }
    }
    
    func setup_UI() {
        let top_margin: CGFloat = 0
        let elem_w: CGFloat = view.frame.width - 2 * left_margin
        scrollView.frame = view.frame
        scrollView.contentSize = CGSize(width: view.frame.width, height: sv_h)
        search_bar.frame = CGRect(x: left_margin, y: top_margin, width: elem_w, height: elem_h)
        enter_bt.frame = CGRect(x: view.frame.width - 75, y: top_margin + 5, width: 50, height: elem_h - 10)
        
        // connect @objc func to buttons
        enter_bt.addTarget(self, action: #selector(handle_enter(sender: )), for: .touchUpInside)
        
        view.addSubview(scrollView)
        scrollView.addSubview(search_bar)
        scrollView.addSubview(enter_bt)
        
        create_rows(n: arr.count)
        display_rows()
    }
}
