//
//  User.swift
//  Contacts
//
//  Created by Daniel Savchak on 28.05.2020.
//  Copyright © 2020 Danylo-Savchak. All rights reserved.
//

import Foundation
import UIKit

struct User {
    
    var name: String
    var isOnline: Bool
    var email: String
    var photo:  UIImage
    var hex: String
    
    init(name: String,isOnline: Bool, email: String, hex:String, photo: UIImage) {
        self.name = name
        self.isOnline = isOnline
        self.email = email
        self.photo = photo
        self.hex = hex
    }
}
