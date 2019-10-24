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
    
    @IBOutlet weak var eventCheckoutBtn: UIButton!

    @IBOutlet weak var eventDescription: UILabel!
    
     var eventDetailViewModel = EventDetailViewModel()

     private let disposeBag = DisposeBag()

    let formatter = DateFormatter()
     override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        self.eventDetailViewModel.requestData(id: eventId!)
        
    }
    
    @IBAction func checkoutButtonClick(_ sender: Any) {
        addBottomSheetView()
        print("click")
    }
    private func setupBinding(){
        formatter.dateFormat = "HH:mm dd MMM yyyy"
        eventDetailViewModel
            .event
            .subscribe(onNext: { event in
                DispatchQueue.main.async {
                    self.eventImage.download(from: event.image!)
                    self.eventTitle.text = event.title
                   
                    let location = CLLocationCoordinate2D(latitude: event.latitude!, longitude: event.longitude!)
                    
                    let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                    let region = MKCoordinateRegion(center: location, span: span)
                    self.eventMap.setRegion(region, animated: true)
                        
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = location
                    annotation.title =  event.title
                    self.eventMap.addAnnotation(annotation)
                    if let date = event.date {
                        self.eventDate.text = "🗓" + self.formatter.string(from: date)
                    } else {
                        self.eventDate.text = "Data não informada"
                    }
                    
                    if let price = event.price {
                        let price = String(format: "R$ %.2f", price)
                        self.eventCheckoutBtn.titleLabel!.text = price.replacingOccurrences(of: ".", with: ",")
                    } else {
                        self.eventCheckoutBtn.titleLabel!.text = "Checkout"
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
    
    
    func addBottomSheetView() {
        let alertController = UIAlertController(title: "Confirmar", message: "Insira seus dados para confimar o checkout", preferredStyle: .alert)
        alertController.addTextField { nameTextField in
            nameTextField.placeholder = "Nome"
        }
        alertController.addTextField{ emailTextField in
            emailTextField.placeholder = "e-mail"
        }
        let confirmAction = UIAlertAction(title: "OK", style: .default) { [weak alertController] _ in
            guard let alertController = alertController,
                let name = alertController.textFields?.first,
                let email = alertController.textFields?.first
                else { return }
            print("Current\(String(describing: name.text))\(String(describing: email.text))")
        }
        alertController.addAction(confirmAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}
