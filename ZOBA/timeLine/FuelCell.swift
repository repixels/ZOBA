//
//  FuelCell.swift
//  ZOBA
//
//  Created by Angel mas on 6/7/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import UIKit

class FuelCell: TimeLineCell {
    static let identifier = "FuelData"
    
    @IBOutlet weak var fuelDate: UILabel?
    @IBOutlet weak var initialOdemeter: UILabel?
    @IBOutlet weak var fuelAmount: UILabel?
    @IBOutlet weak var serviceProvider: UILabel?
    @IBOutlet weak var fuelTitle: UILabel?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
