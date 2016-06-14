//
//  FuelDetailViewController.swift
//  ZOBA
//
//  Created by ZOBA on 6/14/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import UIKit

class FuelDetailViewController: UIViewController {

  
    @IBOutlet weak var dateAded: UILabel!
    
    
    @IBOutlet weak var fuelAmount: UILabel!
    
    @IBOutlet weak var currentOdemetr: UILabel!
    
    @IBOutlet weak var serviceProvider: UILabel!
    var data: TrackingData!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(animated: Bool) {
        
        dateAded.text = String(NSDate(timeIntervalSince1970: data.dateAdded))
        fuelAmount.text = data.value
        currentOdemetr.text = String(data.initialOdemeter)
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
