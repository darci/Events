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

class EventsViewModel{
    var events: PublishSubject<[Event]>  = PublishSubject()
    
    public let loading : PublishSubject<Bool> = PublishSubject()
    public let errorMessage : PublishSubject<String> = PublishSubject()
    private let disposable = DisposeBag()
    private let getAllEvents = GetAllEvents()
    
    func requestData(){
        errorMessage.onNext("")
        loading.onNext(true)
        getAllEvents.getAll().subscribe(
            onNext: { self.events.onNext($0) },
            onError: {self.errorMessage.onNext($0.localizedDescription) },
            onCompleted: { self.loading.onNext(false) },
            onDisposed: { print("Disposed") }
        ).disposed(by: disposable)

    }
    
}
