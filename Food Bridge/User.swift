//
//  User.swift
//  Food Bridge
//
//  Created by Lawrence Liu on 6/24/23.
//

import Foundation
import UIKit

var user_info = User()

public struct User {
    var email: String = ""
    var password: String = ""
    var user_type: String = ""
    var location: String = ""
    var active_listings: Int = 0
    var total_listings: Int = 0
    
    var food_measurement: [String: Int] = [
        "rating": 0,
        "freshness": 0,
        "weight": 0
    ]
    
    func to_any_object() -> Any {
        return [
            "email": email,
            "password": password,
            "user_type": user_type,
            "location": location,
            "active_listings": active_listings,
            "total_listings": total_listings,
            "food_measurement": food_measurement
        ] as [String: Any]
    }
    
    func to_food_measurement() -> Any {
        return ["food measurement": food_measurement]
    }
    
    func to_food_measurement_values() -> Any {
        return food_measurement
    }
}
