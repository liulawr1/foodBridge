//
//  AboutVC.swift
//  Food Bridge
//
//  Created by Lawrence Liu on 6/22/23.
//

import Foundation
import UIKit

class AboutVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = robinBlue
        setup_UI()
        
        let back_bt = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(handle_back))
        back_bt.tintColor = .white
        navigationItem.leftBarButtonItem = back_bt
    }
    
    let title_lb: UILabel = {
        let lb = UILabel()
        lb.text = "About Us"
        lb.font = UIFont.boldSystemFont(ofSize: 45)
        lb.textColor = .white
        lb.textAlignment = .center
        return lb
    }()
    
    let description_lb: UILabel = {
        let lb = UILabel()
        lb.text = "Jonny has been responsible for bringing concepts to life for clients such as Nintendo, Estée Lauder, Oxfam, Scribner, Sony, and many others. His work has been recognised by One Show, ADC, Webby Awards, and Cannes Lions. When Jonny isn't busy educating people on the difference between fonts and typefaces, he can be found taking part in competitive tickling competitions across the UK."
        lb.font = UIFont.systemFont(ofSize: 20)
        lb.textColor = .white
        lb.textAlignment = .center
        lb.numberOfLines = 0
        return lb
    }()
    
    @objc func handle_back(sender: UIButton) {
        let vc = LaunchVC()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: false)
    }
    
    func setup_UI() {
        let top_margin: CGFloat = 90
        let elem_w: CGFloat = view.frame.width - 2 * left_margin
        let description_h: CGFloat = view.frame.height / 2
        title_lb.frame = CGRect(x: left_margin, y: top_margin, width: elem_w, height: elem_h)
        description_lb.frame = CGRect(x: left_margin, y: title_lb.center.y + title_lb.frame.height / 2 + elem_margin - 15, width: elem_w, height: description_h)
        
        view.addSubview(title_lb)
        view.addSubview(description_lb)
    }
}
