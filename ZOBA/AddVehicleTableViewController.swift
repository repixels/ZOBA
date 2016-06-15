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


class AddVehicleTableViewController: UITableViewController,UIPickerViewDataSource , UIPickerViewDelegate {
    
    
    
    var makePicker : UIPickerView! = UIPickerView()
    var modelPicker : UIPickerView! = UIPickerView()
    
    
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    
    var makes : [Make]!
    var models : [Model]!
    var trims : [Trim]!
    var years : [Year]!
    
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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        makePicker.delegate = self
        modelPicker.delegate = self
        
        
        
        let modelToolBar = UIToolbar()
        modelToolBar.barStyle = UIBarStyle.Default
        modelToolBar.translucent = true
        modelToolBar.tintColor = UIColor.redColor() //UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
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
        
        
        //        makePicker.addSubview(toolBar)
        
        
        makeTextField.inputView = makePicker
        modelTextField.inputView = modelPicker
        yearTextField.inputView = modelPicker
        trimTextField.inputView = modelPicker
        
        makeTextField.inputAccessoryView = toolBar
        modelTextField.inputAccessoryView = modelToolBar
        yearTextField.inputAccessoryView = modelToolBar
        trimTextField.inputAccessoryView = modelToolBar
        
        
        let dao = AbstractDao(managedObjectContext: SessionObjects.currentManageContext)
        makes =   dao.selectAll(entityName: "Make") as!  [Make]
        trims =  dao.selectAll(entityName: "Trim") as!  [Trim]
        years =  dao.selectAll(entityName: "Year") as!  [Year]
        models =  dao.selectAll(entityName: "Model") as!  [Model]
        
        
        saveBtn.enabled = false
        saveBtn.tintColor = UIColor.grayColor()
        
    }
    
    
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        var count = 1
        switch pickerView {
        case modelPicker:
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
            count = makes.count
        case modelPicker:
            
            switch component {
            case 0:
                count = models.count
            case 1:
                count = years.count
            case 2:
                count = trims.count
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
            title = makes[row].name!
        case modelPicker:
            
            switch component {
            case 0:
                title = models[row].name!
            case 1:
                title = years[row].name!
            case 2:
                title = trims[row].name!
                
            default:
                title = ""
            }
            
        default:
            title = ""
        }
        
        
        return title
        
    }
    
    var selectedMake : Make!
    var selectedModel : Model!
    var selectedYear : Year!
    var selectedTrim : Trim!
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        //should set trip vehicle value here
        
        switch pickerView {
        case makePicker:
            print( makes[row].name!)
            selectedMake = makes[row]
            //            getAllModels(makes[row].name!)
            //            getAllYears(models[0].name!)
        //            getAllTrims(models[0].name!, year: Int(years[0].name!)!)
        case modelPicker:
            
            switch component {
            case 0:
                print( models[row].name!)
                selectedModel = models[row]
                //                getAllYears(models[row].name!)
            //                getAllTrims(models[row].name!, year: Int(years[0].name!)!)
            case 1:
                print( years[row].name!)
                selectedYear = years[row]
            //                                getAllTrims(selectedModel.name!, year: Int(years[row].name!)!)
            case 2:
                print( trims[row].name!)
                selectedTrim = trims[row]
            default:
                print("default")
            }
            
        default:
            print("default")
        }
        
        
        
        pickerView.resignFirstResponder()
        
    }
    
    
    
    //    let makeUrl = "http://10.118.48.143:8080/WebServiceProject/rest/vehicle/makes"
    //    let modelUrl = "http://10.118.48.143:8080/WebServiceProject/rest/vehicle/models?make=m1"
    //    let yearUrl = "http://10.118.48.143:8080/WebServiceProject/rest/vehicle/year?model=bte5a"
    //    let trimUrl = "http://10.118.48.143:8080/WebServiceProject/rest/vehicle/trim?model=bte5a&year=2014"
    //
    
    let makeUrl = "http://10.118.48.143:8080/WebServiceProject/rest/vehicle/makes"
    let modelUrl = "http://10.118.48.143:8080/WebServiceProject/rest/vehicle/models"
    let yearUrl = "http://10.118.48.143:8080/WebServiceProject/rest/vehicle/year"
    let trimUrl = "http://10.118.48.143:8080/WebServiceProject/rest/vehicle/trim"
    
    
    func getAllMakes(){
        Alamofire.request(.GET,makeUrl).responseJSON { (json) in
            print(json.result.value)
            print("===========================")
            self.makes = Mapper<Make>().mapArray(json.result.value)
            self.makes[0].save()
            self.makePicker.reloadAllComponents()
        }
        
    }
    
    
    func getAllModels(makeName : String){
        
        
        Alamofire.request(.GET,modelUrl,parameters: ["make":makeName]).responseJSON { (json) in
            print(json.result.value)
            print("===========================")
            self.models = Mapper<Model>().mapArray(json.result.value)
            self.models[0].save()
            self.modelPicker.reloadAllComponents()
        }
        
    }
    
    
    func getAllYears(modelName :String){
        Alamofire.request(.GET,yearUrl,parameters: ["model":modelName]).responseJSON { (json) in
            print(json.result.value)
            print("===========================")
            self.years = Mapper<Year>().mapArray(json.result.value)
            self.years[0].save()
            self.years.forEach({ (y) in
                print("name : \(y.yearId)")
                print("name : \(y.name)")
                
            })
            self.modelPicker.reloadAllComponents()
        }
        
    }
    
    
    func getAllTrims(modelName : String , year : Int){
        Alamofire.request(.GET,trimUrl,parameters: ["model":modelName,"year":year]).responseJSON { (json) in
            print(json.result.value)
            print("===========================")
            self.trims = Mapper<Trim>().mapArray(json.result.value)
            self.trims[0].save()
            self.modelPicker.reloadAllComponents()
        }
        
    }
    
    func donePicker(){
        
        let mak = makePicker.selectedRowInComponent(0)
        selectedMake = makes[mak]
        makeTextField.text = selectedMake.name
        makeTextField.resignFirstResponder()
    }
    
    
    func cancelPicker(){
        makeTextField.resignFirstResponder()
    }
    
    
    func modelDonePicker(){
        let mod = modelPicker.selectedRowInComponent(0)
        selectedModel = models[mod]
        let y = modelPicker.selectedRowInComponent(1)
        selectedYear = years[y]
        let t = modelPicker.selectedRowInComponent(2)
        selectedTrim = trims[t]
        
        modelTextField.text = selectedModel.name!
        yearTextField.text = selectedYear.name!
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
    
    @IBAction func saveVehiclePresses(sender: UIBarButtonItem) {
        
        let vehicleModel = VehicleModel(managedObjectContext: SessionObjects.currentManageContext ,entityName: "VehicleModel")
        selectedModel.make = selectedMake
        vehicleModel.model = selectedModel
        vehicleModel.year = selectedYear
        vehicleModel.trim = selectedTrim
        vehicleModel.save()
        
        let vehicle = Vehicle(managedObjectContext: SessionObjects.currentManageContext, entityName: "Vehicle")
        
        vehicle.name = vehicleNameTextField.text
        vehicle.initialOdemeter = Int (initialOdemeterTextField.text!)!
        vehicle.currentOdemeter = Int (initialOdemeterTextField.text!)!
        vehicle.licensePlate = licensePlateTextField.text
        vehicle.vehicleModel = vehicleModel
        vehicle.mutableSetValueForKey("user").addObject(SessionObjects.currentUser)
        
        vehicle.save()
        
        self.navigationController?.popViewControllerAnimated(true)
        
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
    
    
}
