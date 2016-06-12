//
//  AddOilViewController.swift
//  ZOBA
//
//  Created by RE Pixels on 6/5/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import UIKit
import TextFieldEffects

class AddOilViewController: UIViewController ,UIPickerViewDelegate {
    
    
    @IBOutlet weak var currentOdoMeterTextField: HoshiTextField!
    
    @IBAction func dateApperance(sender: HoshiTextField) {
        
        let datePickerView  : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(AddOilViewController.handleDatePicker(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
    }
    @IBOutlet weak var dateTextField: HoshiTextField!
    
    func handleDatePicker(sender: UIDatePicker) {
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        
        dateTextField.text = dateFormatter.stringFromDate(sender.date)
    }
    
    @IBOutlet weak var serviceProviderTextField: HoshiTextField!
    
    
    @IBOutlet weak var oilAmountTextField: HoshiTextField!
    
    var pickOption = ["one", "two" , "three" , "four"]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "Add Oil"
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.whiteColor(),
             NSFontAttributeName: UIFont(name: "Continuum Medium", size: 22)!]
        
        // Do any additional setup after loading the view.
        
        
        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        
        serviceProviderTextField.inputView = pickerView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonClicked(sender: AnyObject) {
        self.tabBarController?.selectedIndex = 1
    }
    
    @IBAction func saveOilData(sender: AnyObject) {
        
        let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let trackingDataObj = TrackingData(managedObjectContext: appDel.managedObjectContext, entityName: "TrackingData")
        
        trackingDataObj.initialOdemeter = Int64(currentOdoMeterTextField.text!)!
        
        trackingDataObj.value = oilAmountTextField.text!
        
       let dao = AbstractDao(managedObjectContext: appDel.managedObjectContext)
        
        let typeObj = dao.selectByString(entityName: "TrackingType", AttributeName: "name", value: "oil") as![TrackingType]
        
        trackingDataObj.trackingType = typeObj[0]

        let vehicleObjDAO = dao.selectByString(entityName: "Vehicle", AttributeName: "name", value: "car1") as!  [Vehicle]
    
        
        print(vehicleObjDAO[0])
        trackingDataObj.vehicle = vehicleObjDAO[0]
        
        
        trackingDataObj.save()
        performSegueWithIdentifier("oilsegue", sender: self)

        //trackingDataObj.release(appDel.managedObjectContext)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickOption[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        serviceProviderTextField.text = pickOption[row]
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickOption.count
    }
    
    
//     // MARK: - Navigation
//     
//     // In a storyboard-based application, you will often want to do a little preparation before navigation
//     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//     // Get the new view controller using segue.destinationViewController.
//     // Pass the selected object to the new view controller.
//        
//        
//        if segue.identifier == "oilSegue" {
//         
//            let des = segue.destinationViewController as! AllOilTableViewController
//            
//        }
//     }
// 
    
    
    
}
