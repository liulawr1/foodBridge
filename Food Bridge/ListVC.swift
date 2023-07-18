//
//  ListVC.swift
//  Food Bridge
//
//  Created by Lawrence Liu on 7/8/23.
//

import Foundation
import UIKit

class ListVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = robinBlue
        setup_UI()
    }
    
    let header_lb: UILabel = {
        let lb = UILabel()
        lb.text = "Create a Listing"
        lb.font = UIFont.boldSystemFont(ofSize: 35)
        lb.textColor = .white
        lb.textAlignment = .center
        return lb
    }()
    
    let title_field: UITextField = {
        let tf = UITextField()
        let attributedPlaceholder = NSAttributedString(
            string: "Title",
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
    
    let description_field: UITextView = {
        let tv = UITextView()
        let attributedPlaceholder = NSAttributedString(
            string: "Description",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        tv.attributedText = attributedPlaceholder
        tv.backgroundColor = lightRobinBlue
        tv.font = UIFont.boldSystemFont(ofSize: 20)
        tv.textColor = .white
        tv.autocapitalizationType = .none
        tv.autocorrectionType = .no
        tv.layer.borderColor = UIColor.white.cgColor
        tv.layer.borderWidth = 2
        tv.layer.cornerRadius = 20
        tv.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return tv
    }()
    
    let pickup_location_field: UITextField = {
        let tf = UITextField()
        let attributedPlaceholder = NSAttributedString(
            string: "Pickup Location",
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
    
    let start_time_picker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .time
        dp.minuteInterval = 15
        dp.backgroundColor = lightRobinBlue
        dp.tintColor = .white
        dp.layer.borderColor = UIColor.white.cgColor
        dp.layer.borderWidth = 2
        dp.layer.cornerRadius = 20
        dp.clipsToBounds = true
        return dp
    }()

    let end_time_picker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .time
        dp.minuteInterval = 15
        dp.backgroundColor = lightRobinBlue
        dp.tintColor = .white
        dp.layer.borderColor = UIColor.white.cgColor
        dp.layer.borderWidth = 2
        dp.layer.cornerRadius = 20
        dp.clipsToBounds = true
        return dp
    }()
    
    @objc func startTimeChanged(picker: UIDatePicker) {
        let startTime = picker.date
        print("Selected start time: \(startTime)")
    }

    @objc func endTimeChanged(picker: UIDatePicker) {
        let endTime = picker.date
        print("Selected end time: \(endTime)")
        
        if (endTime < start_time_picker.date) {
            let calendar = Calendar.current
            let newEndTime = calendar.date(byAdding: .minute, value: 15, to: start_time_picker.date) ?? Date()
            end_time_picker.setDate(newEndTime, animated: true)
        }
    }
    
    func setup_UI() {
        let top_margin: CGFloat = 80
        let elem_w: CGFloat = view.frame.width - 2 * left_margin
        header_lb.frame = CGRect(x: left_margin, y: top_margin, width: elem_w, height: elem_h)
        title_field.frame = CGRect(x: left_margin, y: header_lb.center.y + header_lb.frame.height / 2 + elem_margin + 20, width: elem_w, height: elem_h)
        description_field.frame = CGRect(x: left_margin, y: title_field.center.y + title_field.frame.height / 2 + elem_margin, width: elem_w, height: elem_h * 5)
        pickup_location_field.frame = CGRect(x: left_margin, y: description_field.center.y + description_field.frame.height / 2 + elem_margin, width: elem_w, height: elem_h)
        start_time_picker.frame = CGRect(x: left_margin, y: pickup_location_field.center.y + pickup_location_field.frame.height / 2 + elem_margin, width: elem_w / 2 - 10, height: elem_h)
        end_time_picker.frame = CGRect(x: left_margin + elem_w / 2 + 10, y: pickup_location_field.center.y + pickup_location_field.frame.height / 2 + elem_margin, width: elem_w / 2 - 10, height: elem_h)
        
        let startTimeLabel = UILabel(frame: CGRect(x: 5, y: 0, width: start_time_picker.frame.width, height: start_time_picker.frame.height))
        startTimeLabel.text = "Start Time:"
        startTimeLabel.font = UIFont.boldSystemFont(ofSize: 17)
        startTimeLabel.textColor = .white
        startTimeLabel.textAlignment = .left
        start_time_picker.addSubview(startTimeLabel)
        
        let endTimeLabel = UILabel(frame: CGRect(x: 8, y: 0, width: end_time_picker.frame.width, height: end_time_picker.frame.height))
        endTimeLabel.text = "End Time:"
        endTimeLabel.font = UIFont.boldSystemFont(ofSize: 18)
        endTimeLabel.textColor = .white
        endTimeLabel.textAlignment = .left
        end_time_picker.addSubview(endTimeLabel)
        
        // connect @objc func to buttons
        start_time_picker.addTarget(self, action: #selector(startTimeChanged(picker: )), for: .valueChanged)
        end_time_picker.addTarget(self, action: #selector(endTimeChanged(picker: )), for: .valueChanged)
        
        view.addSubview(header_lb)
        view.addSubview(title_field)
        view.addSubview(description_field)
        view.addSubview(pickup_location_field)
        view.addSubview(start_time_picker)
        view.addSubview(end_time_picker)
    }
}
