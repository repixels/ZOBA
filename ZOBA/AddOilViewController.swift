//
//  AddOilViewController.swift
//  ZOBA
//
//  Created by RE Pixels on 6/5/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import UIKit
import TextFieldEffects

class AddOilViewController: UIViewController ,UIPickerViewDelegate  , UIPickerViewDataSource{
    
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    
    @IBOutlet weak var currentOdoMeterTextField: HoshiTextField!
    
    @IBAction func DateTouchUpInsid(sender: HoshiTextField) {
        
        let datePickerView  : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Date
        sender.inputAccessoryView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(AddOilViewController.handleDatePicker(_:)), forControlEvents: UIControlEvents.ValueChanged)
       
    }
 
    @IBOutlet weak var dateTextField: HoshiTextField!
    
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    func handleDatePicker(sender: UIDatePicker) {
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        
        dateTextField.text = dateFormatter.stringFromDate(sender.date)
        
        dateTextField.resignFirstResponder()

    }
    

    @IBOutlet weak var oilAmountTextField: HoshiTextField!
    
    var pickOption = ["one", "two" , "three" , "four", "five" , "six"  ]
    
    
    //Validation Indicatiors
    
    var isCurrentOdeReady = false
    var isOilMountReady = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "Add Oil"
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.whiteColor(),
             NSFontAttributeName: UIFont(name: "Continuum Medium", size: 22)!]
        
        // Do any additional setup after loading the view.
        
        pickerView.delegate = self

        pickerView.dataSource = self
       
    }
    
    @IBAction func currentOdeEditingChang(sender: AnyObject) {
        
        if (currentOdoMeterTextField.text?.isNotEmpty == true && DataValidations.hasNoWhiteSpaces(currentOdoMeterTextField.text!)) {
            
           
            isCurrentOdeReady = true
        }
        else
        {
            
            isCurrentOdeReady = false
        }
        
        
    }
    
    func showErrorMessage(message:String)
    {
        self.currentOdoMeterTextField.borderInactiveColor = UIColor.redColor()
        self.currentOdoMeterTextField.borderActiveColor = UIColor.redColor()
        self.currentOdoMeterTextField.placeholderColor = UIColor.redColor()
        self.currentOdoMeterTextField.placeholderLabel.text = message
        self.currentOdoMeterTextField.placeholderLabel.sizeToFit()
        self.currentOdoMeterTextField.placeholderLabel.alpha = 1.0
        
    }
    
    func showValidMessage(message:String)
    {
        self.currentOdoMeterTextField.borderInactiveColor = UIColor.greenColor()
        self.currentOdoMeterTextField.borderActiveColor = UIColor.greenColor()
        self.currentOdoMeterTextField.placeholderColor = UIColor.whiteColor()
        self.currentOdoMeterTextField.placeholderLabel.text = message
        enableSaveBtn()
    }

   
    
    @IBAction func currentEditingDidEnd(sender: AnyObject) {
        
        let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        let vehicleObj = Vehicle(managedObjectContext: appDel.managedObjectContext, entityName: "Vehicle")
        vehicleObj.currentOdemeter = 234
        
        if (Int64(currentOdoMeterTextField.text!) > vehicleObj.currentOdemeter ) {
            
             showValidMessage("Current Odemeter")
            isCurrentOdeReady = true
        }
        else
        {
            showErrorMessage("Enter valid Odemeter")
            isCurrentOdeReady = false
        }
            
            validateSaveBtn()
        
    }
    
    func validateSaveBtn() {
        if (isOilMountReady && isCurrentOdeReady) {
            enableSaveBtn()
        }
        else
        {
            disableSaveBtn()
        }
    }
    
    func enableSaveBtn() {
        saveBtn.enabled = true
    }
    
    func disableSaveBtn() {
        saveBtn.enabled = false
    }
    
    
    @IBAction func oilMountEditingChange(sender: AnyObject) {
    
//        if (Int(oilAmountTextField.text!)! > 10 | Int(oilAmountTextField.text!)! < 10000) {
//        
//            showValidMessage("Oil Amount")
//            isOilMountReady = true
//        }
//        else
//        {
//            showErrorMessage("Enter Valid Oil Amount")
//            isOilMountReady = false
//        }
        
    }
    @IBAction func oilMountEditingDidEnd(sender: AnyObject) {
        
        if (currentOdoMeterTextField.text?.isNotEmpty ==  true && DataValidations.hasNoWhiteSpaces(currentOdoMeterTextField.text!)) {
            isOilMountReady = true
        }
        else
        {
            isOilMountReady = false
            
        }
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
//    
//    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//       // serviceProviderTextField.text = pickOption[row]
//    }
//
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickOption.count
    }
    
    
//    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        incidentPickerTextField.text = pickOption[row]
//        //hides the pickview
//        TextField.resignFirstResponder()
//    }
    
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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
        
        dateTextField.resignFirstResponder()
    }
    
    
}
