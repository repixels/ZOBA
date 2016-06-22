//
//  AddVehicleTableViewController.swift
//  ZOBA
//
//  Created by Angel mas on 6/12/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import UIKit
import TextFieldEffects
import Alamofire
import ObjectMapper
import SwiftyUserDefaults
import CoreData

class AddVehicleTableViewController: UITableViewController,UIPickerViewDataSource , UIPickerViewDelegate {
    
    
    
    var makePicker : UIPickerView! = UIPickerView()
    var modelYearTrimPicker : UIPickerView! = UIPickerView()
    
    
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    
    var makes : [Make]?
    var models : [Model]?
    var trims : [Trim]?
    var years : [Year]?
    
    @IBOutlet weak var licensePlateTextField: HoshiTextField!
    @IBOutlet weak var makeTextField: HoshiTextField!
    @IBOutlet weak var modelTextField: HoshiTextField!
    @IBOutlet weak var yearTextField: HoshiTextField!
    @IBOutlet weak var trimTextField: HoshiTextField!
    
    
    var isNameValid = false
    var isInitialOdemeterValid = false
    var isLicenseValid = false
    
    
    @IBOutlet weak var vehicleNameTextField: HoshiTextField!
    
    @IBOutlet weak var initialOdemeterTextField: HoshiTextField!
    
    
    var selectedMake : Make!
    var selectedModel : Model!
    var selectedYear : Year!
    var selectedTrim : Trim!
    
    let vehicleWebService = VehicleWebServices()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Intialize Arrays
        makes = [Make]()
        models = [Model]()
        years = [Year]()
        trims = [Trim]()
        
        makePicker.delegate = self
        modelYearTrimPicker.delegate = self
        
        let modelToolBar = UIToolbar()
        modelToolBar.barStyle = UIBarStyle.Default
        modelToolBar.translucent = true
        modelToolBar.tintColor = UIColor.redColor()
        modelToolBar.sizeToFit()
        
