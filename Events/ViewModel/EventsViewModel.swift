//
//  EventsViewModel.swift
//  Events
//
//  Created by Darci Neto on 15/10/19.
//  Copyright © 2019 Darci Neto. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class EventsViewModel {
    public let events : PublishSubject<[Event]> = PublishSubject()
    public let loading : PublishSubject<Bool> = PublishSubject()
    public let errorMessage : PublishSubject<String> = PublishSubject()
    private let disposable = DisposeBag()
    private let getAllEvents = GetAllEvents()
    
    public func requestData(){
        getAllEvents.getAll(eventList: events, loading: loading, errorMessage: errorMessage)
    }
    
}
