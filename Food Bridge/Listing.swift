//
//  Listing.swift
//  Food Bridge
//
//  Created by Lawrence Liu on 7/15/23.
//

import Foundation
import UIKit
import FirebaseFirestore
import MapKit

var current_listing_id: String?

class ListingView: UIButton {
    var listingID: String = ""
    
    let listing_image: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = lightGreen
        iv.contentMode = .scaleAspectFill
        iv.layer.borderColor = forestGreen.cgColor
        iv.layer.borderWidth = 2
        iv.layer.cornerRadius = 10
        iv.clipsToBounds = true
        return iv
    }()
    
    let title_lb: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 28)
        lb.textColor = forestGreen
        return lb
    }()
    
    let list_date_lb: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 16)
        lb.textColor = forestGreen
        return lb
    }()
    
    let list_author_lb: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 16)
        lb.textColor = forestGreen
        return lb
    }()
    
    let description_lb: UILabel = { UILabel() }()
    let item_quantity_lb: UILabel = { UILabel() }()
    let item_weight_lb: UILabel = { UILabel() }()
    let pickup_location_lb: UILabel = { UILabel() }()
    let start_date_lb: UILabel = { UILabel() }()
    let end_date_lb: UILabel = { UILabel() }()
    let contact_info_lb: UILabel = { UILabel() }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(listing_image)
        self.addSubview(title_lb)
        self.addSubview(list_date_lb)
        self.addSubview(list_author_lb)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PaddedLabel: UILabel {
    var textInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }

    convenience init(insets: UIEdgeInsets) {
        self.init(frame: .zero)
        self.textInsets = insets
    }

    override func drawText(in rect: CGRect) {
        guard let _ = self.text else { return }
        var insetRect = rect.inset(by: textInsets)
        insetRect.origin.y += 5
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: self.numberOfLines)
        var adjustedRect = insetRect
        adjustedRect.size.height = textRect.size.height
        super.drawText(in: adjustedRect)
    }

    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        var insetRect = bounds.inset(by: textInsets)
        insetRect.origin.y += 5
        var textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        textRect.origin.y = bounds.origin.y + textInsets.top
        return textRect
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + textInsets.left + textInsets.right,
                      height: size.height + textInsets.top + textInsets.bottom)
    }
}

