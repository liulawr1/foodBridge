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

		let currentDateTime = Date()

		db.collection("listings").getDocuments() { [self] (querySnapshot, err) in
			if let err = err {
				print("Error getting documents: \(err)")
			} else {
				var validListings = [QueryDocumentSnapshot]()

				for document in querySnapshot!.documents {
					if let endDateTimestamp = document.get("end_date") as? Timestamp {
						let endDate = endDateTimestamp.dateValue()

						if currentDateTime <= endDate {
							validListings.append(document)
						}
					}
				}

				// Update the scrollView's content size based on the number of valid listings
				sv_h = CGFloat(validListings.count) * h * margin + 150
				scrollView.contentSize = CGSize(width: view.frame.width, height: sv_h)

				for (index, document) in validListings.enumerated() {
					let listing = createListingFromDocument(document, index: index)
					scrollView.addSubview(listing)
				}
			}
		}
	}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = lightGreen
        setup_UI()
        setup_refresh_control()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
		self.hideKeyboardWhenTappedAround()
    }
    
    let search_bar: UITextField = {
        let tf = UITextField()
        let attributedPlaceholder = NSAttributedString(
            string: "🔎 Search",
            attributes: [NSAttributedString.Key.foregroundColor: forestGreen]
        )
        tf.attributedPlaceholder = attributedPlaceholder
        tf.backgroundColor = lightGreen
        tf.font = UIFont.boldSystemFont(ofSize: 20)
        tf.textColor = forestGreen
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.layer.borderColor = forestGreen.cgColor
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
        bt.backgroundColor = lightGreen
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        bt.setTitleColor(forestGreen, for: .normal)
        bt.titleLabel?.textAlignment = .center
        bt.layer.borderColor = forestGreen.cgColor
        bt.layer.borderWidth = 2
        bt.layer.cornerRadius = 15
        return bt
    }()
	
