//
//  DaySummaryCell.swift
//  ZOBA
//
//  Created by Angel mas on 6/6/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import UIKit

class DaySummaryCell: UITableViewCell {
    static let identifier = "DateCell"
    
@IBOutlet  var date: UILabel?
    @IBOutlet  var currentOdemeter: UILabel?
    @IBOutlet  var month: UILabel?
    @IBOutlet  var salutation: UILabel?
    @IBOutlet  var dayImage: UIImageView?
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}