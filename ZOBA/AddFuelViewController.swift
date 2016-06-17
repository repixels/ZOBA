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

     var pickerView : UIPickerView!
    
     var selectedVehicle : Vehicle!
    
     var vehicles : [Vehicle]!
    
     var isCurrentOdeReady = false
    
     var isFuelMountReady = false
    
     var formatter = NSDateFormatter()
    
     var pickOption : [ServiceProvider]!
    
     var datePickerView : UIDatePicker!
    
     var date : String!
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(true)
        
        if selectedVehicle.currentOdemeter == nil {
           initialOdemeter.text = String(0)
        }
        else
        {
        initialOdemeter.text = String(selectedVehicle.currentOdemeter!)
        }
        let dao = AbstractDao(managedObjectContext: SessionObjects.currentManageContext)

        
        vehicles = dao.selectAll(entityName: "Vehicle") as! [Vehicle]
        
        let serviceProviderDAO = dao.selectAll(entityName: "ServiceProvider") as! [ServiceProvider]
        
        pickOption = serviceProviderDAO
        
        disableBtn()
        
        print("View Will Appear")
    }
    
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
        
        vehiclePickerView.delegate = self
        
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
        
        
        selectedVehicle = vehicles[vehiclePickerView.selectedRowInComponent(0)]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
        
        if  (NSNumber(integer: Int(fuelAmountTextField.text!)!).integerValue < 90) &&   (NSNumber(integer: Int(fuelAmountTextField.text!)!).integerValue > 0)  {
            
            showValidMessage("fuel Amount" , textField: fuelAmountTextField)
            isFuelMountReady = true
        }
        else
        {
            showErrorMessage("Enter Valid fuel Amount"  , textField: fuelAmountTextField)
            isFuelMountReady = false
        }
    }
    
    @IBAction func currentOdemterEditingDidEnd(sender: AnyObject) {
        
        if (NSNumber(integer: Int(currentOdometerTextField.text!)!).integerValue >= selectedVehicle.currentOdemeter!.integerValue ) {
            
            showValidMessage("Current Odemeter",textField: currentOdometerTextField)
            isCurrentOdeReady = true
        }
        else
        {
            showErrorMessage("Enter valid Odemeter" ,textField: currentOdometerTextField)
            isCurrentOdeReady = false
        }
        validateSaveBtn()
    }
    
    @IBAction func currentOdemeterEditingChang(sender: AnyObject) {
        
        if (currentOdometerTextField.text?.isNotEmpty == true && DataValidations.hasNoWhiteSpaces(currentOdometerTextField.text!) ) {
            
            isCurrentOdeReady = true
        }
        else
        {
            isCurrentOdeReady = false
        }
    }
    
    func validateSaveBtn() {
        if (isFuelMountReady && isCurrentOdeReady && dateTextField.text?.isNotEmpty == true) {
            enablBtn()
        }
        else
        {
            disableBtn()
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
    
    func showValidMessage(message:String , textField : HoshiTextField)
    {
        textField.borderInactiveColor = UIColor.greenColor()
        textField.borderActiveColor = UIColor.greenColor()
        textField.placeholderColor = UIColor.whiteColor()
        textField.placeholderLabel.text = message
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
    

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       
        if pickerView == vehiclePickerView {
            
            return vehicles[row].name
        }
        else
        {
        
        return pickOption[row].name
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == vehiclePickerView {
        
           selectedVehicle = vehicles[row]
        }
        
        else
        {
        serviceProviderTextFeild.text = pickOption[row].name
        }
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       
        let dao = AbstractDao(managedObjectContext: SessionObjects.currentManageContext)
        
        vehicles = dao.selectAll(entityName: "Vehicle") as! [Vehicle]
        
        if pickerView == vehiclePickerView
        {
            return vehicles.count
        }
        else
        {
        return pickOption.count
    
        }
    }
    
    func donePicker() {
        view.endEditing(true)
    }
    
    @IBAction func saveFuel(sender: AnyObject) {
        
        let trackingDataObj = TrackingData(managedObjectContext: SessionObjects.currentManageContext , entityName: "TrackingData")
        
        trackingDataObj.initialOdemeter = NSNumber(integer : Int(currentOdometerTextField.text!)!)
        
        trackingDataObj.value = fuelAmountTextField.text!
        
        trackingDataObj.dateAdded = datePickerView.date
        
        trackingDataObj.serviceProviderName = serviceProviderTextFeild.text
    
        let dao = AbstractDao(managedObjectContext: SessionObjects.currentManageContext)
        
        let typeObj = dao.selectByInt(entityName: "TrackingType", AttributeName: "typeId", value: 1) as![TrackingType]
        
        trackingDataObj.trackingType = typeObj[0]
        
        trackingDataObj.vehicle =  selectedVehicle
        
        selectedVehicle.currentOdemeter = trackingDataObj.initialOdemeter
        
        trackingDataObj.save()
        
        performSegueWithIdentifier("allData", sender: self)
    }
    
     @IBAction func dateUpdate(sender: AnyObject) {
        
        datePickerView = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.Date
        
        dateTextField.inputView = datePickerView
        
        dateTextField.becomeFirstResponder()
        
        datePickerView.addTarget(self, action: #selector(AddFuelViewController.datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)

     }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
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
 
            }
 */
   


}
