//
//  ViewController.swift
//  Food Bridge
//
//  Created by Lawrence Liu on 6/13/23.
//

import SwiftUI
import UIKit

class Test: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //    var arr = [1, 2, 3, 4, 5, 6, 7]
    //    var cards_arr = [UIView]()
    //
    //    func create_rows(n: Int) {
    //        let h: CGFloat = view.frame.height / 5
    //        let w: CGFloat = view.frame.width - 20
    //        let margin: CGFloat = 1.2
    //
    //        let sc = UIScrollView()
    //        let h_sc: CGFloat = CGFloat(n) * h * margin + 30
    //        sc.frame = view.frame
    //        sc.contentSize = CGSize(width: view.frame.width, height: h_sc)
    //        view.addSubview(sc)
    //
    //        for i in 0 ..< n {
    //            let card = UIView()
    //            // fx = ax + b
    //            let x_cor: CGFloat = 10
    //            let y_cor: CGFloat = CGFloat(i) * h * margin + 70
    //            card.frame = CGRect(x: x_cor, y: y_cor, width: w, height: h)
    //            card.tag = i
    //            card.backgroundColor = UIColor.systemBlue
    //            cards_arr.append(card)
    //            sc.addSubview(card)
    //        }
    //    }
    //
    //    func sign_up(email: String, password: String) {
    //        if (email != "" && password != "") {
    //            Auth.auth().createUser(withEmail: email, password: password) {
    //                (result, err) in
    //                if let err = err {
    //                    print(err.localizedDescription)
    //                } else {
    //                    if let result = result {
    //                        print("111")
    //                    } else {
    //                        print("result is wrong")
    //                    }
    //                }
    //            }
    //        } else {
    //            print("please enter valid email and password")
    //        }
    //    }
    //
    //    func login(email: String, password: String) {
    //        Auth.auth().signIn(withEmail: email, password: password) {
    //            (result, err) in
    //            if err != nil {
    //                print("username label is displaying: ", result?.user.email)
    //            }
    //        }
    //
    //        if Auth.auth().currentUser != nil {
    //            print(Auth.auth().currentUser?.uid)
    //        } else {
    //
    //        }
    //    }
}
