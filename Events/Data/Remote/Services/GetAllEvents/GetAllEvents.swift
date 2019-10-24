//
//  GetAllEventsRepository.swift
//  Events
//
//  Created by Darci Neto on 13/10/19.
//  Copyright © 2019 Darci Neto. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


class GetAllEvents {
    let rest = RestClient()
    let url = URL(string: "http://5b840ba5db24a100142dcd8c.mockapi.io/api/events")!
    
    func getAll() -> Observable<[Event]> {
        return rest.makeRequest(toURL: url, withHttpMethod: .get).map { data -> [Event] in
            guard let events = try? JSONDecoder.getDefaultApiDecoder().decode([Event].self, from: data) else {
                throw ApiCustomErrors.CouldNotDecode
            }
            return events
        }
    }
}
