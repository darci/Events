//
//  Coupon.swift
//  Events
//
//  Created by Darci Neto on 13/10/19.
//  Copyright © 2019 Darci Neto. All rights reserved.
//

import Foundation

struct Coupon:Codable {
    let id: String?
    let eventId: String?
    let discount: Int?
}
