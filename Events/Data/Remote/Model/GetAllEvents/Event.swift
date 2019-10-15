//
//  Event.swift
//  Events
//
//  Created by Darci Neto on 13/10/19.
//  Copyright © 2019 Darci Neto. All rights reserved.
//

import Foundation

struct Event:Codable {
    let id: String?
    let title: String?
    let date: Date?
    let description: String?
    let image: String?
    let price: Double?
    let longitude: Double?
    let latitude: Double?
}
