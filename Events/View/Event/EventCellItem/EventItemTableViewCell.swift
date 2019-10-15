//
//  EventItemTableViewCell.swift
//  Events
//
//  Created by Darci Neto on 15/10/19.
//  Copyright © 2019 Darci Neto. All rights reserved.
//

import UIKit

class EventItemTableViewCell: UITableViewCell {
    var id:String?
    @IBOutlet weak var eventImage : UIImageView!
    @IBOutlet weak var eventTitle : UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventSchedule: UILabel!
    
    public var cellEvent : Event! {
        didSet {
            self.id = cellEvent.id
            self.eventImage.download(from: cellEvent.image!)
            self.eventTitle.text = cellEvent.title
            if let date = cellEvent.date {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/yyyy"
                self.eventDate.text = "🗓" + formatter.string(from: date)
                formatter.dateFormat = "HH:mm"
                self.eventSchedule.text = "🕐" + formatter.string(from: date)
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
