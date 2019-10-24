//
//  CheckoutViewModel.swift
//  Events
//
//  Created by Darci Neto on 16/10/19.
//  Copyright © 2019 Darci Neto. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CheckoutViewModel {
public let feedback : PublishSubject<String> = PublishSubject()
public let loading : PublishSubject<Bool> = PublishSubject()
private let disposable = DisposeBag()
private let eventCheckout = EventCheckout()
    public func checkout(checkout: Checkout){
        eventCheckout.checkout(checkout: checkout).subscribe(
            onNext: { self.feedback.onNext($0) },
            onError: {self.feedback.onNext($0.localizedDescription) },
            onCompleted: { self.loading.onNext(false) },
            onDisposed: { print("Disposed") }
        ).disposed(by: disposable)
    }
}
