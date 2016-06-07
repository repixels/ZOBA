//
//  FuelCell.swift
//  ZOBA
//
//  Created by Angel mas on 6/7/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import UIKit

class FuelCell: UITableViewCell {
    static let identifier = "FuelData"
    
    @IBOutlet  var fuelDate: UILabel?
    @IBOutlet  var initialOdemeter: UILabel?
    @IBOutlet  var fuelAmount: UILabel?
    @IBOutlet  var serviceProvider: UILabel?
    @IBOutlet  var fuelTitle: UILabel?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
