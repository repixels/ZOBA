//
//  DaySummaryCell.swift
//  ZOBA
//
//  Created by Angel mas on 6/6/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import UIKit


//Add a new car crashes 


class TimeLineCell: UITableViewCell {
    
    var formattedDate = NSDate()
    
    var timeLineDate = NSDate()
    
}
class DaySummaryCell: TimeLineCell {
    static let identifier = "DateCell"
    
    @IBOutlet weak  var currentOdemeter: UILabel?
    @IBOutlet weak var salutation: UILabel?
    @IBOutlet weak  var dayImage: UIImageView?
    
    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var monthLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
