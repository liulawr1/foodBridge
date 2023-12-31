//
//  Database.swift
//  Food Bridge
//
//  Created by Lawrence Liu on 7/21/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

let db = Firestore.firestore()
let storage = Storage.storage()
let storage_ref = Storage.storage().reference()

let USER = Auth.auth().currentUser
var USER_EMAIL = USER!.email
var USER_ID = USER!.uid

let EMAIL = "email"
let PASSWORD = "password"
let USER_TYPE = "user_type"
let LOCATION = "location"
let ACTIVE_LISTINGS = "active_listings"
let TOTAL_LISTINGS = "total_listings"

let PROFILE_PICTURE_PATH = "profile_picture"
let LISTING_IMAGE_PATH = "listing_image"
