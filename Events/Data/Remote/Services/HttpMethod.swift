//
//  HttpMethod.swift
//  Events
//
//  Created by Darci Neto on 15/10/19.
//  Copyright © 2019 Darci Neto. All rights reserved.
//

import Foundation
    extension RestClient {
        enum HttpMethod: String {
            case get
            case post
            case put
            case patch
            case delete
        }
}
