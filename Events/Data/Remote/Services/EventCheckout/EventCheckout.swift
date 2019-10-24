//
//  EventCheckout.swift
//  Events
//
//  Created by Darci Neto on 16/10/19.
//  Copyright © 2019 Darci Neto. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


class EventCheckout {
    let rest = RestClient()
    func checkout(checkout:Checkout) -> Observable<String>  {
        let url = URL(string: "http://5b840ba5db24a100142dcd8c.mockapi.io/api/checkin")!
        return rest.makeRequest(toURL: url, withHttpMethod: .post).map { data -> String in
            guard let checkoutResponse = try? JSONDecoder.getDefaultApiDecoder().decode(CheckoutResponse.self, from: data)else {
                throw ApiCustomErrors.CouldNotDecode
            }
            if  checkoutResponse.code == "200" {
                return "Checkout realizado";
            }
            return "Ops, ocorreu um erro";
        }
    }
    
    func getEvent(id:String) -> Observable<Event>  {
        let url = URL(string: "http://5b840ba5db24a100142dcd8c.mockapi.io/api/events/" + id)!
        return rest.makeRequest(toURL: url, withHttpMethod: .get).map { data -> Event in
            guard let events = try? JSONDecoder.getDefaultApiDecoder().decode(Event.self, from: data) else {
                throw ApiCustomErrors.CouldNotDecode
            }
            return events
        }
    }
}
