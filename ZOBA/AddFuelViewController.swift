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
    
    @IBOutlet weak var pickerViewBackGround: UIView!
    
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func doneBtn(sender: AnyObject) {
        
      let date = formatter.stringFromDate(self.datePicker.date)
        
        self.dateTextField.text = date
    }
    
   
    @IBOutlet weak var dateTextField: HoshiTextField!

    @IBOutlet weak var fuelAmountTextField: HoshiTextField!
    
    @IBOutlet weak var currentOdometerTextField: HoshiTextField!
    @IBOutlet weak var serviceProviderTextFeild: HoshiTextField!

    @IBOutlet weak var dateAndTimeImage: UIImageView!
    
    @IBOutlet weak var OdometerImage: UIImageView!
    
    @IBOutlet weak var fuelAmountImage: UIImageView!
   
    @IBOutlet weak var serviceProviderImage: UIImageView!
    
    
    
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
        
        
        if (Int64(currentOdometerTextField.text!) > vehicleObj.currentOdemeter ) {
            
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

    
    func initializeTextFieldInputView(){
        self.datePicker.backgroundColor = UIColor.whiteColor()
        self.datePicker.datePickerMode = UIDatePickerMode.Date
        self.dateTextField.inputView = self.pickerViewBackGround
        self.pickerViewBackGround.removeFromSuperview()
    }
    

    var formatter = NSDateFormatter()
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if (textField == self.dateTextField){
            self.datePicker.hidden = false
        }else{
            self.datePicker.hidden = true
        }
        return true
    }

    
    var pickOption = ["one", "two" , "three" , "four"]

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickOption[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        serviceProviderTextFeild.text = pickOption[row]
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickOption.count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add Fuel"
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.whiteColor(),
             NSFontAttributeName: UIFont(name: "Continuum Medium", size: 22)!]
        // Do any additional setup after loading the view.
        
          formatter.dateFormat = "MMM dd,yyyy"
        
        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        
        serviceProviderTextFeild.inputView = pickerView

    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.initializeTextFieldInputView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveFuel(sender: AnyObject) {
        
        
        let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let trackingDataObj = TrackingData(managedObjectContext: appDel.managedObjectContext, entityName: "TrackingData")
        
        trackingDataObj.initialOdemeter = Int64(currentOdometerTextField.text!)!
        
        trackingDataObj.value = fuelAmountTextField.text!
        trackingDataObj.dateAdded = datePicker.date.timeIntervalSince1970
        
        
        
        let trackingType = TrackingType(managedObjectContext: appDel.managedObjectContext, entityName: "TrackingType")
        
        trackingType.name = "fuel"
        
        trackingType.save()
        
        
        let measuringUnitObj = MeasuringUnit(managedObjectContext: appDel.managedObjectContext, entityName: "MeasuringUnit")
        measuringUnitObj.name = "liters"
        measuringUnitObj.suffix = "L"
        
        measuringUnitObj.mutableSetValueForKey("trackingType").addObject(trackingType)
        
        measuringUnitObj.save()
        
        
        let serobj = Service(managedObjectContext:appDel.managedObjectContext , entityName: "Service")
        
        serobj.name = "fuel"
        serobj.save()
        serobj.mutableSetValueForKey("trackingType").addObject(trackingType)
        
        let dao = AbstractDao(managedObjectContext: appDel.managedObjectContext)
        
        let typeObj = dao.selectByString(entityName: "TrackingType", AttributeName: "name", value: "fuel") as![TrackingType]
        
        trackingDataObj.trackingType = typeObj[0]
        
        let vehicleObjDAO = dao.selectByString(entityName: "Vehicle", AttributeName: "name", value: "car1") as!  [Vehicle]
        
        trackingDataObj.vehicle = vehicleObjDAO[0]
      //  VehicleObjDAO.first!.mutableSetValueForKey("traclingData").addObject(trackingDataObj)
        
        trackingDataObj.save()
        performSegueWithIdentifier("fuelSegue", sender: self)
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
