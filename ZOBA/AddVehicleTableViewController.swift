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
    var modelPicker : UIPickerView! = UIPickerView()
    
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Intialize Arrays
        makes = [Make]()
        models = [Model]()
        years = [Year]()
        trims = [Trim]()
        
        makePicker.delegate = self
        modelPicker.delegate = self
        
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
        
        
        makeTextField.inputView = makePicker
        modelTextField.inputView = modelPicker
        yearTextField.inputView = modelPicker
        trimTextField.inputView = modelPicker
        
        makeTextField.inputAccessoryView = toolBar
        modelTextField.inputAccessoryView = modelToolBar
        yearTextField.inputAccessoryView = modelToolBar
        trimTextField.inputAccessoryView = modelToolBar
        
        
        let dao = AbstractDao(managedObjectContext: SessionObjects.currentManageContext)
        makes =   dao.selectAll(entityName: "Make") as?  [Make]
        //        trims =  dao.selectAll(entityName: "Trim") as!  [Trim]
        //        years =  dao.selectAll(entityName: "Year") as!  [Year]
        //        models =  dao.selectAll(entityName: "Model") as!  [Model]
        
        
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
            count = makes!.count
        case modelPicker:
            
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
        case modelPicker:
            
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
            print( makes![row].name!)
            selectedMake = makes![row]
            modelTextField.text?.removeAll()
            trimTextField.text?.removeAll()
            yearTextField.text?.removeAll()
            
        case modelPicker:
            
            switch component {
            case 0:
                print( models![row].name!)
                selectedModel = models![row]
                years!.removeAll()
                let vehicleModels = models![row].vehicleModel!.allObjects as! [VehicleModel]
                vehicleModels.forEach({ (vehicleModel) in
                    years!.append( vehicleModel.year! )
                })
                modelPicker.reloadComponent(1)
                
            case 1:
                print( years![row].name!)
                selectedYear = years![row]
                
                trims!.removeAll()
                let vehicleModels = years![row].vehicleModel!.allObjects as! [VehicleModel]
                vehicleModels.forEach({ (vehicleModel) in
                    trims!.append( vehicleModel.trim! )
                })
                
                modelPicker.reloadComponent(2)
            case 2:
                print( trims![row].name!)
                selectedTrim = trims![row]
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
            self.makes = Mapper<Make>().mapArray(json.result.value)
            self.makes![0].save()
            self.makePicker.reloadAllComponents()
        }
        
    }
    
    
    func getAllModels(makeName : String){
        
        
        Alamofire.request(.GET,modelUrl,parameters: ["make":makeName]).responseJSON { (json) in
            print(json.result.value)
            print("===========================")
            self.models = Mapper<Model>().mapArray(json.result.value)
            self.models![0].save()
            self.modelPicker.reloadAllComponents()
        }
        
    }
    
    
    func getAllYears(modelName :String){
        Alamofire.request(.GET,yearUrl,parameters: ["model":modelName]).responseJSON { (json) in
            print(json.result.value)
            print("===========================")
            self.years = Mapper<Year>().mapArray(json.result.value)
            self.years![0].save()
            self.years!.forEach({ (y) in
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
            self.trims![0].save()
            self.modelPicker.reloadAllComponents()
        }
        
    }
    
    func donePicker(){
        
        
        let mak = makePicker.selectedRowInComponent(0)
        selectedMake = makes![mak]
        models = selectedMake.model?.allObjects as? [Model]
        print(models)
        let vehicleModelYears = models![0].vehicleModel!.allObjects as! [VehicleModel]
        print(vehicleModelYears.count)
        print(vehicleModelYears[0].year?.yearId)
        vehicleModelYears.forEach({ (vehicleModelYear) in
            years!.append( vehicleModelYear.year! )
        })
        let vehicleModelTrims = years![0].vehicleModel!.allObjects as! [VehicleModel]
        vehicleModelTrims.forEach { (vehicleModelTrim) in
            trims!
                .append(vehicleModelTrim.trim!)
        }
        
        makeTextField.text = selectedMake.name
        makeTextField.resignFirstResponder()
    }
    
    
    func cancelPicker(){
        makeTextField.resignFirstResponder()
    }
    
    
    func modelDonePicker(){
        let mod = modelPicker.selectedRowInComponent(0)
        selectedModel = models![mod]
        let y = modelPicker.selectedRowInComponent(1)
        selectedYear = years![y]
        let t = modelPicker.selectedRowInComponent(2)
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
        
        
        let fetchRequest = NSFetchRequest(entityName: "VehicleModel")
        let predicate = NSPredicate(format: "%K = %@ AND %K = %@ AND %K = %@", "model",selectedModel,"year", selectedYear , "trim" ,selectedTrim)
        fetchRequest.predicate = predicate
        var res : VehicleModel!
        do{
            res = try SessionObjects.currentManageContext.executeFetchRequest(fetchRequest)[0] as! VehicleModel
        } catch let error {
            print(error)
        }
        
        //selectedTrim.mutableSetValueForKey("vehicleModel.year").allObjects
        vehicle.vehicleModel = res != nil  ? res : nil
        vehicle.user = SessionObjects.currentUser
        
        vehicle.save()
        
        
        if Defaults[.curentVehicleName] == nil
        {
            Defaults[.curentVehicleName] = vehicle.name
            SessionObjects.currentVehicle = vehicle
            SessionObjects.motionMonitor = LocationMonitor()
            SessionObjects.motionMonitor.startDetection()
        }
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
}
