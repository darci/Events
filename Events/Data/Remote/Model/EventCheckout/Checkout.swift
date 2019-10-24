//
//  Checkout.swift
//  Events
//
//  Created by Darci Neto on 16/10/19.
//  Copyright © 2019 Darci Neto. All rights reserved.
//

import Foundation

struct Checkout:Codable {
    let eventId: String?
    let name: String?
    let email: String?

    init (id:String, name:String, email:String) {
        self.eventId = id
        self.name = name
        self.email = email
    }
}