class ListingVC: UIViewController {
    let scrollView = UIScrollView()
    var title_string: String?
    var description_string: String?
    var item_quantity_string: String?
    var item_weight_string: String?
    var pickup_location_string: String?
    var start_date_string: String?
    var end_date_string: String?
    var contact_info_string: String?
    var list_date_string: String?
    var list_author_string: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = lightGreen
        setup_UI()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        let back_bt = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(handle_back))
        back_bt.tintColor = forestGreen
        navigationItem.leftBarButtonItem = back_bt
        
        let comments_bt = UIBarButtonItem(image: UIImage(systemName: "message"), style: .plain, target: self, action: #selector(handle_comments))
        comments_bt.tintColor = forestGreen
        navigationItem.rightBarButtonItem = comments_bt
        
        title_lb.text = title_string
        description_lb.text = description_string
        item_quantity_lb.text = item_quantity_string
        item_weight_lb.text = item_weight_string
        pickup_location_lb.text = pickup_location_string
        start_date_lb.text = start_date_string
        end_date_lb.text = end_date_string
        contact_info_lb.text = contact_info_string
        list_date_lb.text = list_date_string
        list_author_lb.text = list_author_string
        
        showPickupLocationOnMap()
    }
    
    @objc func handle_back() {
        let cb = ControlBar()
        let gcb = GuestControlBar()
        if (isGuest) {
            let nav = UINavigationController(rootViewController: gcb)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: false)
        } else {
            let nav = UINavigationController(rootViewController: cb)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: false)
        }
    }
    
    @objc func handle_comments() {
        guard let listingID = current_listing_id else { return }
        print(listingID)
        
        let vc = CommentsVC()
        vc.listingID = listingID
        self.present(vc, animated: true)
    }
    
    let listing_image: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = lightGreen
        iv.contentMode = .scaleAspectFill
        iv.layer.borderColor = forestGreen.cgColor
        iv.layer.borderWidth = 2
        iv.layer.cornerRadius = 15
        iv.clipsToBounds = true
        return iv
    }()
    
    let title_lb: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 28)
        lb.textColor = forestGreen
        lb.textAlignment = .center
        return lb
    }()
    
    let description_lb: PaddedLabel = {
        let lb = PaddedLabel(insets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        lb.font = UIFont.boldSystemFont(ofSize: 16)
        lb.textColor = forestGreen
        lb.layer.borderColor = forestGreen.cgColor
        lb.layer.borderWidth = 2
        lb.layer.cornerRadius = 10
        lb.numberOfLines = 0
        return lb
    }()
    
    let item_quantity_lb: PaddedLabel = {
        let lb = PaddedLabel(insets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        lb.font = UIFont.boldSystemFont(ofSize: 16)
        lb.textColor = forestGreen
        lb.layer.borderColor = forestGreen.cgColor
        lb.layer.borderWidth = 2
        lb.layer.cornerRadius = 10
        lb.numberOfLines = 0
        return lb
    }()
    
    let item_weight_lb: PaddedLabel = {
        let lb = PaddedLabel(insets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        lb.font = UIFont.boldSystemFont(ofSize: 16)
        lb.textColor = forestGreen
        lb.layer.borderColor = forestGreen.cgColor
        lb.layer.borderWidth = 2
        lb.layer.cornerRadius = 10
        lb.numberOfLines = 0
        return lb
    }()
    
    let pickup_location_lb: PaddedLabel = {
        let lb = PaddedLabel(insets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        lb.font = UIFont.boldSystemFont(ofSize: 16)
        lb.textColor = forestGreen
        lb.layer.borderColor = forestGreen.cgColor
        lb.layer.borderWidth = 2
        lb.layer.cornerRadius = 10
        lb.numberOfLines = 0
        return lb
    }()
    
    let start_date_lb: PaddedLabel = {
        let lb = PaddedLabel(insets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        lb.font = UIFont.boldSystemFont(ofSize: 16)
        lb.textColor = forestGreen
        lb.layer.borderColor = forestGreen.cgColor
        lb.layer.borderWidth = 2
        lb.layer.cornerRadius = 10
        return lb
    }()
    
    let end_date_lb: PaddedLabel = {
        let lb = PaddedLabel(insets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        lb.font = UIFont.boldSystemFont(ofSize: 16)
        lb.textColor = forestGreen
        lb.layer.borderColor = forestGreen.cgColor
        lb.layer.borderWidth = 2
        lb.layer.cornerRadius = 10
        return lb
    }()
    
    let contact_info_lb: PaddedLabel = {
        let lb = PaddedLabel(insets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        lb.font = UIFont.boldSystemFont(ofSize: 16)
        lb.textColor = forestGreen
        lb.layer.borderColor = forestGreen.cgColor
        lb.layer.borderWidth = 2
        lb.layer.cornerRadius = 10
        return lb
    }()
    
    let list_date_lb: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 15)
        lb.textColor = forestGreen
        return lb
    }()
    
    let list_author_lb: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 15)
        lb.textColor = forestGreen
        return lb
    }()
    
    let pickupMapView: MKMapView = {
        let mapView = MKMapView()
        mapView.layer.cornerRadius = 10
        mapView.layer.borderColor = forestGreen.cgColor
        mapView.layer.borderWidth = 2
        return mapView
    }()
    
    func setup_UI() {
        let top_margin: CGFloat = 0
        let lb_margin: CGFloat = 10
        let elem_w: CGFloat = view.frame.width - 2 * left_margin
        let listing_image_dim: CGFloat = view.frame.width - left_margin * 2
        scrollView.frame = view.bounds
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + 200)
        
        title_lb.frame = CGRect(x: left_margin, y: top_margin, width: elem_w, height: elem_h)
        listing_image.frame = CGRect(x: left_margin, y: title_lb.center.y + title_lb.frame.height / 2 + lb_margin, width: listing_image_dim, height: listing_image_dim)
        list_date_lb.frame = CGRect(x: left_margin, y: listing_image.center.y + listing_image.frame.height / 2 - 5, width: elem_w, height: elem_h)
        list_author_lb.frame = CGRect(x: left_margin, y: list_date_lb.center.y + list_date_lb.frame.height / 2 - 25, width: elem_w, height: elem_h)
        description_lb.frame = CGRect(x: left_margin, y: list_author_lb.center.y + list_author_lb.frame.height / 2 + lb_margin, width: elem_w, height: elem_h * 3.5)
        item_quantity_lb.frame = CGRect(x: left_margin, y: description_lb.center.y + description_lb.frame.height / 2 + elem_margin, width: elem_w, height: elem_h)
        item_weight_lb.frame = CGRect(x: left_margin, y: item_quantity_lb.center.y + item_quantity_lb.frame.height / 2 + elem_margin, width: elem_w, height: elem_h)
        pickup_location_lb.frame = CGRect(x: left_margin, y: item_weight_lb.center.y + item_weight_lb.frame.height / 2 + elem_margin, width: elem_w, height: elem_h)
        start_date_lb.frame = CGRect(x: left_margin, y: pickup_location_lb.center.y + pickup_location_lb.frame.height / 2 + elem_margin, width: elem_w, height: elem_h)
        end_date_lb.frame = CGRect(x: left_margin, y: start_date_lb.center.y + start_date_lb.frame.height / 2 + elem_margin, width: elem_w, height: elem_h)
        contact_info_lb.frame = CGRect(x: left_margin, y: end_date_lb.center.y + end_date_lb.frame.height / 2 + elem_margin, width: elem_w, height: elem_h)
        
        pickupMapView.frame = CGRect(x: left_margin, y: contact_info_lb.center.y + contact_info_lb.frame.height / 2 + elem_margin, width: elem_w, height: 250)
        
        view.addSubview(scrollView)
        scrollView.addSubview(title_lb)
        scrollView.addSubview(listing_image)
        scrollView.addSubview(list_date_lb)
        scrollView.addSubview(list_author_lb)
        scrollView.addSubview(description_lb)
        scrollView.addSubview(item_quantity_lb)
        scrollView.addSubview(item_weight_lb)
        scrollView.addSubview(pickup_location_lb)
        scrollView.addSubview(start_date_lb)
        scrollView.addSubview(end_date_lb)
        scrollView.addSubview(contact_info_lb)
        scrollView.addSubview(pickupMapView)
        
        scrollView.contentSize.height = pickupMapView.frame.maxY + 40
    }
    
    func showPickupLocationOnMap() {
        guard let locationString = pickup_location_string, !locationString.isEmpty else { return }
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(locationString) { [weak self] placemarks, error in
            guard let self = self else { return }
            if let error = error {
                print("Geocoding error: \(error)")
                return
            }
            
            if let coordinate = placemarks?.first?.location?.coordinate {
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "Pickup Location"
                self.pickupMapView.addAnnotation(annotation)
                
                let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
                self.pickupMapView.setRegion(region, animated: true)
            }
        }
    }
}
