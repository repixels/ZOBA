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
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


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
        modelToolBar.barStyle = UIBarStyle.default
        modelToolBar.isTranslucent = true
        modelToolBar.tintColor = UIColor.red
        modelToolBar.sizeToFit()
        
        let modelDoneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(AddVehicleTableViewController.modelDonePicker))
        //        let modelSpaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        //        let modelCancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(AddVehicleTableViewController.modelCancelPicker))
        //        
        modelToolBar.setItems([modelDoneButton], animated: false)
        modelToolBar.isUserInteractionEnabled = true
        
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.red //UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(AddVehicleTableViewController.donePicker))
        //        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        //        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(AddVehicleTableViewController.cancelPicker))
        //        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        self.populateMakes()
        
        
        makeTextField.inputView = makePicker
        modelTextField.inputView = modelYearTrimPicker
        yearTextField.inputView = modelYearTrimPicker
        trimTextField.inputView = modelYearTrimPicker
        
        makeTextField.inputAccessoryView = toolBar
        modelTextField.inputAccessoryView = modelToolBar
        yearTextField.inputAccessoryView = modelToolBar
        trimTextField.inputAccessoryView = modelToolBar
        
        
        saveBtn.isEnabled = false
        saveBtn.tintColor = UIColor.gray
        
    }
    
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
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
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
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
    
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        
        var title = ""
        
        switch pickerView {
        case makePicker:
            title = makes![row].name!
        case modelYearTrimPicker:
            
            switch component {
            case 0:
                title = models![row].name!
            case 1:
                title = String(describing: years![row].name!)
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        //should set trip vehicle value here
        
        
        switch pickerView {
        case makePicker:
            selectedMake = makes![row]
            makeTextField.text = selectedMake.name
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
        
        
        let make = makePicker.selectedRow(inComponent: 0)
        selectedMake = makes![make]
        self.populateModels(selectedMake)
        
        makeTextField.text = selectedMake.name
        makeTextField.resignFirstResponder()
    }
    
    
    func cancelPicker(){
        makeTextField.resignFirstResponder()
    }
    
    @IBAction func modelYearTrimBeginEditing(_ sender: AnyObject) {
        
        let mod = modelYearTrimPicker.selectedRow(inComponent: 0)
        if models!.count > mod {
            selectedModel = models![mod]
        }
        let y = modelYearTrimPicker.selectedRow(inComponent: 1)
        if years!.count > y {
            selectedYear = years![y]
        }
        
        let t = modelYearTrimPicker.selectedRow(inComponent: 2)
        if trims!.count > t{
            selectedTrim = trims![t]
        }
        
    }
    
    func modelDonePicker(){
        let mod = modelYearTrimPicker.selectedRow(inComponent: 0)
        selectedModel = models![mod]
        let y = modelYearTrimPicker.selectedRow(inComponent: 1)
        selectedYear = years![y]
        let t = modelYearTrimPicker.selectedRow(inComponent: 2)
        selectedTrim = trims![t]
        
        modelTextField.text = selectedModel.name!
        yearTextField.text = String(describing: selectedYear.name!)
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
    
    
    
    
    @IBAction func nameIsChanging(_ sender: UITextField) {
        
        if sender.text!.isNotEmpty && DataValidations.hasNoWhiteSpaces(str: sender.text!)
        {
            isNameValid = true
            validateSaveBtn()
        }
        else{
            isNameValid = false
            validateSaveBtn()
        }
        
    }
    
    @IBAction func  intialOdemeterIsChanging(_ sender: UITextField) {
        
        if sender.text!.isNotEmpty && DataValidations.hasNoWhiteSpaces(str: sender.text!)
        {
            isInitialOdemeterValid = true
            validateSaveBtn()
        }
        else{
            isInitialOdemeterValid = false
            validateSaveBtn()
        }
    }
    
    @IBAction func licensPlateIsChanging(_ sender: UITextField) {
        
        if sender.text!.isNotEmpty && DataValidations.hasNoWhiteSpaces(str: sender.text!)
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
            
            saveBtn.isEnabled = true
            saveBtn.tintColor = UIColor.white
        }
        else{
            
            saveBtn.isEnabled = false
            saveBtn.tintColor = UIColor.gray
            
        }
        
    }
    
    @IBAction func saveVehiclePresses(_ sender: UIBarButtonItem) {
        

        
        let vehicle = Vehicle(managedObjectContext: SessionObjects.currentManageContext, entityName: "Vehicle")
        
        vehicle.name = vehicleNameTextField.text
        vehicle.initialOdemeter = Int(initialOdemeterTextField.text!) as NSNumber?
        vehicle.currentOdemeter = Int (initialOdemeterTextField.text!)  as NSNumber?
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
            self.navigationController?.popViewController(animated: true)
            SessionObjects.motionMonitor = LocationMonitor()
            SessionObjects.motionMonitor.startDetection()
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func saveVehicleToWebService(_ vehicle : Vehicle)
    {
        
        self.makes?.forEach({ (m) in
            if m != self.selectedMake
            {
                SessionObjects.currentManageContext.delete(m)
                
            }
        })
        
        
        self.trims?.forEach({ (t) in
            if t != self.selectedTrim
            {
                SessionObjects.currentManageContext.delete(t)
                
            }
        })
        
        
        self.models?.forEach({ (m) in
            if m != self.selectedModel
            {
                SessionObjects.currentManageContext.delete(m)
                
            }
        })
        
        
        self.years?.forEach({ (y) in
            if y != self.selectedYear
            {
                SessionObjects.currentManageContext.delete(y)
                
            }
        })
        
        
        
        vehicleWebService.saveVehicle(vehicle: vehicle) { (returnedVehicle, code) in
            switch code {
            case "success":
                vehicle.vehicleId = returnedVehicle?.vehicleId
                SessionObjects.currentManageContext.delete(returnedVehicle!)
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
        vehicleWebService.getMakes(result: { (makes, code) in
            
            switch code
            {
            case "success":
                if(makes?.isEmpty)!
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
    
    func populateModels(_ make : Make)
    {
        vehicleWebService.getModels(makeName: make.name!) { (models, code) in
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
    
    func populateTrims(_ model : Model , year: Year)
    {
        vehicleWebService.getTrims(modelName: model.name!, year: year.name!.stringValue) { (trims, code) in
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
    
    func populateYears(_ model : Model )
    {
        vehicleWebService.getYears(modelName: model.name!) { (years, code) in
            switch code
            {
            case "success":
                self.years = years
                if self.years!.count > 0 {
                    if self.selectedYear == nil  {
                        self.selectedYear = self.years![0]
                    }
                    self.yearTextField.text = String(describing: self.years![0].name!)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
}
