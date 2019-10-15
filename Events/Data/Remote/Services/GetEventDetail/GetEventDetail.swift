//
//  GetEventDetail.swift
//  Events
//
//  Created by Darci Neto on 15/10/19.
//  Copyright © 2019 Darci Neto. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class GetEventDetail {
    
    let rest = RestClient()
    func getEvent(id:Int, event:PublishSubject<Event>, loading: PublishSubject<Bool>, errorMessage: PublishSubject<String>) {
        guard let url = URL(string: "http://5b840ba5db24a100142dcd8c.mockapi.io/api/events/\(id)") else { return }
        loading.onNext(true)
        rest.makeRequest(toURL: url, withHttpMethod: .get) { (results) in
            if let data = results.data {
                loading.onNext(false)
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .millisecondsSince1970
                guard let userData = try? decoder.decode(Event.self, from: data) else{
                    errorMessage.onNext("Ops, ocorreu um erro")
                    return
                }
                event.onNext(userData);
                return;
            }
            errorMessage.onNext("Ops, ocorreu um erro")
        }
    }
}
