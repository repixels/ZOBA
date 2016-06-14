//
//  TripTableViewCell.swift
//  ZOBA
//
//  Created by RE Pixels on 6/13/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import UIKit

class TripTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var startingLocationLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var endingLocationLabel: UILabel!
    
    @IBOutlet weak var coveredMilageLabel: UILabel!
    @IBOutlet weak var measuringUnitLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
