//
//  Database.swift
//  Food Bridge
//
//  Created by Lawrence Liu on 7/21/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

let db = Firestore.firestore()

let USER = Auth.auth().currentUser
let USER_EMAIL = USER?.email
let USER_ID = USER?.uid
