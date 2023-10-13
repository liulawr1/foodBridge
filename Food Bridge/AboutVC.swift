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
        lb.text = """
        According to Feeding America, 119 billion pounds of food is wasted annually in the United States, while 34 million people, including 9 million children, face hunger. Food waste not only leads to environmental issues, such as climate change, but also relates to food insecurity. The wasted food in the landfill rots and produces methane, a greenhouse gas even more potent than carbon dioxide. Global food loss and waste generate 8%-10% of emissions of the gases responsible for global warming.
        
        Food Bridge aims to fight food waste and food insecurity issues. It connects organizations and individuals with extra food with other organizations and people in need. Users could be individuals or businesses, such as farms, food banks, grocery stores, and restaurants. Users can log in to the application and upload any food they wish to donate. They can list food items, addresses, pick-up times, and contact information. At the same time, organizations or individuals in need can discover different listings and pick up the food at their convenience. Food Bridge will prevent food waste and ensure that it reaches those in need, solving the problems of both food waste and food insecurity.
        """
        lb.font = UIFont.systemFont(ofSize: 16)
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
        let description_h: CGFloat = 575
        title_lb.frame = CGRect(x: left_margin, y: top_margin, width: elem_w, height: elem_h)
        description_lb.frame = CGRect(x: left_margin, y: title_lb.center.y + title_lb.frame.height / 2 + elem_margin, width: elem_w, height: description_h)
        
        view.addSubview(title_lb)
        view.addSubview(description_lb)
    }
}
