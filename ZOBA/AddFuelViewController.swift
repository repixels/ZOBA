//
//  AddFuelViewController.swift
//  ZOBA
//
//  Created by RE Pixels on 6/5/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import UIKit
import TextFieldEffects

class AddFuelViewController: UIViewController , UIPickerViewDelegate , UIPickerViewDataSource {
    
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
    
    var formatter = DateFormatter()
    
    var serviceProviders : [ServiceProvider]!
    
    var datePickerView : UIDatePicker!
    
    var date : String!
    
    var selectedServiceProvider : ServiceProvider?
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        disableBtn()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add Fuel"
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.white,
             NSFontAttributeName: UIFont(name: "Continuum Medium", size: 22)!]
        // Do any additional setup after loading the view.
        
        formatter.dateFormat = "MMM dd,yyyy"
        
        serviceProviderPickerView = UIPickerView()
        
        serviceProviderPickerView.delegate = self
        
        vehiclePickerView.delegate = self
        
        let datePickerToolbar = UIToolbar()
        datePickerToolbar.barStyle = UIBarStyle.default
        datePickerToolbar.isTranslucent = true
        datePickerToolbar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        datePickerToolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(AddFuelViewController.dateToolbarDoneClicked))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(AddFuelViewController.dateToolbarCancelClicked))
        
        datePickerToolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        datePickerToolbar.isUserInteractionEnabled = true
        
        
        let serviceProviderPickerToolbar = UIToolbar()
        serviceProviderPickerToolbar.barStyle = UIBarStyle.default
        serviceProviderPickerToolbar.isTranslucent = true
        serviceProviderPickerToolbar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        serviceProviderPickerToolbar.sizeToFit()
        
        let serviceProviderdoneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(AddFuelViewController.serviceProviderToolbarDoneClicked))
        let serviceProviderspaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let serviceProviderCancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(AddFuelViewController.serviceProviderToolbarCancelClicked))
        
        serviceProviderPickerToolbar.setItems([serviceProviderCancelButton, serviceProviderspaceButton, serviceProviderdoneButton], animated: false)
        serviceProviderPickerToolbar.isUserInteractionEnabled = true
        
        
        
        serviceProviderTextFeild.inputAccessoryView = serviceProviderPickerToolbar
        
        dateTextField.inputAccessoryView = datePickerToolbar
        
        
        let selectedVehicleIndex = self.getCurrentVehicleIndex()
        if selectedVehicleIndex >= 0 {
            vehiclePickerView.selectRow(selectedVehicleIndex, inComponent: 0, animated: false)
        }
        selectedVehicle = vehicles[vehiclePickerView.selectedRow(inComponent: 0)]
        
        let abstractDAO = AbstractDao(managedObjectContext: SessionObjects.currentManageContext)
        let serviceProviderDAO = abstractDAO.selectAll(entityName: "ServiceProvider") as! [ServiceProvider]
        serviceProviders = serviceProviderDAO
        
        if serviceProviders != nil && serviceProviders.count > 0
        {
            selectedServiceProvider = serviceProviders[serviceProviderPickerView.selectedRow(inComponent: 0)]
        }
        else
        {
            selectedServiceProvider = nil
            isServiceProviderReady = true
            serviceProviderTextFeild.isHidden = true
            serviceProviderTextFeild.isHidden = false
            serviceProviderButton.isHidden = false
            serviceProviderButton.isHidden = true
        }
        
        
        
        initialOdemeter.text = selectedVehicle.currentOdemeter!.stringValue
        currentOdometerTextField.text = selectedVehicle.currentOdemeter!.stringValue
        
        
        //register keyboard notification
        let notCenter = NotificationCenter.default
        notCenter.addObserver(self, selector: #selector (keyboardWillHide), name: 	NSNotification.Name.UIKeyboardWillHide, object: nil)
        notCenter.addObserver(self, selector: #selector (keyBoardWillAppear), name: 	NSNotification.Name.UIKeyboardWillShow, object: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func fuelAmountEditingDidEnd(_ sender: AnyObject) {
        
        
        if (fuelAmountTextField.text?.isNotEmpty ==  true && DataValidations.hasNoWhiteSpaces(str: fuelAmountTextField.text!))
        {
            isFuelMountReady = true
        }
        else
        {
            isFuelMountReady = false
            
        }
    }
    
    @IBAction func fuelAmountEditingChang(_ sender: AnyObject)
    {
        
        if(fuelAmountTextField.text!.isNotEmpty && DataValidations.hasNoWhiteSpaces(str: fuelAmountTextField!.text!) && Int(fuelAmountTextField.text!)! > 0)
        {
            
            if (Int(fuelAmountTextField.text!)! < 90)
            {
                
                showValidMessage(message: "Fuel Amount (L)" , textField: fuelAmountTextField)
                isFuelMountReady = true
            }
            else
            {
                showErrorMessage(message: "Amount Not Valid!"  , textField: fuelAmountTextField)
                isFuelMountReady = false
            }
        }
        else
        {
            showErrorMessage(message: "Amount Not Valid!"  , textField: fuelAmountTextField)
            isFuelMountReady = false
        }
        validateSaveBtn()
    }
    
    @IBAction func currentOdemterEditingDidEnd(_ sender: AnyObject)
    {
        if(currentOdometerTextField.text!.isNotEmpty && DataValidations.hasNoWhiteSpaces(str: currentOdometerTextField!.text!) && Int(currentOdometerTextField.text!)! > 0)
        {
            if (Int(currentOdometerTextField.text!)! >= selectedVehicle.currentOdemeter!.intValue)
            {
                showValidMessage(message: "Current Odemeter",textField: currentOdometerTextField)
                isCurrentOdeReady = true
            }
            else
            {
                showErrorMessage(message: "Enter valid Odemeter" ,textField: currentOdometerTextField)
                isCurrentOdeReady = false
            }
        }
        else
        {
            showErrorMessage(message: "Not Valid" ,textField: currentOdometerTextField)
            isCurrentOdeReady = false
        }
        validateSaveBtn()
    }
    
    @IBAction func currentOdemeterEditingChang(_ sender: AnyObject) {
        
        if(currentOdometerTextField.text!.isNotEmpty && DataValidations.hasNoWhiteSpaces(str: currentOdometerTextField!.text!) && Int(currentOdometerTextField.text!)! > 0)
        {
            if (Int(currentOdometerTextField.text!)! >= selectedVehicle.currentOdemeter!.intValue )
            {
                showValidMessage(message: "Current Odemeter",textField: currentOdometerTextField)
                isCurrentOdeReady = true
            }
            else
            {
                showErrorMessage(message: "Enter valid Odemeter" ,textField: currentOdometerTextField)
                isCurrentOdeReady = false
            }
        }
        else
        {
            showErrorMessage(message: "Not Valid" ,textField: currentOdometerTextField)
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
        textField.borderInactiveColor = UIColor.red
        textField.borderActiveColor = UIColor.red
        textField.placeholderColor = UIColor.red
        textField.placeholderLabel.text = message
        textField.placeholderLabel.sizeToFit()
        textField.placeholderLabel.alpha = 1.0
    }
    
    func showValidMessage(message:String , textField : HoshiTextField)
    {
        textField.borderInactiveColor = UIColor.green
        textField.borderActiveColor = UIColor.green
        textField.placeholderColor = UIColor.white
        textField.placeholderLabel.text = message
        enablBtn()
    }
    
    func disableBtn()  {
        
        saveBtn.isEnabled = false
        saveBtn.tintColor = UIColor.gray
    }
    
    func enablBtn()  {
        saveBtn.isEnabled = true
        saveBtn.tintColor = UIColor.white
    }
    
    
     func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == vehiclePickerView {
            
            return vehicles[row].name
        }
        else
        {
            return serviceProviders[row].name
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
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
    

    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
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
        
        formatter.dateStyle = DateFormatter.Style.medium
        
        formatter.timeStyle = DateFormatter.Style.none
        
        date = formatter.string(from: datePickerView.date)
        
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
    
    
    
    
    @IBAction func dateUpdate(_ sender: AnyObject) {
        
        datePickerView = UIDatePicker()
        datePickerView.maximumDate =
            Date()
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        dateTextField.inputView = datePickerView
        
        dateTextField.becomeFirstResponder()
        
        datePickerView.addTarget(self, action: #selector(AddFuelViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
        
    }
    
    
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        formatter.dateStyle = DateFormatter.Style.medium
        
        formatter.timeStyle = DateFormatter.Style.none
        
        date = formatter.string(from: sender.date)
        
        dateTextField.text = date
        
    }
    
    @IBAction func servicePROVIDER(_ sender: AnyObject) {
        
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
    
    
    @IBAction func saveFuel(_ sender: AnyObject) {
        
        let trackingDataObj = TrackingData(managedObjectContext: SessionObjects.currentManageContext , entityName: "TrackingData")
        
        trackingDataObj.initialOdemeter = NSNumber(value : Int(currentOdometerTextField.text!)!)
        
        trackingDataObj.value = fuelAmountTextField.text!
        
        trackingDataObj.dateAdded = datePickerView.date as NSDate?
        
        let dao = AbstractDao(managedObjectContext: SessionObjects.currentManageContext)
        
        let trackingType = dao.selectByString(entityName: "TrackingType", AttributeName: "name", value: StringConstants.fuelTrackingType) as![TrackingType]
        
        if trackingType.count > 0
        {
            trackingDataObj.trackingType = trackingType[0]
        }
        
        trackingDataObj.vehicle =  selectedVehicle
        trackingDataObj.vehicle?.currentOdemeter = Int(currentOdometerTextField!.text!) as NSNumber?
        trackingDataObj.serviceProviderName = selectedServiceProvider != nil && selectedServiceProvider!.name != nil  ? serviceProviderTextFeild.text! : "Not Available"
        
        // trackingDataObj.save()
        self.saveFuelToWebService(fuel: trackingDataObj)
        self.navigationController?.popViewController(animated: true)
    }
    
    func saveFuelToWebService(fuel : TrackingData){
        
        let trackingWebService = TrackingDataWebService()
        
        trackingWebService.saveTrackingData(fuel, result: { (trackingData, code) in
            
            switch code {
            case "success":
                
                print("success in saving data")
                print(trackingData?.trackingId)
                fuel.trackingId = trackingData?.trackingId
                SessionObjects.currentManageContext.delete(trackingData!)
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
            if let keyboardSize: CGSize =    (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size {
                let contentInset = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height,  0.0);
                
                self.scrollView.contentInset = contentInset
                self.scrollView.scrollIndicatorInsets = contentInset
                
                self.scrollView.contentOffset = CGPoint(x:self.scrollView.contentOffset.x,y: 0 + (keyboardSize.height/2)) //set zero instead
                
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let _: CGSize =  (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size {
                let contentInset = UIEdgeInsets.zero;
                
                self.scrollView.contentInset = contentInset
                self.scrollView.scrollIndicatorInsets = contentInset
                self.scrollView.contentOffset = CGPoint(x:self.scrollView.contentOffset.x,y: self.scrollView.contentOffset.y)
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    
}
