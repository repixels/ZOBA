//
//  AddOilViewController.swift
//  ZOBA
//
//  Created by RE Pixels on 6/5/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import UIKit
import TextFieldEffects

class AddOilViewController: UIViewController ,UIPickerViewDelegate , UIPickerViewDataSource{
    
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    
    @IBOutlet weak var currentOdoMeterTextField: HoshiTextField!
    
    @IBOutlet weak var oilAmountTextField: HoshiTextField!
    
    
    //Validation Indicatiors
    
    var isCurrentOdeReady = false
    var isOilMountReady = false
    
    // date picker
     var formatter = NSDateFormatter()

    var date : String!
    
    
     var datePickerView : UIDatePicker!
    
    @IBAction func dateSelectBtn(sender: AnyObject) {
        
         datePickerView = UIDatePicker()

      datePickerView.datePickerMode = UIDatePickerMode.Date
        
        dateTextField.inputView = datePickerView
        
        dateTextField.becomeFirstResponder()
        datePickerView.addTarget(self, action: #selector(AddOilViewController.datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)

    }
    func datePickerValueChanged(sender:UIDatePicker) {
        
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        
        formatter.timeStyle = NSDateFormatterStyle.NoStyle
        
        date = formatter.stringFromDate(sender.date)
        
        dateTextField.text = date
    }
   
    @IBOutlet weak var pickerViewTextField: HoshiTextField!
    
    
    @IBOutlet weak var dateTextField: HoshiTextField!
    
    
  //pickerView Options
    var pickOption : [ServiceProvider]!  //= ["one", "two" , "three" , "four", "five" , "six" ]

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
        
        
        if (NSNumber(integer: Int(currentOdoMeterTextField.text!)!).integerValue > vehicleObj.currentOdemeter.integerValue ) {
            
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
    
        if (Int(oilAmountTextField.text!)! < 1000) {
        
            showValidMessage("Oil Amount")
            isOilMountReady = true
        }
        else
        {
            showErrorMessage("Enter Valid Oil Amount")
            isOilMountReady = false
        }
    }
    @IBAction func oilMountEditingDidEnd(sender: AnyObject) {
        
        if (oilAmountTextField.text?.isNotEmpty ==  true && DataValidations.hasNoWhiteSpaces(oilAmountTextField.text!)) {
            isOilMountReady = true
        }
        else
        {
            isOilMountReady = false
            
        }
    }
    
    @IBOutlet weak var initialOdemeter: HoshiTextField!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
       
        let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        let vehicleObj = Vehicle(managedObjectContext: appDel.managedObjectContext, entityName: "Vehicle")
        initialOdemeter.text = String(vehicleObj.initialOdemeter)
        
        let dao = AbstractDao(managedObjectContext: appDel.managedObjectContext)
        
        let serviceProviderDAO = dao.selectAll(entityName: "ServiceProvider") as! [ServiceProvider]
        
        pickOption = serviceProviderDAO
        
        disableSaveBtn()
    }
    
    var pickerView : UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add Oil"
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.whiteColor(),
             NSFontAttributeName: UIFont(name: "Continuum Medium", size: 22)!]
        
        // Do any additional setup after loading the view.
        
        formatter.dateFormat = "MMM dd,yyyy"
        
        //picker View
        
        pickerView = UIPickerView()
        pickerView.delegate = self
        
        pickerView.dataSource = self
        
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(AddOilViewController.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(AddOilViewController.donePicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        
        pickerViewTextField.inputAccessoryView = toolBar
        
        dateTextField.inputAccessoryView = toolBar
    }
    
    
    func donePicker() {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    @IBAction func pickerView(sender: AnyObject) {
        
        pickerViewTextField.inputView = pickerView
    
        pickerViewTextField.becomeFirstResponder()

    }
    
    @IBAction func saveOilData(sender: AnyObject) {
        
        let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let trackingDataObj = TrackingData(managedObjectContext: appDel.managedObjectContext, entityName: "TrackingData")
        
        trackingDataObj.initialOdemeter = NSNumber (integer: Int(currentOdoMeterTextField.text!)!)
        
        trackingDataObj.value = oilAmountTextField.text!
        
        trackingDataObj.dateAdded = datePickerView.date.timeIntervalSince1970
        
       let dao = AbstractDao(managedObjectContext: appDel.managedObjectContext)
        
        let typeObj = dao.selectByString(entityName: "TrackingType", AttributeName: "name", value: "oil") as![TrackingType]
        
        trackingDataObj.trackingType = typeObj[0]

        let vehicleObjDAO = dao.selectByString(entityName: "Vehicle", AttributeName: "name", value: "car1") as!  [Vehicle]
    
        
        print(vehicleObjDAO[0])
        trackingDataObj.vehicle = vehicleObjDAO[0]
        
        
        trackingDataObj.save()
        performSegueWithIdentifier("oilSegue", sender: self)

        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickOption[row].name
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickOption.count
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerViewTextField.text = pickOption[row].name
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
        
           }
    
    
}
