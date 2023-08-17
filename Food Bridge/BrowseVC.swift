//
//  BrowseVC.swift
//  Food Bridge
//
//  Created by Lawrence Liu on 7/8/23.
//

import Foundation
import UIKit
import FirebaseFirestore

class BrowseVC: UIViewController {
    let scrollView = UIScrollView()
    var listings_arr = [ListingView]()
    lazy var h: CGFloat = view.frame.height / 6
    lazy var w: CGFloat = view.frame.width - 40
    var margin: CGFloat = 1.1
    lazy var sv_h: CGFloat = CGFloat(listings_arr.count) * h * margin + 1500
    let now_after: Double = 5
    
    func setup_refresh_control() {
        scrollView.refreshControl = UIRefreshControl()
        scrollView.refreshControl!.tintColor = .white
        scrollView.refreshControl?.addTarget(self, action: #selector(handle_refresh), for: .valueChanged)
    }
    
    @objc func handle_refresh() {
        update_listings()
        print("refreshing...")
        
        DispatchQueue.main.async {
            self.scrollView.refreshControl?.endRefreshing()
        }
    }
    
    func update_listings() {
        listings_arr.forEach { $0.removeFromSuperview() }
        listings_arr.removeAll()
        
        db.collection("listings").getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var i = 0
                var j = 0
                for document in querySnapshot!.documents {
                    let listing = ListingView()
                    // fx = ax + b
                    let x_cor: CGFloat = 20
                    let y_cor: CGFloat = CGFloat(i) * h * margin + 75
                    listing.frame = CGRect(x: x_cor, y: y_cor, width: w, height: h)
                    listing.tag = i
                    listings_arr.append(listing)
                    
                    listings_arr[i].backgroundColor = lightRobinBlue
                    listings_arr[i].layer.borderColor = UIColor.white.cgColor
                    listings_arr[i].layer.borderWidth = 2
                    listings_arr[i].layer.cornerRadius = 20
                    
                    storage_ref.child("listings/\(document.documentID)").child(LISTING_IMAGE_PATH).child("\(document.documentID)_image.png").downloadURL { [self] (url, err) in
                        if let err = err {
                            print(err.localizedDescription)
                            j += 1
                            return
                        } else {
                            guard let downloadURL = url else { return }

                            if let data = try? Data(contentsOf: downloadURL) {
                                listings_arr[j].listing_image.image = UIImage(data: data)
                                j += 1
                            }
                            print("successfully downloaded image to app")
                        }
                    }
                    
                    listings_arr[i].title_lb.text = (document.get("title") as! String)
                    listings_arr[i].list_date_lb.text = "Listed on: \(document.get("list_date") as! String)"
                    listings_arr[i].list_author_lb.text = "Listed by: \(document.get("list_author") as! String)"
                    listings_arr[i].details_bt.addTarget(self, action: #selector(handle_details(sender: )), for: .touchUpInside)
                    scrollView.addSubview(listings_arr[i])
                    i += 1
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = robinBlue
        setup_UI()
        setup_refresh_control()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
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
    
    @objc func handle_details(sender: UIButton) {
        let vc = ListingVC()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: false)
    }
    
    @objc func handle_enter(sender: UIButton) {
        let search_query = search_bar.text!
        
        listings_arr.forEach { $0.removeFromSuperview() }
        listings_arr.removeAll()
        
        db.collection("listings").getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var i = 0
                var j = 0
                for document in querySnapshot!.documents {
                    if search_query.isEmpty || (document.get("title") as! String).contains(search_query) {
                        let listing = ListingView()
                        // fx = ax + b
                        let x_cor: CGFloat = 20
                        let y_cor: CGFloat = CGFloat(i) * h * margin + 75
                        listing.frame = CGRect(x: x_cor, y: y_cor, width: w, height: h)
                        listing.tag = i
                        listings_arr.append(listing)
                        
                        listings_arr[i].backgroundColor = lightRobinBlue
                        listings_arr[i].layer.borderColor = UIColor.white.cgColor
                        listings_arr[i].layer.borderWidth = 2
                        listings_arr[i].layer.cornerRadius = 20
                        
                        storage_ref.child("listings/\(document.documentID)").child(LISTING_IMAGE_PATH).child("\(document.documentID)_image.png").downloadURL { [self] (url, err) in
                            if let err = err {
                                print(err.localizedDescription)
                                j += 1
                                return
                            } else {
                                guard let downloadURL = url else { return }

                                if let data = try? Data(contentsOf: downloadURL) {
                                    listings_arr[j].listing_image.image = UIImage(data: data)
                                    j += 1
                                }
                                print("successfully downloaded image to app")
                            }
                        }
                        
                        listings_arr[i].title_lb.text = (document.get("title") as! String)
                        listings_arr[i].list_date_lb.text = "Listed on: \(document.get("list_date") as! String)"
                        listings_arr[i].list_author_lb.text = "Listed by: \(document.get("list_author") as! String)"
                        listings_arr[i].details_bt.addTarget(self, action: #selector(handle_details(sender: )), for: .touchUpInside)
                        scrollView.addSubview(listings_arr[i])
                        i += 1
                    }
                }
            }
        }
    }
    
    func display_rows() {
        db.collection("listings").getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var i = 0
                var j = 0
                for document in querySnapshot!.documents {
                    let listing = ListingView()
                    // fx = ax + b
                    let x_cor: CGFloat = 20
                    let y_cor: CGFloat = CGFloat(i) * h * margin + 75
                    listing.frame = CGRect(x: x_cor, y: y_cor, width: w, height: h)
                    listing.tag = i
                    listings_arr.append(listing)
                    
                    listings_arr[i].backgroundColor = lightRobinBlue
                    listings_arr[i].layer.borderColor = UIColor.white.cgColor
                    listings_arr[i].layer.borderWidth = 2
                    listings_arr[i].layer.cornerRadius = 20
                    
                    storage_ref.child("listings/\(document.documentID)").child(LISTING_IMAGE_PATH).child("\(document.documentID)_image.png").downloadURL { [self] (url, err) in
                        if let err = err {
                            print(err.localizedDescription)
                            j += 1
                            return
                        } else {
                            guard let downloadURL = url else { return }
                            
                            if let data = try? Data(contentsOf: downloadURL) {
                                print("\(document.get("title")) image: \(document.documentID)")
                                let image = UIImage(data: data)
                                image?.jpegData(compressionQuality: 0.1)
                                listings_arr[j].listing_image.image = image
                                j += 1
                            }
                            print("successfully downloaded image to app")
                        }
                    }
                    
                    listings_arr[i].title_lb.text = (document.get("title") as! String)
                    listings_arr[i].list_date_lb.text = "Listed on: \(document.get("list_date") as! String)"
                    listings_arr[i].list_author_lb.text = "Listed by: \(document.get("list_author") as! String)"
                    listings_arr[i].details_bt.addTarget(self, action: #selector(handle_details(sender: )), for: .touchUpInside)
                    scrollView.addSubview(listings_arr[i])
                    i += 1
                }
            }
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
        
        display_rows()
    }
}
