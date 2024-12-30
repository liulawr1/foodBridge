//
//  GuestControlBar.swift
//  Food Bridge
//
//  Created by Lawrence Liu on 12/29/24.
//

import Foundation
import UIKit

class GuestControlBar: UITabBarController {
    let vc1 = BrowseVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().backgroundColor = lightGreen
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().tintColor = forestGreen
        
        let back_bt = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(handle_back))
        back_bt.tintColor = forestGreen
        navigationItem.leftBarButtonItem = back_bt
        
        let item1 = UITabBarItem(title: "Browse", image: UIImage(systemName: "tray.full"), tag: 0)
        
        vc1.tabBarItem = item1
        
        viewControllers = [vc1]
    }
    
    @objc func handle_back() {
        let vc = LaunchVC()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        isGuest = false
        self.present(nav, animated: false)
    }
}
