//
//  TripCell.swift
//  ZOBA
//
//  Created by Angel mas on 6/7/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import UIKit

class TripCell: UITableViewCell {
    static let identifier = "TripData"
    
    @IBOutlet  var tripDate: UILabel?
    @IBOutlet  var initialOdemeter: UILabel?
    @IBOutlet  var tripSummary: UILabel?
    @IBOutlet  var distanceCovered: UILabel?
    @IBOutlet  var tripTitle: UILabel?
    @IBOutlet  var tripInfoBtn: UIButton?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
