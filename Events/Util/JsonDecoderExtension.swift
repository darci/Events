//
//  JsonDecoderExtension.swift
//  Events
//
//  Created by Darci Neto on 23/10/19.
//  Copyright © 2019 Darci Neto. All rights reserved.
//

import Foundation

extension JSONDecoder {
    static func getDefaultApiDecoder() -> JSONDecoder{
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .millisecondsSince1970
        return decoder
    }
}
