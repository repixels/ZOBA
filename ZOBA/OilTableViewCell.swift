//
//  OilTableViewCell.swift
//  ZOBA
//
//  Created by ZOBA on 6/15/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import UIKit

class OilTableViewCell: UITableViewCell {

    @IBOutlet weak var startingOdemeterLabel: UILabel!
    
    @IBOutlet weak var serviceProvideLabel: UILabel!
    @IBOutlet weak var oilAmountLabel: UILabel!
    
    @IBOutlet weak var oilMesuringUnitLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
