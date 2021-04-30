//
//  LTLocationTableViewCell.swift
//  LocationTracker
//
//  Created by jatin verma on 30/04/21.
//

import UIKit

class LTLocationTableViewCell: UITableViewCell {

    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    
    var location:LTLocation! {
        didSet {
            latitudeLabel.text = "Latitude: " + String(location.latitude)
            longitudeLabel.text = "Longitude: " + String(location.longitude)
            timeStampLabel.text = "Time: " + location.timeStamp.dateAndTimetoString()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
