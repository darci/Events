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
    func getAll(eventList:PublishSubject<[Event]>, loading: PublishSubject<Bool>, errorMessage: PublishSubject<String>) {
        guard let url = URL(string: "http://5b840ba5db24a100142dcd8c.mockapi.io/api/events") else { return }
        loading.onNext(true)
        rest.makeRequest(toURL: url, withHttpMethod: .get) { (results) in
            if let data = results.data {
                loading.onNext(false)
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .millisecondsSince1970
                guard let userData = try? decoder.decode([Event].self, from: data) else{
                    errorMessage.onNext("Ops, ocorreu um erro")
                    return
                }
                eventList.onNext(userData);
                return;
            }
            errorMessage.onNext("Ops, ocorreu um erro")
        }
    }
}
