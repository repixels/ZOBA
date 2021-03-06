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
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    
    @IBOutlet weak var vehiclePickerView: UIPickerView!
    
    @IBOutlet weak var initialOdemeter: HoshiTextField!
    
    @IBOutlet weak var dateTextField: HoshiTextField!
    
    @IBOutlet weak var fuelAmountTextField: HoshiTextField!
    
    @IBOutlet weak var currentOdometerTextField: HoshiTextField!
    
    @IBOutlet weak var serviceProviderTextFeild: HoshiTextField!
    
    @IBOutlet weak var serviceProviderButton: UIButton!
    var serviceProviderPickerView : UIPickerView!
    
    var selectedVehicle : Vehicle!
    
    var vehicles = SessionObjects.currentUser.vehicle?.allObjects as! [Vehicle]
    
    var isCurrentOdeReady = true
    
    var isFuelMountReady = false
    
    var isServiceProviderReady = false
    
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
        
        
        let selectedVehicleIndex = self.getCurrentVehicleIndex()
        if selectedVehicleIndex >= 0 {
            vehiclePickerView.selectRow(selectedVehicleIndex, inComponent: 0, animated: false)
        }
        selectedVehicle = vehicles[vehiclePickerView.selectedRowInComponent(0)]
        
        let abstractDAO = AbstractDao(managedObjectContext: SessionObjects.currentManageContext)
        let serviceProviderDAO = abstractDAO.selectAll(entityName: "ServiceProvider") as! [ServiceProvider]
        serviceProviders = serviceProviderDAO
        
        if serviceProviders != nil && serviceProviders.count > 0
        {
            selectedServiceProvider = serviceProviders[serviceProviderPickerView.selectedRowInComponent(0)]
        }
        else
        {
            selectedServiceProvider = nil
            isServiceProviderReady = true
            serviceProviderTextFeild.hidden = true
            serviceProviderTextFeild.enabled = false
            serviceProviderButton.enabled = false
            serviceProviderButton.hidden = true
        }
        
        
        
        initialOdemeter.text = selectedVehicle.currentOdemeter!.stringValue
        currentOdometerTextField.text = selectedVehicle.currentOdemeter!.stringValue
        
        
        //register keyboard notification
        let notCenter = NSNotificationCenter.defaultCenter()
        notCenter.addObserver(self, selector: #selector (keyboardWillHide), name: 	UIKeyboardWillHideNotification, object: nil)
        notCenter.addObserver(self, selector: #selector (keyBoardWillAppear), name: 	UIKeyboardWillShowNotification, object: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func fuelAmountEditingDidEnd(sender: AnyObject) {
        
        
        if (fuelAmountTextField.text?.isNotEmpty ==  true && DataValidations.hasNoWhiteSpaces(fuelAmountTextField.text!))
        {
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
        if (isFuelMountReady && isCurrentOdeReady && isServiceProviderReady && dateTextField.text?.isNotEmpty == true) {
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
        saveBtn.tintColor = UIColor.whiteColor()
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
            currentOdometerTextField.text = selectedVehicle.currentOdemeter!.stringValue
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
        
        validateSaveBtn()
        
        view.endEditing(true)
    }
    
    func dateToolbarCancelClicked()
    {
        validateSaveBtn()
        dateTextField.resignFirstResponder()
    }
    
    func serviceProviderToolbarDoneClicked()
    {
        serviceProviderTextFeild.text = selectedServiceProvider!.name
        isServiceProviderReady = true
        validateSaveBtn()
        serviceProviderTextFeild.resignFirstResponder()
    }
    
    func serviceProviderToolbarCancelClicked()
    {
        view.endEditing(true)
    }
    
    
    
    
    @IBAction func dateUpdate(sender: AnyObject) {
        
        datePickerView = UIDatePicker()
        datePickerView.maximumDate = NSDate()
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
    
    func getCurrentVehicleIndex() -> Int{
        
        var index = -1
        let vehicle = SessionObjects.currentVehicle
        for i in 0..<vehicles.count
        {
            if vehicles[i] == vehicle {
                index = i
            }
        }
        return index
    }
    
    
    @IBAction func saveFuel(sender: AnyObject) {
        
        let trackingDataObj = TrackingData(managedObjectContext: SessionObjects.currentManageContext , entityName: "TrackingData")
        
        trackingDataObj.initialOdemeter = NSNumber(integer : Int(currentOdometerTextField.text!)!)
        
        trackingDataObj.value = fuelAmountTextField.text!
        
        trackingDataObj.dateAdded = datePickerView.date
        
        let dao = AbstractDao(managedObjectContext: SessionObjects.currentManageContext)
        
        let trackingType = dao.selectByString(entityName: "TrackingType", AttributeName: "name", value: StringConstants.fuelTrackingType) as![TrackingType]
        
        if trackingType.count > 0
        {
            trackingDataObj.trackingType = trackingType[0]
        }
        
        trackingDataObj.vehicle =  selectedVehicle
        trackingDataObj.vehicle?.currentOdemeter = Int(currentOdometerTextField!.text!)
        trackingDataObj.serviceProviderName = selectedServiceProvider != nil && selectedServiceProvider!.name != nil  ? serviceProviderTextFeild.text! : "Not Available"
        
        // trackingDataObj.save()
        self.saveFuelToWebService(trackingDataObj)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func saveFuelToWebService(fuel : TrackingData){
        
        let trackingWebService = TrackingDataWebService()
        
        trackingWebService.saveTrackingData(fuel, result: { (trackingData, code) in
            
            switch code {
            case "success":
                
                print("success in saving data")
                print(trackingData.trackingId)
                fuel.trackingId = trackingData.trackingId
                SessionObjects.currentManageContext.deleteObject(trackingData)
                fuel.save()
                break
            case "error" :
                print("error in saving tracking")
                fuel.save()
                break
            default:
                break
                
            }
            
            
        })
    }
    
    
    
    //MARK: - keyboard
    func keyBoardWillAppear(notification : NSNotification){        
        if let userInfo = notification.userInfo {
            if let keyboardSize: CGSize =    userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue().size {
                let contentInset = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height,  0.0);
                
                self.scrollView.contentInset = contentInset
                self.scrollView.scrollIndicatorInsets = contentInset
                
                self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, 0 + (keyboardSize.height/2)) //set zero instead
                
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let _: CGSize =  userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue().size {
                let contentInset = UIEdgeInsetsZero;
                
                self.scrollView.contentInset = contentInset
                self.scrollView.scrollIndicatorInsets = contentInset
                self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, self.scrollView.contentOffset.y)
            }
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    
}
