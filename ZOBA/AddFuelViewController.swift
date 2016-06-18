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

    var serviceProviderPickerView : UIPickerView!

    var selectedVehicle : Vehicle!

    var vehicles = SessionObjects.currentUser.vehicle?.allObjects as! [Vehicle]

    var isCurrentOdeReady = true

    var isFuelMountReady = false

    var formatter = NSDateFormatter()

    var serviceProviders : [ServiceProvider]!

    var datePickerView : UIDatePicker!

    var date : String!
    
    var selectedServiceProvider : ServiceProvider?
    

    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(true)
        disableBtn()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add Fuel"
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.whiteColor(),
             NSFontAttributeName: UIFont(name: "Continuum Medium", size: 22)!]

        // Do any additional setup after loading the view.
        
        formatter.dateFormat = "MMM dd,yyyy"
        
        serviceProviderPickerView = UIPickerView()
        
        serviceProviderPickerView.delegate = self
        
        vehiclePickerView.delegate = self
        
        let datePickerToolbar = UIToolbar()
        datePickerToolbar.barStyle = UIBarStyle.Default
        datePickerToolbar.translucent = true
        datePickerToolbar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        datePickerToolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(AddFuelViewController.dateToolbarDoneClicked))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(AddFuelViewController.dateToolbarCancelClicked))
        
        datePickerToolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        datePickerToolbar.userInteractionEnabled = true
        
        
        let serviceProviderPickerToolbar = UIToolbar()
        serviceProviderPickerToolbar.barStyle = UIBarStyle.Default
        serviceProviderPickerToolbar.translucent = true
        serviceProviderPickerToolbar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        serviceProviderPickerToolbar.sizeToFit()
        
        let serviceProviderdoneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(AddFuelViewController.serviceProviderToolbarDoneClicked))
        let serviceProviderspaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let serviceProviderCancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(AddFuelViewController.serviceProviderToolbarCancelClicked))
        
        serviceProviderPickerToolbar.setItems([serviceProviderCancelButton, serviceProviderspaceButton, serviceProviderdoneButton], animated: false)
        serviceProviderPickerToolbar.userInteractionEnabled = true
        
        
        serviceProviderTextFeild.inputAccessoryView = serviceProviderPickerToolbar
        
        dateTextField.inputAccessoryView = datePickerToolbar
        
        selectedVehicle = vehicles[vehiclePickerView.selectedRowInComponent(0)]
        selectedServiceProvider = serviceProviders[serviceProviderPickerView.selectedRowInComponent(0)]
        
        initialOdemeter.text = selectedVehicle.currentOdemeter!.stringValue
        
        currentOdometerTextField.text = selectedVehicle.currentOdemeter!.stringValue
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
    
    @IBAction func fuelAmountEditingChang(sender: AnyObject)
    {
        
        if(fuelAmountTextField.text!.isNotEmpty && DataValidations.hasNoWhiteSpaces(fuelAmountTextField!.text!) && Int(fuelAmountTextField.text!)! > 0)
        {
        
            if (Int(fuelAmountTextField.text!)! < 90)
            {
                
                showValidMessage("Fuel Amount (L)" , textField: fuelAmountTextField)
                isFuelMountReady = true
            }
            else
            {
                showErrorMessage("Amount Not Valid!"  , textField: fuelAmountTextField)
                isFuelMountReady = false
            }
        }
        else
        {
            showErrorMessage("Amount Not Valid!"  , textField: fuelAmountTextField)
            isFuelMountReady = false
        }
        validateSaveBtn()
    }
    
    @IBAction func currentOdemterEditingDidEnd(sender: AnyObject)
    {
        if(currentOdometerTextField.text!.isNotEmpty && DataValidations.hasNoWhiteSpaces(currentOdometerTextField!.text!) && Int(currentOdometerTextField.text!)! > 0)
        {
            if (Int(currentOdometerTextField.text!)! >= selectedVehicle.currentOdemeter!.integerValue )
            {
                showValidMessage("Current Odemeter",textField: currentOdometerTextField)
                isCurrentOdeReady = true
            }
            else
            {
                showErrorMessage("Enter valid Odemeter" ,textField: currentOdometerTextField)
                isCurrentOdeReady = false
            }
        }
        else
        {
            showErrorMessage("Not Valid" ,textField: currentOdometerTextField)
            isCurrentOdeReady = false
        }
        validateSaveBtn()
    }
    
    @IBAction func currentOdemeterEditingChang(sender: AnyObject) {
        
        if(currentOdometerTextField.text!.isNotEmpty && DataValidations.hasNoWhiteSpaces(currentOdometerTextField!.text!) && Int(currentOdometerTextField.text!)! > 0)
        {
            if (Int(currentOdometerTextField.text!)! >= selectedVehicle.currentOdemeter!.integerValue )
            {
                showValidMessage("Current Odemeter",textField: currentOdometerTextField)
                isCurrentOdeReady = true
            }
            else
            {
                showErrorMessage("Enter valid Odemeter" ,textField: currentOdometerTextField)
                isCurrentOdeReady = false
            }
        }
        else
        {
            showErrorMessage("Not Valid" ,textField: currentOdometerTextField)
            isCurrentOdeReady = false
        }
        validateSaveBtn()
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
            return serviceProviders[row].name
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == vehiclePickerView
        {
            selectedVehicle = vehicles[row]
            initialOdemeter.text = selectedVehicle.currentOdemeter!.stringValue
        }
        
        else
        {
            selectedServiceProvider = serviceProviders[row]
            serviceProviderTextFeild.text = serviceProviders[row].name
        }
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == vehiclePickerView
        {
            return vehicles.count
        }
        else
        {
            let abstractDAO = AbstractDao(managedObjectContext: SessionObjects.currentManageContext)
            let serviceProviderDAO = abstractDAO.selectAll(entityName: "ServiceProvider") as! [ServiceProvider]
            serviceProviders = serviceProviderDAO
            return serviceProviders.count
        }
    }
    
    func dateToolbarDoneClicked() {
        
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        
        formatter.timeStyle = NSDateFormatterStyle.NoStyle
        
        date = formatter.stringFromDate(datePickerView.date)
        
        dateTextField.text = date
        
        view.endEditing(true)
    }
    
    func dateToolbarCancelClicked()
    {
        dateTextField.resignFirstResponder()
    }
    
    func serviceProviderToolbarDoneClicked()
    {
        serviceProviderTextFeild.text = selectedServiceProvider!.name
        serviceProviderTextFeild.resignFirstResponder()
    }
    
    func serviceProviderToolbarCancelClicked()
    {
        
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
        
        serviceProviderTextFeild.inputView = serviceProviderPickerView
        
        serviceProviderTextFeild.becomeFirstResponder()
        
    }
    
    
    @IBAction func saveFuel(sender: AnyObject) {
        
        let trackingDataObj = TrackingData(managedObjectContext: SessionObjects.currentManageContext , entityName: "TrackingData")
        
        trackingDataObj.initialOdemeter = NSNumber(integer : Int(currentOdometerTextField.text!)!)
        
        trackingDataObj.value = fuelAmountTextField.text!
        
        trackingDataObj.dateAdded = datePickerView.date
        
        let dao = AbstractDao(managedObjectContext: SessionObjects.currentManageContext)
        
        let trackingType = dao.selectByString(entityName: "TrackingType", AttributeName: "name", value: "Vehicle Refuelling") as![TrackingType]
        
        trackingDataObj.trackingType = trackingType[0]
        
        trackingDataObj.vehicle =  selectedVehicle
        trackingDataObj.serviceProviderName = serviceProviderTextFeild.text
        
        trackingDataObj.save()
        
        performSegueWithIdentifier("allData", sender: self)
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
