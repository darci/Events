//
//  EventDetailViewModel.swift
//  Events
//
//  Created by Darci Neto on 15/10/19.
//  Copyright © 2019 Darci Neto. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class EventDetailViewModel {
    public let event : PublishSubject<Event> = PublishSubject()
    public let loading : PublishSubject<Bool> = PublishSubject()
    public let errorMessage : PublishSubject<String> = PublishSubject()
    private let disposable = DisposeBag()
    private let getEventDetail = GetEventDetail()
    
    public func requestData(id: String){
        getEventDetail.getEvent(id: id, event: event, loading: loading, errorMessage: errorMessage)
    }
    
}
