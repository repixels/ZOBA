//
//  OilDetailsViewController.swift
//  ZOBA
//
//  Created by ZOBA on 6/14/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import UIKit
import TextFieldEffects

class OilDetailsViewController: UIViewController {

//    
//    @IBOutlet weak var dateAdedd: UILabel!
//  
//    
//    @IBOutlet weak var currentOdemeter: UILabel!
//  
//    
//    @IBOutlet weak var serviceProvider: UILabel!
//    
//    
//    @IBOutlet weak var oilAmount: UILabel!
//    
    
    
    @IBOutlet weak var dateAdedd: HoshiTextField!
    
    @IBOutlet weak var currentOdemeter: HoshiTextField!
    
    @IBOutlet weak var oilAmount: HoshiTextField!
    
    @IBOutlet weak var serviceProvider: HoshiTextField!
    
    var data: TrackingData!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

    }
    
    override func viewWillAppear(animated: Bool) {
        
        currentOdemeter.text = String(data.initialOdemeter)
        dateAdedd.text = String(NSDate(timeIntervalSince1970: data.dateAdded))
        oilAmount.text = data.value
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
