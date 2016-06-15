//
//  AddFuelViewController.swift
//  ZOBA
//
//  Created by RE Pixels on 6/5/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import UIKit
import TextFieldEffects

class AddFuelViewController: UIViewController , UIPickerViewDelegate {

    @IBOutlet weak var saveBtn: UIBarButtonItem!
    
 
    @IBOutlet weak var vehiclePickerView: UIPickerView!
    
    @IBOutlet weak var initialOdemeter: HoshiTextField!
   
   
    @IBOutlet weak var dateTextField: HoshiTextField!

    @IBOutlet weak var fuelAmountTextField: HoshiTextField!
    
    @IBOutlet weak var currentOdometerTextField: HoshiTextField!
    @IBOutlet weak var serviceProviderTextFeild: HoshiTextField!

    
    
    @IBAction func fuelAmountEditingDidEnd(sender: AnyObject) {
        
        
        if (fuelAmountTextField.text?.isNotEmpty ==  true && DataValidations.hasNoWhiteSpaces(fuelAmountTextField.text!)) {
            isFuelMountReady = true
        }
        else
        {
            isFuelMountReady = false
            
        }
        
    }
    
    @IBAction func fuelAmountEditingChang(sender: AnyObject) {
        
        if (Int(fuelAmountTextField.text!)! < 90) {
            
            showAmountValidMessage("fuel Amount")
            isFuelMountReady = true
        }
        else
        {
            showAmountErrorMessage("Enter Valid fuel Amount")
            isFuelMountReady = false
        }
    }
    
    @IBAction func currentOdemterEditingDidEnd(sender: AnyObject) {
        
        let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        let vehicleObj = Vehicle(managedObjectContext: appDel.managedObjectContext, entityName: "Vehicle")
        
        if (NSNumber(integer: Int(currentOdometerTextField.text!)!).integerValue > vehicleObj.currentOdemeter.integerValue ) {
            
            showAmountValidMessage("Current Odemeter")
            isCurrentOdeReady = true
        }
        else
        {
            showAmountErrorMessage("Enter valid Odemeter")
            isCurrentOdeReady = false
        }
        validateSaveBtn()
    }
    
    
    @IBAction func currentOdemeterEditingChang(sender: AnyObject) {
        
        if (currentOdometerTextField.text?.isNotEmpty == true && DataValidations.hasNoWhiteSpaces(currentOdometerTextField.text!)) {
            
            isCurrentOdeReady = true
        }
        else
        {
            isCurrentOdeReady = false
        }
        
    }
    
    func validateSaveBtn() {
        if (isFuelMountReady && isCurrentOdeReady) {
            enablBtn()
        }
        else
        {
            disableBtn()
        }
    }
    
    func showOdemeterErrorMessage(message:String)
    {
        self.currentOdometerTextField.borderInactiveColor = UIColor.redColor()
        self.currentOdometerTextField.borderActiveColor = UIColor.redColor()
        self.currentOdometerTextField.placeholderColor = UIColor.redColor()
        self.currentOdometerTextField.placeholderLabel.text = message
        self.currentOdometerTextField.placeholderLabel.sizeToFit()
        self.currentOdometerTextField.placeholderLabel.alpha = 1.0
    }
    
    func showOdemeterValidMessage(message:String)
    {
        self.currentOdometerTextField.borderInactiveColor = UIColor.greenColor()
        self.currentOdometerTextField.borderActiveColor = UIColor.greenColor()
        self.currentOdometerTextField.placeholderColor = UIColor.whiteColor()
        self.currentOdometerTextField.placeholderLabel.text = message
            enablBtn()
    }
    
    
    func showAmountErrorMessage(message:String)
    {
        self.fuelAmountTextField.borderInactiveColor = UIColor.redColor()
        self.fuelAmountTextField.borderActiveColor = UIColor.redColor()
        self.fuelAmountTextField.placeholderColor = UIColor.redColor()
        self.fuelAmountTextField.placeholderLabel.text = message
        self.fuelAmountTextField.placeholderLabel.sizeToFit()
        self.fuelAmountTextField.placeholderLabel.alpha = 1.0
    }
    
