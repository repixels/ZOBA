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
    
    @IBOutlet weak var oilDate: UILabel?
    @IBOutlet weak var initialOdemeter: UILabel?
    @IBOutlet weak var oilAmount: UILabel?
    @IBOutlet weak var serviceProvider: UILabel?
    @IBOutlet weak var oilTitle: UILabel?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
