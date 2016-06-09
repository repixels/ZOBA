//
//  AddFuelViewController.swift
//  ZOBA
//
//  Created by RE Pixels on 6/5/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import UIKit
import TextFieldEffects

class AddFuelViewController: UIViewController {

    @IBOutlet weak var DateAndTimeTextField: HoshiTextField!
    @IBOutlet weak var fuelAmountTextField: HoshiTextField!
    @IBOutlet weak var currentOdometerTextField: HoshiTextField!

    @IBOutlet weak var dateAndTimeImage: UIImageView!
    
    @IBOutlet weak var OdometerImage: UIImageView!
    
    @IBOutlet weak var fuelAmountImage: UIImageView!
    
    
    @IBOutlet weak var serviceProviderTextField: HoshiTextField!
   
    @IBOutlet weak var serviceProviderImage: UIImageView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add Fuel"
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.whiteColor(),
             NSFontAttributeName: UIFont(name: "Continuum Medium", size: 22)!]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
