//
//  FuelDetailViewController.swift
//  ZOBA
//
//  Created by ZOBA on 6/14/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import UIKit
import TextFieldEffects
class FuelDetailViewController: UIViewController {

    
    @IBOutlet weak var dateAded: HoshiTextField!
    
    @IBOutlet weak var fuelAmount: HoshiTextField!
    
    @IBOutlet weak var currentOdemetr: HoshiTextField!
    
    @IBOutlet weak var serviceProvider: HoshiTextField!
    
    var data: TrackingData!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        
        dateAded.text = String(data.dateAdded)
        fuelAmount.text = data.value
        currentOdemetr.text = String(data.initialOdemeter)
        serviceProvider.text = data.serviceProviderName
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