    func showAmountValidMessage(message:String)
    {
        self.fuelAmountTextField.borderInactiveColor = UIColor.greenColor()
        self.fuelAmountTextField.borderActiveColor = UIColor.greenColor()
        self.fuelAmountTextField.placeholderColor = UIColor.whiteColor()
        self.fuelAmountTextField.placeholderLabel.text = message
        enablBtn()
    }
    
    
    func disableBtn()  {
        
        saveBtn.enabled = false
        saveBtn.tintColor = UIColor.grayColor()
    }
    
    func enablBtn()  {
        saveBtn.enabled = true
        saveBtn.tintColor = UIColor.blueColor()
    }
    
    //Validation Indicatiors
    
    var isCurrentOdeReady = false
    var isFuelMountReady = false


    var formatter = NSDateFormatter()
    

    var pickOption : [ServiceProvider]! //= ["one", "two" , "three" , "four"]

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickOption[row].name
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        serviceProviderTextFeild.text = pickOption[row].name
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickOption.count
    }
    var pickerView : UIPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add Fuel"
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.whiteColor(),
             NSFontAttributeName: UIFont(name: "Continuum Medium", size: 22)!]
        // Do any additional setup after loading the view.
        
          formatter.dateFormat = "MMM dd,yyyy"
        
         pickerView = UIPickerView()
        
        pickerView.delegate = self
        
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(AddOilViewController.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(AddFuelViewController.donePicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        
        serviceProviderTextFeild.inputAccessoryView = toolBar
        
        dateTextField.inputAccessoryView = toolBar

    }
    
    func donePicker() {
        view.endEditing(true)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        let vehicleObj = Vehicle(managedObjectContext: appDel.managedObjectContext, entityName: "Vehicle")
        initialOdemeter.text = String(vehicleObj.initialOdemeter)
        
        let dao = AbstractDao(managedObjectContext: appDel.managedObjectContext)
        
        let serviceProviderDAO = dao.selectAll(entityName: "ServiceProvider") as! [ServiceProvider]
        
        pickOption = serviceProviderDAO
       
        disableBtn()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveFuel(sender: AnyObject) {
        
        
        let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let trackingDataObj = TrackingData(managedObjectContext: appDel.managedObjectContext, entityName: "TrackingData")
        
        trackingDataObj.initialOdemeter = NSNumber(integer : Int(currentOdometerTextField.text!)!)
        
        trackingDataObj.value = fuelAmountTextField.text!
        
        trackingDataObj.dateAdded = datePickerView.date.timeIntervalSince1970
    

        let dao = AbstractDao(managedObjectContext: appDel.managedObjectContext)
        
               
        let typeObj = dao.selectByString(entityName: "TrackingType", AttributeName: "name", value: "fuel") as![TrackingType]
        
        trackingDataObj.trackingType = typeObj[0]
        
        let vehicleObjDAO = dao.selectByString(entityName: "Vehicle", AttributeName: "name", value: "car1") as!  [Vehicle]
        
        trackingDataObj.vehicle = vehicleObjDAO[0]
        
        trackingDataObj.save()
        
        performSegueWithIdentifier("allData", sender: self)
    }

    
     var datePickerView : UIDatePicker!
    
     @IBAction func dateUpdate(sender: AnyObject) {
        
      datePickerView = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.Date
        
        dateTextField.inputView = datePickerView
        
        dateTextField.becomeFirstResponder()
        datePickerView.addTarget(self, action: #selector(AddFuelViewController.datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)

     }
    
       var date : String!
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        //  let dateFormatter = NSDateFormatter()
        
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        
        formatter.timeStyle = NSDateFormatterStyle.NoStyle
        
        date = formatter.stringFromDate(sender.date)
        
        dateTextField.text = date
        
    }
    @IBAction func servicePROVIDER(sender: AnyObject) {
        
        serviceProviderTextFeild.inputView = pickerView
        
        serviceProviderTextFeild.becomeFirstResponder()
        
    }
    /*
    // MARK: - Navigation

     //In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
 
        
        if segue.identifier == "fuelSegue" {
            
            let des = segue.destinationViewController as! FuelTableViewController

        }
    }
 */
   
 


}
