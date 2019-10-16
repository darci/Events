//
//  EventDetailViewController.swift
//  Events
//
//  Created by Darci Neto on 15/10/19.
//  Copyright © 2019 Darci Neto. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import MapKit


class EventDetailViewController:UIViewController {
  
    public var eventId:String?
  

    @IBOutlet weak var overView: UIVisualEffectView!
    @IBOutlet weak var userFeedbackLabel: UILabel!
    @IBOutlet weak var tryAgainBtn: UIButton!
    @IBOutlet weak var activityIndicador: UIActivityIndicatorView!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventMap: MKMapView!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventPrice: UILabel!
    @IBOutlet weak var eventDescription: UILabel!
    
     var eventDetailViewModel = EventDetailViewModel()

     private let disposeBag = DisposeBag()

    let formatter = DateFormatter()
     override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        self.eventDetailViewModel.requestData(id: eventId!)
    }
    
    private func setupBinding(){
        formatter.dateFormat = "HH:mm dd MMM yyyy"
        eventDetailViewModel
            .event
            .subscribe(onNext: { event in
                DispatchQueue.main.async {
                    self.eventImage.download(from: event.image!)
                    self.eventTitle.text = event.title
                    if let date = event.date {
                        self.eventDate.text = "🗓" + self.formatter.string(from: date)
                    } else {
                        self.eventDate.text = "Data não informada"
                    }
                    
                    if let price = event.price {
                        self.eventPrice.text = String(format: "%\(2)f", price)
                    } else {
                        self.eventPrice.text = "Valor não informado"
                    }
                    self.eventDescription.text = event.description
                }
            
            })
            .disposed(by: disposeBag)
        
        eventDetailViewModel
            .loading
            .subscribe(onNext: { isLoading in
                DispatchQueue.main.async {
                    self.overView.isHidden = !isLoading
                    self.activityIndicador.isHidden = !isLoading
                }
            
            })
            .disposed(by: disposeBag)
        
        eventDetailViewModel
            .errorMessage
            .subscribe(onNext: { errorMessage in
                DispatchQueue.main.async {
                    self.overView.isHidden = errorMessage.isEmpty
                    self.userFeedbackLabel.isHidden = errorMessage.isEmpty
                    self.tryAgainBtn.isHidden = errorMessage.isEmpty
                    self.userFeedbackLabel.text = errorMessage
                }
            
            })
            .disposed(by: disposeBag)
    }
}