//	FIX
//
//	func getCurrentListingID(for index: Int, completion: @escaping (String?) -> Void) {
//		guard index >= 0, index < listings_arr.count else {
//			completion(nil)
//			return
//		}
//
//		let current_user = USER_EMAIL!.split(separator: "@").first ?? ""
//
//		db.collection("listings").getDocuments() { (querySnapshot, err) in
//			if let err = err {
//				print("Error getting documents: \(err)")
//				completion(nil)
//			} else {
//				for document in querySnapshot!.documents {
//					if (document.get("list_author") as! String) == current_user {
//						let documentID = document.documentID
//						completion(documentID)
//						return
//					}
//				}
//				completion(nil)
//			}
//		}
//	}
    
    @objc func handle_details(sender: UIButton) {
        let vc = ListingVC()
        let index = sender.tag
		
		vc.listing_image.image = listings_arr[index].listing_image.image
        vc.title_string = listings_arr[index].title_lb.text
        vc.description_string = listings_arr[index].description_lb.text
		vc.item_quantity_string = listings_arr[index].item_quantity_lb.text
		vc.item_weight_string = listings_arr[index].item_weight_lb.text
        vc.pickup_location_string = listings_arr[index].pickup_location_lb.text
        vc.start_date_string = listings_arr[index].start_date_lb.text
        vc.end_date_string = listings_arr[index].end_date_lb.text
        vc.contact_info_string = listings_arr[index].contact_info_lb.text
		vc.list_date_string = listings_arr[index].list_date_lb.text
		vc.list_author_string = listings_arr[index].list_author_lb.text
	
//		FIX
//
//		getCurrentListingID(for: index) { [weak self] currentListingID in
//			if let id = currentListingID {
//				current_listing_id = id
//				guard let uid = current_listing_id else { return }
//
//				let nav = UINavigationController(rootViewController: vc)
//				nav.modalPresentationStyle = .fullScreen
//				self?.present(nav, animated: false)
//			} else {
//				print("No matching document found.")
//			}
//		}
		
		let nav = UINavigationController(rootViewController: vc)
		nav.modalPresentationStyle = .fullScreen
		self.present(nav, animated: false)
    }
    
	@objc func handle_enter(sender: UIButton) {
		let search_query = search_bar.text!

		listings_arr.forEach { $0.removeFromSuperview() }
		listings_arr.removeAll()

		let currentDateTime = Date()

		db.collection("listings").getDocuments() { [self] (querySnapshot, err) in
			if let err = err {
				print("Error getting documents: \(err)")
			} else {
				var index = 0

				for document in querySnapshot!.documents {
					if let endDateTimestamp = document.get("end_date") as? Timestamp {
						let endDate = endDateTimestamp.dateValue()

						if currentDateTime <= endDate {
							if search_query.isEmpty || (document.get("title") as! String).lowercased().contains(search_query.lowercased()) {
								let listing = createListingFromDocument(document, index: index)
								scrollView.addSubview(listing)
								index += 1
							}
						}
					}
				}
			}
		}
	}
    
	func display_rows() {
		let currentDateTime = Date()

		db.collection("listings").getDocuments() { [self] (querySnapshot, err) in
			if let err = err {
				print("Error getting documents: \(err)")
			} else {
				var index = 0

				for document in querySnapshot!.documents {
					if let endDateTimestamp = document.get("end_date") as? Timestamp {
						let endDate = endDateTimestamp.dateValue()

						if currentDateTime <= endDate {
							let listing = createListingFromDocument(document, index: index)
							scrollView.addSubview(listing)
							index += 1
						}
					}
				}
			}
		}
	}
	
	func createListingFromDocument(_ document: QueryDocumentSnapshot, index: Int) -> ListingView {
		let listing = ListingView()
		let x_cor: CGFloat = 20
		let y_cor: CGFloat = CGFloat(index) * h * margin + 75
		listing.frame = CGRect(x: x_cor, y: y_cor, width: w, height: h)
		listing.tag = index
		listings_arr.append(listing)
		
		listings_arr[index].details_bt.tag = index
		listings_arr[index].backgroundColor = lightGreen
		listings_arr[index].layer.borderColor = forestGreen.cgColor
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
							print(image.pngData()?.count as Any)
							let compressedImage = image.jpeg(UIImage.JPEGQuality.lowest)
							print(compressedImage?.count as Any)
							listings_arr[index].listing_image.image = UIImage(data: compressedImage!)
						}
					}
				}.resume()
				
				print("successfully downloaded image to app")
			}
		}
		
		listings_arr[index].title_lb.text = (document.get("title") as! String)
		listings_arr[index].description_lb.text = "Description: \(document.get("description") as! String)"
		listings_arr[index].item_quantity_lb.text = "Item Quantity: \(document.get("item_quantity") as! String)"
		listings_arr[index].item_weight_lb.text = "Item Weight: \(document.get("item_weight") as! String)"
		listings_arr[index].pickup_location_lb.text = "Pickup Location: \(document.get("pickup_location") as! String)"
		
		if let startDateTimestamp = document.get("start_date") as? Timestamp {
			let startDate = startDateTimestamp.dateValue()
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "MM/dd/yyyy h:mm a"
			let startDateString = dateFormatter.string(from: startDate)
			listings_arr[index].start_date_lb.text = "Start Date: \(startDateString)"
		}
		
		if let endDateTimestamp = document.get("end_date") as? Timestamp {
			let endDate = endDateTimestamp.dateValue()
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "MM/dd/yyyy h:mm a"
			let endDateString = dateFormatter.string(from: endDate)
			listings_arr[index].end_date_lb.text = "End Date: \(endDateString)"
		}
		
		listings_arr[index].contact_info_lb.text = "Contact Info: \(document.get("contact_info") as! String)"
		listings_arr[index].list_date_lb.text = "Listed on: \(document.get("list_date") as! String)"
		listings_arr[index].list_author_lb.text = "Listed by: \(document.get("list_author") as! String)"
		listings_arr[index].details_bt.addTarget(self, action: #selector(handle_details(sender: )), for: .touchUpInside)
		
		listings_arr[index].listing_image.frame = CGRect(x: 10, y: 10, width: h - 20, height: h - 20)
		listings_arr[index].title_lb.frame = CGRect(x: h, y: 15, width: 500, height: 30)
		listings_arr[index].list_date_lb.frame = CGRect(x: h, y: 60, width: 500, height: 30)
		listings_arr[index].list_author_lb.frame = CGRect(x: h, y: 85, width: 500, height: 30)
		listings_arr[index].details_bt.frame = CGRect(x: w - 45, y: 10, width: 35, height: 35)

		return listing
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
