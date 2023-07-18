//
//  BrowseVC.swift
//  Food Bridge
//
//  Created by Lawrence Liu on 7/8/23.
//

import Foundation
import UIKit

class BrowseVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = robinBlue
        setup_UI()
    }
    
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
    
    func setup_UI() {
        let top_margin: CGFloat = 90
        let elem_w: CGFloat = view.frame.width - 2 * left_margin
        search_bar.frame = CGRect(x: left_margin, y: top_margin, width: elem_w, height: elem_h)
        enter_bt.frame = CGRect(x: view.frame.width - 75, y: top_margin + 5, width: 50, height: elem_h - 10)
        
        // connect @objc func to buttons
        enter_bt.addTarget(self, action: #selector(handle_enter(sender: )), for: .touchUpInside)
        
        view.addSubview(search_bar)
        view.addSubview(enter_bt)
    }
}
