//
//  OilCell.swift
//  ZOBA
//
//  Created by Angel mas on 6/7/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import UIKit

class OilCell: TimeLineCell {
    static let identifier = "OilData"
    
    @IBOutlet  var oilDate: UILabel?
    @IBOutlet  var initialOdemeter: UILabel?
    @IBOutlet  var oilAmount: UILabel?
    @IBOutlet  var serviceProvider: UILabel?
    @IBOutlet  var oilTitle: UILabel?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