        let modelDoneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(AddVehicleTableViewController.modelDonePicker))
        let modelSpaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let modelCancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(AddVehicleTableViewController.modelCancelPicker))
        
        modelToolBar.setItems([modelCancelButton, modelSpaceButton, modelDoneButton], animated: false)
        modelToolBar.userInteractionEnabled = true
        
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor.redColor() //UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(AddVehicleTableViewController.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(AddVehicleTableViewController.cancelPicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        
        self.populateMakes()
        
        
        makeTextField.inputView = makePicker
        modelTextField.inputView = modelYearTrimPicker
        yearTextField.inputView = modelYearTrimPicker
        trimTextField.inputView = modelYearTrimPicker
        
        makeTextField.inputAccessoryView = toolBar
        modelTextField.inputAccessoryView = modelToolBar
        yearTextField.inputAccessoryView = modelToolBar
        trimTextField.inputAccessoryView = modelToolBar
        
        
        saveBtn.enabled = false
        saveBtn.tintColor = UIColor.grayColor()
        
    }
    
    
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        var count = 1
        switch pickerView {
        case modelYearTrimPicker:
            count = 3
            break
        case makePicker:
            count = 1
            break
        default:
            count = 1
        }
        
        return count
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var count = 0
        switch pickerView {
        case makePicker:
            count = makes!.count
        case modelYearTrimPicker:
            
            switch component {
            case 0:
                count = models!.count
            case 1:
                count = years!.count
            case 2:
                count = trims!.count
            default:
                count = 0
            }
            
        default:
            count = 0
        }
        
        
        return count;
    }
    
    
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        
        var title = ""
        
        switch pickerView {
        case makePicker:
            title = makes![row].name!
        case modelYearTrimPicker:
            
            switch component {
            case 0:
                title = models![row].name!
            case 1:
                title = String(years![row].name!)
            case 2:
                title = trims![row].name!
                
            default:
                title = ""
            }
            
        default:
            title = ""
        }
        //
        
        return title
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        //should set trip vehicle value here
        
        
        switch pickerView {
        case makePicker:
            selectedMake = makes![row]
            modelTextField.text?.removeAll()
            trimTextField.text?.removeAll()
            yearTextField.text?.removeAll()
            self.populateModels(selectedMake)
            modelYearTrimPicker.reloadAllComponents()
            
        case modelYearTrimPicker:

            switch component {
            case 0:
                
                selectedModel = models![row]
                self.populateYears(selectedModel)
                modelYearTrimPicker.reloadAllComponents()
            case 1:
                selectedYear = years![row]
                self.populateTrims(selectedModel, year: selectedYear)
                modelYearTrimPicker.reloadAllComponents()
            case 2:
                selectedTrim = trims![row]
                modelYearTrimPicker.reloadAllComponents()
            default:
                break
            }
            
        default:
            break;
        }
        
        
        
        pickerView.resignFirstResponder()
        
    }
    
    func donePicker(){
        
        
        let make = makePicker.selectedRowInComponent(0)
        selectedMake = makes![make]
        self.populateModels(selectedMake)
        
        makeTextField.text = selectedMake.name
        makeTextField.resignFirstResponder()
    }
    
    
    func cancelPicker(){
        makeTextField.resignFirstResponder()
    }
    
    @IBAction func modelYearTrimBeginEditing(sender: AnyObject) {
        
        let mod = modelYearTrimPicker.selectedRowInComponent(0)
        if models!.count > mod {
        selectedModel = models![mod]
        }
        let y = modelYearTrimPicker.selectedRowInComponent(1)
        if years!.count > y {
        selectedYear = years![y]
        }
        
        let t = modelYearTrimPicker.selectedRowInComponent(2)
        if trims!.count > t{
        selectedTrim = trims![t]
        }
        
    }
    
    func modelDonePicker(){
        let mod = modelYearTrimPicker.selectedRowInComponent(0)
        selectedModel = models![mod]
        let y = modelYearTrimPicker.selectedRowInComponent(1)
        selectedYear = years![y]
        let t = modelYearTrimPicker.selectedRowInComponent(2)
        selectedTrim = trims![t]
        
        modelTextField.text = selectedModel.name!
        yearTextField.text = String(selectedYear.name!)
        trimTextField.text = selectedTrim.name!
        
        modelTextField.resignFirstResponder()
        yearTextField.resignFirstResponder()
        trimTextField.resignFirstResponder()
        
    }
    
    
    func modelCancelPicker(){
        modelTextField.resignFirstResponder()
        yearTextField.resignFirstResponder()
        trimTextField.resignFirstResponder()
        
    }
    
    
    
    
    @IBAction func nameIsChanging(sender: UITextField) {
        
        if sender.text!.isNotEmpty && DataValidations.hasNoWhiteSpaces(sender.text!)
        {
            isNameValid = true
            validateSaveBtn()
        }
        else{
            isNameValid = false
            validateSaveBtn()
        }
        
    }
    
    @IBAction func  intialOdemeterIsChanging(sender: UITextField) {
        
        if sender.text!.isNotEmpty && DataValidations.hasNoWhiteSpaces(sender.text!)
        {
            isInitialOdemeterValid = true
            validateSaveBtn()
        }
        else{
            isInitialOdemeterValid = false
            validateSaveBtn()
        }
    }
    
    @IBAction func licensPlateIsChanging(sender: UITextField) {
        
        if sender.text!.isNotEmpty && DataValidations.hasNoWhiteSpaces(sender.text!)
        {
            isLicenseValid = true
            validateSaveBtn()
        }
        else{
            isLicenseValid = false
            validateSaveBtn()
        }
    }
    
    func validateSaveBtn()
    {
        let isMakeValid = makeTextField.text!.isNotEmpty
        let isModelValid = modelTextField.text!.isNotEmpty && yearTextField.text!.isNotEmpty && trimTextField.text!.isNotEmpty
        
        if isMakeValid && isModelValid && isNameValid && isLicenseValid && isInitialOdemeterValid {
            
            saveBtn.enabled = true
            saveBtn.tintColor = UIColor.whiteColor()
        }
        else{
            
            saveBtn.enabled = false
            saveBtn.tintColor = UIColor.grayColor()
            
        }
        
    }
    
    @IBAction func saveVehiclePresses(sender: UIBarButtonItem) {
        
        
        
        let vehicle = Vehicle(managedObjectContext: SessionObjects.currentManageContext, entityName: "Vehicle")
        
        vehicle.name = vehicleNameTextField.text
        vehicle.initialOdemeter = Int (initialOdemeterTextField.text!)!
        vehicle.currentOdemeter = Int (initialOdemeterTextField.text!)!
        vehicle.licensePlate = licensePlateTextField.text
        
        let vehicleModel = VehicleModel(managedObjectContext: SessionObjects.currentManageContext, entityName: "VehicleModel")
        selectedModel.make = selectedMake
        vehicleModel.model = selectedModel
        vehicleModel.trim = selectedTrim
        vehicleModel.year = selectedYear

        vehicle.vehicleModel = vehicleModel
        vehicle.user = SessionObjects.currentUser
        vehicle.isAdmin = 1
        saveVehicleToWebService(vehicle)
        
        if Defaults[.curentVehicleName] == nil
        {
            Defaults[.curentVehicleName] = vehicle.name
            SessionObjects.currentVehicle = vehicle
            self.navigationController?.popViewControllerAnimated(true)
            SessionObjects.motionMonitor = LocationMonitor()
            SessionObjects.motionMonitor.startDetection()
        }
        else{
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func saveVehicleToWebService(vehicle : Vehicle)
    {
        
        self.makes?.forEach({ (m) in
            if m != self.selectedMake
            {
                SessionObjects.currentManageContext.deleteObject(m)
            
            }
        })
        
        
        self.trims?.forEach({ (t) in
            if t != self.selectedTrim
            {
                SessionObjects.currentManageContext.deleteObject(t)
                
            }
        })
        
        
        self.models?.forEach({ (m) in
            if m != self.selectedModel
            {
                SessionObjects.currentManageContext.deleteObject(m)
                
            }
        })
        
        
        self.years?.forEach({ (y) in
            if y != self.selectedYear
            {
                SessionObjects.currentManageContext.deleteObject(y)
                
            }
        })
        
        
        
        vehicleWebService.saveVehicle(vehicle) { (returnedVehicle, code) in
            switch code {
            case "success":
                vehicle.vehicleId = returnedVehicle.vehicleId
                SessionObjects.currentManageContext.deleteObject(returnedVehicle)
                vehicle.save()
                break
            case "error" :
                vehicle.save()
                break
            default:
                break
                
            }
            
           
        }
    }
    func populateMakes()
    {
        // get all makes then all models for first make then all years for first model
        //then all trims for first model and first year
        vehicleWebService.getMakes({ (makes, code) in
            
            switch code
            {
            case "success":
                if(makes.isEmpty)
                {
                    
                }
                else
                {
                    self.makes = makes
                    self.makePicker.reloadAllComponents()
                    
                    if self.makes?.count > 0 {
                        if self.selectedMake == nil  {
                            self.selectedMake = self.makes![0]
                        }
                        
                        self.makeTextField.text = self.makes![0].name
                        self.populateModels(self.makes![0])
                        
                    }
                }
                break;
            case "error":
                break;
            default:
                break;
            }
            
        })
        
    }
    
    func populateModels(make : Make)
    {
        vehicleWebService.getModels(make.name!) { (models, code) in
            switch code
            {
            case "success":
                self.models = models
                if self.models!.count > 0 {
                    if self.selectedModel == nil  {
                        self.selectedModel = self.models![0]
                    }
                    self.modelTextField.text = self.models![0].name
                    self.populateYears(self.models![0])
                }
                break;
            case "error":
                break;
            default:
                break;
            }
        }
    }
    
    func populateTrims(model : Model , year: Year)
    {
        vehicleWebService.getTrims(model.name!, year: year.name!.stringValue) { (trims, code) in
            switch code
            {
            case "success":
                self.trims = trims
                self.modelYearTrimPicker.reloadAllComponents()
                if self.trims!.count > 0 {
                    
                    if self.selectedTrim == nil  {
                        self.selectedTrim = self.trims![0]
                    }
                self.trimTextField.text = self.trims![0].name
                }
                break
            case "failure":
                break
            default:
                break
            }
        }
    }
    
    func populateYears(model : Model )
    {
        vehicleWebService.getYears(model.name!) { (years, code) in
            switch code
            {
            case "success":
                self.years = years
                if self.years!.count > 0 {
                    if self.selectedYear == nil  {
                        self.selectedYear = self.years![0]
                    }
                    self.yearTextField.text = String(self.years![0].name!)
                    self.populateTrims(model, year: self.years!.first! )
                }
                
                break;
            case "failure":
                break;
            default:
                break;
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
}
