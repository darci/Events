//
//  EventListViewController.swift
//  Events
//
//  Created by Darci Neto on 15/10/19.
//  Copyright © 2019 Darci Neto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class EventListViewController: UIViewController {
    
    @IBOutlet private weak var eventsTableView: UITableView!
    
    @IBOutlet weak var overView: UIVisualEffectView!
    @IBOutlet weak var userFeedbackLabel: UILabel!
    @IBOutlet weak var tryAgainBtn: UIButton!
    @IBOutlet weak var activityIndicador: UIActivityIndicatorView!
    
    var refreshControl = UIRefreshControl()
    var eventsViewModel = EventsViewModel()
    
    public let events : PublishSubject<[Event]> = PublishSubject()
    
    
    //private let viewModel: EventsViewModelType
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        setupRefreshControl()
        self.eventsViewModel.requestData()
    }
    
    private func setupBinding(){
        eventsViewModel
            .loading
            .subscribe(onNext: { isLoading in
                DispatchQueue.main.async {
                    self.overView.isHidden = !isLoading
                    self.userFeedbackLabel.isHidden = !isLoading
                    self.userFeedbackLabel.text = "Aguarde ..."
                    self.activityIndicador.isHidden = !isLoading
                    if !isLoading {
                        self.refreshControl.endRefreshing()
                        self.userFeedbackLabel.text = ""
                    }
                }
                
            })
            .disposed(by: disposeBag)
        
        eventsViewModel
            .errorMessage
            .subscribe(onNext: { errorMessage in
                DispatchQueue.main.async {
                    self.activityIndicador.isHidden = true
                    self.overView.isHidden = errorMessage.isEmpty
                    self.userFeedbackLabel.isHidden = errorMessage.isEmpty
                    self.tryAgainBtn.isHidden = errorMessage.isEmpty
                    self.userFeedbackLabel.text = errorMessage
                }
                
            })
            .disposed(by: disposeBag)
        
        eventsViewModel
            .events
            .observeOn(MainScheduler.instance)
            .bind(to: self.events)
            .disposed(by: disposeBag)
        
        eventsTableView.register(UINib(nibName: "EventItemTableViewCell", bundle: nil), forCellReuseIdentifier: String(describing: EventItemTableViewCell.self))
        
        eventsTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                let eventItemCell = self?.eventsTableView.cellForRow(at: indexPath) as? EventItemTableViewCell
                self?.eventsTableView.deselectRow(at: indexPath, animated: true)
                let storyBoard: UIStoryboard = UIStoryboard(name: "EventDetailViewController", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "EventDetailViewController") as! EventDetailViewController
                newViewController.eventId = eventItemCell?.id
                self?.present(newViewController, animated: true, completion: nil)
                print(indexPath.description)
                
            }).disposed(by: disposeBag)
        
        events
            .bind(to: eventsTableView.rx.items(cellIdentifier: "EventItemTableViewCell", cellType: EventItemTableViewCell.self)) {
                (row,event,cell) in
                cell.cellEvent = event
        }
        .disposed(by: disposeBag)
    }
    
    private func setupRefreshControl(){
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: UIControl.Event.valueChanged)
        eventsTableView.addSubview(refreshControl)
    }
    
    @IBAction func tryAgainBtnClick(_ sender: Any) {
        self.eventsViewModel.requestData()
    }
    
    @objc func refreshTableView()
    {
        self.refreshControl.beginRefreshing()
        self.eventsViewModel.requestData()
    }
    
}
