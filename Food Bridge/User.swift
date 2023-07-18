//
//  User.swift
//  Food Bridge
//
//  Created by Lawrence Liu on 6/24/23.
//

import Foundation
import UIKit

let user_db = UserDefaults()
var users = [[String: Any]]()
var user_cnt = user_db.integer(forKey: "cnt")

class User {
    var email: String?
    var password: String?

    init(email: String, password: String) {
        self.email = email
        self.password = password
    }

    public func set_email(email: String) {
        self.email = email
    }

    public func get_email() -> String {
        return self.email!
    }

    public func set_password(password: String) {
        self.password = password
    }

    public func get_password() -> String {
        return self.password!
    }
}
