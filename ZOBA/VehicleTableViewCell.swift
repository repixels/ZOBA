//
//  VehicleTableViewCell.swift
//  ZOBA
//
//  Created by RE Pixels on 6/17/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import UIKit

class VehicleTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var makeImageView: UIImageView!
    @IBOutlet weak var vehicleNameInitialsLabel: UILabel!
    @IBOutlet weak var vehicleNameLabel: UILabel!
    @IBOutlet weak var vehicleMakeLabel: UILabel!
    @IBOutlet weak var modelTrimYearLabel: UILabel!
    @IBOutlet weak var currentOdemeterLabel: UILabel!
    @IBOutlet weak var initialOdemeterLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
