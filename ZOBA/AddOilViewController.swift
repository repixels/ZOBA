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
    
    var isCurrentOdeReady = false
    var isOilMountReady = false
    var formatter = NSDateFormatter()
    var date : String!
    var pickerView : UIPickerView!
    var datePickerView : UIDatePicker!
    var pickOption : [ServiceProvider]!
    var selectedVehicle : Vehicle!
    var vehicles : [Vehicle]!
    
    @IBOutlet weak var initialOdemeter: HoshiTextField!
    
    @IBOutlet weak var vehiclesPickerView: UIPickerView!
    
    @IBOutlet weak var pickerViewTextField: HoshiTextField!
    
    
    @IBOutlet weak var dateTextField: HoshiTextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add Oil"
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.whiteColor(),
             NSFontAttributeName: UIFont(name: "Continuum Medium", size: 22)!]
        
        // Do any additional setup after loading the view.
        
        formatter.dateFormat = "MMM dd,yyyy"
        
        let dao = AbstractDao(managedObjectContext: SessionObjects.currentManageContext)
        
        vehicles = dao.selectAll(entityName: "Vehicle") as! [Vehicle]
        
        
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
        
        vehiclesPickerView.delegate = self
        
        selectedVehicle = vehicles[vehiclesPickerView.selectedRowInComponent(0)]
    }
    
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
 

    @IBAction func currentOdeEditingChang(sender: AnyObject) {
        
        if (currentOdoMeterTextField.text?.isNotEmpty == true && DataValidations.hasNoWhiteSpaces(currentOdoMeterTextField.text!)) {
           
            isCurrentOdeReady = true
        }
        else
        {
            isCurrentOdeReady = false
        }
    }
    
    func showErrorMessage(message:String , textField : HoshiTextField)
    {
        textField.borderInactiveColor = UIColor.redColor()
        textField.borderActiveColor = UIColor.redColor()
       textField.placeholderColor = UIColor.redColor()
       textField.placeholderLabel.text = message
        textField.placeholderLabel.sizeToFit()
        textField.placeholderLabel.alpha = 1.0
    }
    
    func showValidMessage(message:String , textField : HoshiTextField )
    {
        textField.borderInactiveColor = UIColor.greenColor()
        textField.borderActiveColor = UIColor.greenColor()
        textField.placeholderColor = UIColor.whiteColor()
       textField.placeholderLabel.text = message
        enableSaveBtn()
    }
    
    @IBAction func currentEditingDidEnd(sender: AnyObject) {
        
       // let vehicleObj = Vehicle(managedObjectContext: SessionObjects.currentManageContext, entityName: "Vehicle")
        
        
        if (NSNumber(integer: Int(currentOdoMeterTextField.text!)!).integerValue > selectedVehicle.currentOdemeter!.integerValue ) {
            
             showValidMessage("Current Odemeter" , textField: currentOdoMeterTextField)
            isCurrentOdeReady = true
        }
        else
        {
            showErrorMessage("Enter valid Odemeter" , textField: currentOdoMeterTextField)
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
        
            showValidMessage("Oil Amount" , textField: oilAmountTextField)
            isOilMountReady = true
        }
        else
        {
            showErrorMessage("Enter Valid Oil Amount" , textField: oilAmountTextField)
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
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
       
        // initialOdemeter.text = String(selectedVehicle.initialOdemeter)
        
        let dao = AbstractDao(managedObjectContext: SessionObjects.currentManageContext)
        
        let trackingData = dao.selectAll(entityName: "TrackingData")
        
        if trackingData.count == 0
        {
            initialOdemeter.text = String(selectedVehicle.initialOdemeter!)
        }
        else
        {
            let lastObj = trackingData.last as! TrackingData
            
            initialOdemeter.text = String(lastObj.initialOdemeter)
        }
        
        let serviceProviderDAO = dao.selectAll(entityName: "ServiceProvider") as! [ServiceProvider]
        
        pickOption = serviceProviderDAO
        
        disableSaveBtn()
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
        
        let trackingDataObj = TrackingData(managedObjectContext:SessionObjects.currentManageContext, entityName: "TrackingData")
        
        trackingDataObj.initialOdemeter = NSNumber (integer: Int(currentOdoMeterTextField.text!)!)
        
        trackingDataObj.value = oilAmountTextField.text!
        
        trackingDataObj.dateAdded = datePickerView.date
        
        
        let trackingTypeObj = TrackingData(managedObjectContext:SessionObjects.currentManageContext, entityName: "TrackingData")
        
       trackingTypeObj.value = "oil"
    
       trackingTypeObj.save()
        
    
        
       let dao = AbstractDao(managedObjectContext: SessionObjects.currentManageContext)
        
        let typeObj = dao.selectByString(entityName: "TrackingType", AttributeName: "name", value: "oil") as![TrackingType]
        
        trackingDataObj.trackingType = typeObj[0]
        
        trackingDataObj.vehicle = selectedVehicle
        
        trackingDataObj.save()
        
        performSegueWithIdentifier("oilSegue", sender: self)
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       
        if pickerView == vehiclesPickerView {
            
            return vehicles[row].name
        }
        else
        {
            return pickOption[row].name
        }
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        
        
        if pickerView == vehiclesPickerView
        {
            return vehicles.count
        }
        else
        {
            return pickOption.count
            
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == vehiclesPickerView {
            
            selectedVehicle = vehicles[row]
        }
            
        else
        {
            pickerViewTextField.text = pickOption[row].name
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
        
           }
    
}
