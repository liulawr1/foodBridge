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
        view.backgroundColor = lightGreen
        setup_UI()
        
        let back_bt = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(handle_back))
        back_bt.tintColor = forestGreen
        navigationItem.leftBarButtonItem = back_bt
    }
    
    let title_lb: UILabel = {
        let lb = UILabel()
        lb.text = "About Us"
        lb.font = UIFont.boldSystemFont(ofSize: 45)
        lb.textColor = forestGreen
        lb.textAlignment = .center
        return lb
    }()
    
    let description_lb: UILabel = {
        let lb = UILabel()
        lb.text = """
        Food Bridge is the answer to two pressing issues - food waste and food insecurity. Every year in the United States, a whopping 119 billion pounds of food goes to waste, while 34 million people, including 9 million children, face hunger. Our platform bridges the gap by connecting individuals and businesses with extra food to those in need. Users can easily list their available food items, set pick-up details, and share contact information. On the other side, individuals and organizations can find and collect the food. Food Bridge not only prevents food waste but ensures it reaches those in need, making a meaningful impact on both food waste and food insecurity.
        """
        lb.font = UIFont.systemFont(ofSize: 18)
        lb.textColor = forestGreen
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
        let description_h: CGFloat = 575
        title_lb.frame = CGRect(x: left_margin, y: top_margin, width: elem_w, height: elem_h)
        description_lb.frame = CGRect(x: left_margin, y: title_lb.center.y + title_lb.frame.height / 2 + elem_margin, width: elem_w, height: description_h)
        
        view.addSubview(title_lb)
        view.addSubview(description_lb)
    }
}
