//
//  ServiceProviderCell.swift
//  ZOBA
//
//  Created by Angel mas on 6/23/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import UIKit
import TextFieldEffects

class ServiceProviderCell: UITableViewCell {
    
    @IBOutlet weak var name: HoshiTextField!
    @IBOutlet weak var address: HoshiTextField!
    
    @IBOutlet weak var nameInitial: UITextField!
    
    @IBOutlet weak var supportBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
