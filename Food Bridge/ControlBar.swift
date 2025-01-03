//
//  ControlBar.swift
//  Food Bridge
//
//  Created by Lawrence Liu on 7/8/23.
//

import Foundation
import UIKit

class ControlBar: UITabBarController {
    let vc1 = BrowseVC()
    let vc2 = ListVC()
    //let vc3 = UINavigationController(rootViewController: MessagesVC())
    let vc3 = LeaderboardVC()
    let vc4 = AccountVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().backgroundColor = lightGreen
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().tintColor = forestGreen
        
        let item1 = UITabBarItem(title: "Browse", image: UIImage(systemName: "tray.full"), tag: 0)
        let item2 = UITabBarItem(title: "List", image: UIImage(systemName: "square.and.arrow.up"), tag: 1)
        //let item3 = UITabBarItem(title: "Messages", image: UIImage(systemName: "message.badge"), tag: 2)
        let item3 = UITabBarItem(title: "Leaderboard", image: UIImage(systemName: "list.number"), tag: 3)
        let item4 = UITabBarItem(title: "Account", image: UIImage(systemName: "person.crop.circle"), tag: 4)
        
        vc1.tabBarItem = item1
        vc2.tabBarItem = item2
        vc3.tabBarItem = item3
        vc4.tabBarItem = item4
        //vc5.tabBarItem = item5
        
        viewControllers = [vc1, vc2, vc3, vc4]
    }
}
