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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func saveOilData(sender: AnyObject) {
        
        let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let trackingDataObj = TrackingData(managedObjectContext: appDel.managedObjectContext, entityName: "TrackingData")
        
        trackingDataObj.initialOdemeter = Int64(currentOdoMeterTextField.text!)!
        
       // let time =  NSTimeInterval(dateTextField.text!)
        //print(time)
       // trackingDataObj.dateModified =  Double(dateTextField.text!)!
        trackingDataObj.value = oilAmountTextField.text!
        
        trackingDataObj.save()
    
        let typeObj = TrackingType(managedObjectContext: appDel.managedObjectContext, entityName: "TrackingType")
        
        typeObj.trackingData = NSSet(array: [trackingDataObj])
        
        typeObj.mutableSetValueForKey("trackingData").addObject(trackingDataObj)
        typeObj.
        
        let serobj = Service(managedObjectContext:appDel.managedObjectContext , entityName: "Service")
       
        serobj.name = "Oil"
        serobj.save()
        serobj.mutableSetValueForKey("trackingType").addObject(typeObj)
        
        let measuringUnitObj = MeasuringUnit(managedObjectContext: appDel.managedObjectContext, entityName: "MeasuringUnit")
        measuringUnitObj.name = "liters"
        measuringUnitObj.suffix = "L"
        
        typeObj.mutableSetValueForKey("measuringUnit").addObject(measuringUnitObj)
        
        
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
}
