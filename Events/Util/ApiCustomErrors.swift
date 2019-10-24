//
//  ApiCustomErrors.swift
//  Events
//
//  Created by Darci Neto on 23/10/19.
//  Copyright © 2019 Darci Neto. All rights reserved.
//

import Foundation

  enum ApiCustomErrors: Error {
        case failedToCreateRequest
        case CouldNotDecode
        case BadStatus(status: Int)
        case Other(Error)
    }


// MARK: - Custom Error Description
extension ApiCustomErrors: LocalizedError {
    public var localizedDescription: String {
        switch self {
            case .failedToCreateRequest:
                return NSLocalizedString("Unable to create the URLRequest object", comment: "ApiCustomErrors")
            case .CouldNotDecode:
                return NSLocalizedString("Could not decode", comment: "ApiCustomErrors")
            case let .BadStatus(status):
                return NSLocalizedString("Bad status \(status)", comment: "ApiCustomErrors")
            case let .Other(error):
                 return NSLocalizedString("\(error)", comment: "ApiCustomErrors")
        }
    }
}
