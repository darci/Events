//
//  EventItemTableViewCell.swift
//  Events
//
//  Created by Darci Neto on 15/10/19.
//  Copyright © 2019 Darci Neto. All rights reserved.
//

import UIKit

class EventItemTableViewCell: UITableViewCell {
    @IBOutlet weak var eventImage : UIImageView!
    @IBOutlet weak var eventTitle : UILabel!
    @IBOutlet weak var eventDate: UILabel!
    
    public var cellEvent : Event! {
        didSet {

            self.eventImage.download(from: cellEvent.image!)
            self.eventTitle.text = cellEvent.title
            if let date = cellEvent.date {
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm dd/MM/yyyy"
                self.eventDate.text = formatter.string(from: date)
            }
            else {
                self.eventDate.text = "Data não informada"
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        eventImage.image = UIImage()
    }
    
}
