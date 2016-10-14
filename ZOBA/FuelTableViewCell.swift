//
//  FuelTableViewCell.swift
//  ZOBA
//
//  Created by ZOBA on 6/15/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import UIKit

class FuelTableViewCell: UITableViewCell {

    @IBOutlet weak var fuelAmountLabel: UILabel!
    @IBOutlet weak var startingOdemeterLabel: UILabel!
    
    @IBOutlet weak var serviceProviderNameLabel: UILabel!
    
    @IBOutlet weak var fuelUnitLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
