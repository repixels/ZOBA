//
//  TripCell.swift
//  ZOBA
//
//  Created by Angel mas on 6/7/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import UIKit

class TripCell: TimeLineCell {
    static let identifier = "TripData"
    
    @IBOutlet weak var tripDate: UILabel?
    @IBOutlet weak var initialOdemeter: UILabel?
    @IBOutlet weak var tripSummary: UILabel?
    @IBOutlet weak var distanceCovered: UILabel?
    @IBOutlet weak var tripTitle: UILabel?
    @IBOutlet weak var tripInfoBtn: UIButton?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
