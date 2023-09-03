//
//  BrowseVC.swift
//  Food Bridge
//
//  Created by Lawrence Liu on 7/8/23.
//

import Foundation
import UIKit
import FirebaseFirestore

extension UIImage {
	enum JPEGQuality : CGFloat {
		case lowest = 0
		case low = 0.25
		case medium = 0.5
		case high = 0.75
		case highest = 1
	}
	
	func jpeg(_ jpegQuality : JPEGQuality) -> Data? {
		return jpegData(compressionQuality: jpegQuality.rawValue)
	}
}

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
                for (index, document) in querySnapshot!.documents.enumerated() {
                    let listing = ListingView()
                    // fx = ax + b
                    let x_cor: CGFloat = 20
                    let y_cor: CGFloat = CGFloat(index) * h * margin + 75
                    listing.frame = CGRect(x: x_cor, y: y_cor, width: w, height: h)
                    listing.tag = index
                    listings_arr.append(listing)
                    
                    listings_arr[index].backgroundColor = lightRobinBlue
                    listings_arr[index].layer.borderColor = UIColor.white.cgColor
                    listings_arr[index].layer.borderWidth = 2
                    listings_arr[index].layer.cornerRadius = 20
                    
					storage_ref.child("listings/\(document.documentID)").child(LISTING_IMAGE_PATH).child("\(document.documentID)_image.png").downloadURL { [self] (url, err) in
						if let err = err {
							print(err.localizedDescription)
							return
						} else {
							guard let downloadURL = url else { return }
							URLSession.shared.dataTask(with: downloadURL) { (data, response, error) in
								if let error = error {
									print("Error downloading image: \(error)")
									return
								}
								
								if let data = data, let image = UIImage(data: data) {
									DispatchQueue.main.async { [self] in
										let compressedImage = image.jpeg(UIImage.JPEGQuality.low)
										listings_arr[index].listing_image.image = UIImage(data: compressedImage!)
									}
								}
							}.resume()
							
							print("successfully downloaded image to app")
						}
					}
                    
                    listings_arr[index].title_lb.text = (document.get("title") as! String)
					listings_arr[index].description_lb.text = (document.get("description") as! String)
					listings_arr[index].pickup_location_lb.text = (document.get("pickup_location") as! String)
					//listings_arr[index].start_time_lb.text = (document.get("start_time") as! String)
					//listings_arr[index].end_time_lb.text = (document.get("end_time") as! String)
					listings_arr[index].contact_info_lb.text = (document.get("contact_info") as! String)
                    listings_arr[index].list_date_lb.text = "Listed on: \(document.get("list_date") as! String)"
                    listings_arr[index].list_author_lb.text = "Listed by: \(document.get("list_author") as! String)"
                    listings_arr[index].details_bt.addTarget(self, action: #selector(handle_details(sender: )), for: .touchUpInside)
					
					listings_arr[index].listing_image.frame = CGRect(x: 10, y: 10, width: h - 20, height: h - 20)
					listings_arr[index].title_lb.frame = CGRect(x: h, y: 15, width: 500, height: 30)
					listings_arr[index].list_date_lb.frame = CGRect(x: h, y: 60, width: 500, height: 30)
					listings_arr[index].list_author_lb.frame = CGRect(x: h, y: 85, width: 500, height: 30)
					listings_arr[index].details_bt.frame = CGRect(x: w - 45, y: 10, width: 35, height: 35)
					
                    scrollView.addSubview(listings_arr[index])
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
        let index = sender.tag
		
		vc.listing_image.image = listings_arr[index].listing_image.image
        vc.title_string = listings_arr[index].title_lb.text
        vc.description_string = listings_arr[index].description_lb.text
        vc.pickup_location_string = listings_arr[index].pickup_location_lb.text
        vc.start_time_string = listings_arr[index].start_time_lb.text
        vc.end_time_string = listings_arr[index].end_time_lb.text
        vc.contact_info_string = listings_arr[index].contact_info_lb.text
		vc.list_date_string = listings_arr[index].list_date_lb.text
		vc.list_author_string = listings_arr[index].list_author_lb.text
		
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
                for (index, document) in querySnapshot!.documents.enumerated() {
                    if search_query.isEmpty || (document.get("title") as! String).contains(search_query) {
                        let listing = ListingView()
                        // fx = ax + b
                        let x_cor: CGFloat = 20
                        let y_cor: CGFloat = CGFloat(index) * h * margin + 75
                        listing.frame = CGRect(x: x_cor, y: y_cor, width: w, height: h)
                        listing.tag = index
                        print(index)
                        listings_arr.append(listing)
                        
                        listings_arr[index].backgroundColor = lightRobinBlue
                        listings_arr[index].layer.borderColor = UIColor.white.cgColor
                        listings_arr[index].layer.borderWidth = 2
                        listings_arr[index].layer.cornerRadius = 20
                        
						storage_ref.child("listings/\(document.documentID)").child(LISTING_IMAGE_PATH).child("\(document.documentID)_image.png").downloadURL { [self] (url, err) in
							if let err = err {
								print(err.localizedDescription)
								return
							} else {
								guard let downloadURL = url else { return }
								URLSession.shared.dataTask(with: downloadURL) { (data, response, error) in
									if let error = error {
										print("Error downloading image: \(error)")
										return
									}
									
									if let data = data, let image = UIImage(data: data) {
										DispatchQueue.main.async { [self] in
											let compressedImage = image.jpeg(UIImage.JPEGQuality.low)
											listings_arr[index].listing_image.image = UIImage(data: compressedImage!)
										}
									}
								}.resume()
								
								print("successfully downloaded image to app")
							}
						}
                        
                        listings_arr[index].title_lb.text = (document.get("title") as! String)
						listings_arr[index].description_lb.text = (document.get("description") as! String)
						listings_arr[index].pickup_location_lb.text = (document.get("pickup_location") as! String)
						//listings_arr[index].start_time_lb.text = (document.get("start_time") as! String)
						//listings_arr[index].end_time_lb.text = (document.get("end_time") as! String)
						listings_arr[index].contact_info_lb.text = (document.get("contact_info") as! String)
                        listings_arr[index].list_date_lb.text = "Listed on: \(document.get("list_date") as! String)"
                        listings_arr[index].list_author_lb.text = "Listed by: \(document.get("list_author") as! String)"
                        listings_arr[index].details_bt.addTarget(self, action: #selector(handle_details(sender: )), for: .touchUpInside)
						
						listings_arr[index].listing_image.frame = CGRect(x: 10, y: 10, width: h - 20, height: h - 20)
						listings_arr[index].title_lb.frame = CGRect(x: h, y: 15, width: 500, height: 30)
						listings_arr[index].list_date_lb.frame = CGRect(x: h, y: 60, width: 500, height: 30)
						listings_arr[index].list_author_lb.frame = CGRect(x: h, y: 85, width: 500, height: 30)
						listings_arr[index].details_bt.frame = CGRect(x: w - 45, y: 10, width: 35, height: 35)
						
						scrollView.addSubview(listings_arr[index])
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
                for (index, document) in querySnapshot!.documents.enumerated() {
                    let listing = ListingView()
                    // fx = ax + b
                    let x_cor: CGFloat = 20
                    let y_cor: CGFloat = CGFloat(index) * h * margin + 75
                    listing.frame = CGRect(x: x_cor, y: y_cor, width: w, height: h)
                    listing.tag = index
                    listings_arr.append(listing)
                    
                    listings_arr[index].details_bt.tag = index
                    listings_arr[index].backgroundColor = lightRobinBlue
                    listings_arr[index].layer.borderColor = UIColor.white.cgColor
                    listings_arr[index].layer.borderWidth = 2
                    listings_arr[index].layer.cornerRadius = 20
                    
                    storage_ref.child("listings/\(document.documentID)").child(LISTING_IMAGE_PATH).child("\(document.documentID)_image.png").downloadURL { [self] (url, err) in
                        if let err = err {
                            print(err.localizedDescription)
                            return
                        } else {
                            guard let downloadURL = url else { return }
							URLSession.shared.dataTask(with: downloadURL) { (data, response, error) in
								if let error = error {
									print("Error downloading image: \(error)")
									return
								}
								
								if let data = data, let image = UIImage(data: data) {
									DispatchQueue.main.async { [self] in
										print(image.pngData()?.count)
										let compressedImage = image.jpeg(UIImage.JPEGQuality.lowest)
										print(compressedImage?.count)
										listings_arr[index].listing_image.image = UIImage(data: compressedImage!)
									}
								}
							}.resume()
							
                            print("successfully downloaded image to app")
                        }
                    }
                    
                    listings_arr[index].title_lb.text = (document.get("title") as! String)
					listings_arr[index].description_lb.text = (document.get("description") as! String)
					listings_arr[index].pickup_location_lb.text = (document.get("pickup_location") as! String)
					//listings_arr[index].start_time_lb.text = (document.get("start_time") as! String)
					//listings_arr[index].end_time_lb.text = (document.get("end_time") as! String)
					listings_arr[index].contact_info_lb.text = (document.get("contact_info") as! String)
                    listings_arr[index].list_date_lb.text = "Listed on: \(document.get("list_date") as! String)"
                    listings_arr[index].list_author_lb.text = "Listed by: \(document.get("list_author") as! String)"
                    listings_arr[index].details_bt.addTarget(self, action: #selector(handle_details(sender: )), for: .touchUpInside)
					
					listings_arr[index].listing_image.frame = CGRect(x: 10, y: 10, width: h - 20, height: h - 20)
					listings_arr[index].title_lb.frame = CGRect(x: h, y: 15, width: 500, height: 30)
					listings_arr[index].list_date_lb.frame = CGRect(x: h, y: 60, width: 500, height: 30)
					listings_arr[index].list_author_lb.frame = CGRect(x: h, y: 85, width: 500, height: 30)
					listings_arr[index].details_bt.frame = CGRect(x: w - 45, y: 10, width: 35, height: 35)
					
                    scrollView.addSubview(listings_arr[index])
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
