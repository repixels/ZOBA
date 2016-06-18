//
//  AddTripViewController.swift
//  ZOBA
//
//  Created by RE Pixels on 6/5/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import UIKit
import TextFieldEffects
import MapKit

class AddTripViewController: UIViewController , mapDelegate ,UIPopoverPresentationControllerDelegate
,UIPickerViewDataSource , UIPickerViewDelegate {
    
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    
    @IBOutlet weak var finalOdemeter: HoshiTextField!
    
    @IBOutlet weak var currentOdemeter: HoshiTextField!
    
    @IBOutlet weak var coveredKm: HoshiTextField!
    @IBOutlet weak var dateTextField: HoshiTextField!
    
    @IBOutlet weak var startingPointTextField: HoshiTextField!
    @IBOutlet weak var endingPointTextField: HoshiTextField!
    
    @IBOutlet weak var vehiclesPickerView: UIPickerView!
    
    var selectedVehicle : Vehicle!
    
    var vehicles : [Vehicle]!
    
    var isSecondPoint = false
    var trip : Trip!
    var isEditingTrip = false
    
    var startCoordinate : CLLocationCoordinate2D!
    var destinationCoordinate : CLLocationCoordinate2D!
    
    
    var isDateValid = false
    var isCoveredKmValid = false
    var isfinalOdemeterValid = false
    var isVehicleValid = true
    var isFirstCoordinateValid = false
    var isDestinationCoordinateValid = false
    
    
    let datePickerView:UIDatePicker = UIDatePicker()
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.prepareNavigationBar("Add a New Trip")
        
        let dao  = AbstractDao(managedObjectContext: SessionObjects.currentManageContext)
        vehicles = dao.selectAll(entityName: "Vehicle") as! [Vehicle]
        
        let DateToolBar = UIToolbar()
        DateToolBar.barStyle = UIBarStyle.Default
        DateToolBar.translucent = true
        DateToolBar.tintColor = UIColor.redColor()
        DateToolBar.sizeToFit()
        
        let modelDoneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(AddTripViewController.dateDonePicker))
        let modelSpaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let modelCancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(AddTripViewController.dateCancelPicker))
        
        DateToolBar.setItems([modelCancelButton, modelSpaceButton, modelDoneButton], animated: false)
        DateToolBar.userInteractionEnabled = true
        
        
        dateTextField.inputAccessoryView = DateToolBar
        
        
        self.vehiclesPickerView.delegate = self
        
        self.hideKeyboardWhenTappedAround()
        
        // set selected vehicle in picker to current vehicle
        let index = getCurrentVehicleIndex()
        if index >= 0 {
            vehiclesPickerView.selectRow(index, inComponent: 0, animated: false)
        }
        
        
        selectedVehicle = vehicles[vehiclesPickerView.selectedRowInComponent(0)]
        currentOdemeter.text = String(selectedVehicle.currentOdemeter!)
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if(isEditingTrip && trip != nil)
        {
            prepareNavigationBar("Edit Your Trip")
            self.isDateValid = true
            self.isVehicleValid = true
            self.isCoveredKmValid = true
            self.isfinalOdemeterValid = true
            self.isFirstCoordinateValid = true
            self.isDestinationCoordinateValid = true
            
            currentOdemeter.text = String(trip.initialOdemeter!)
            coveredKm.text = String(trip.coveredKm)
            finalOdemeter.text = String(Int(trip.initialOdemeter!) + Int(trip.coveredKm!))
            let coordinates = trip.coordinates?.allObjects as! [TripCoordinate]
            
            self.startCoordinate = CLLocationCoordinate2D(latitude: Double((coordinates.first?.latitude)!), longitude: Double((coordinates.first?.longtitude)!))
            self.destinationCoordinate = CLLocationCoordinate2D(latitude: Double((coordinates.last?.latitude)!), longitude:Double(( coordinates.last?.longtitude)!))
            getLocation(self.startCoordinate, sender: self.startingPointTextField)
            getLocation(self.destinationCoordinate , sender: self.endingPointTextField)
            
            saveBtn.enabled = true
            saveBtn.tintColor = UIColor.blueColor()
        }
        
        
    }
    
    @IBAction func saveTrip(sender: AnyObject) {
        
        //save Trip
        
        let firstCoordinate = TripCoordinate(managedObjectContext: SessionObjects.currentManageContext, entityName: "TripCoordinate")
        firstCoordinate.latitude = NSDecimalNumber(double: startCoordinate.latitude)
        firstCoordinate.longtitude = NSDecimalNumber(double:startCoordinate.longitude)
        firstCoordinate.address = startingPointTextField.text != nil ? startingPointTextField.text : ""
        
        let secondCoordinate = TripCoordinate(managedObjectContext: SessionObjects.currentManageContext, entityName: "TripCoordinate")
        secondCoordinate.latitude = NSDecimalNumber(double:destinationCoordinate.latitude)
        secondCoordinate.longtitude = NSDecimalNumber(double:destinationCoordinate.longitude)
        secondCoordinate.address = endingPointTextField.text != nil ? endingPointTextField.text : ""
        
        if !isEditingTrip || self.trip == nil
        {
            self.trip = Trip(managedObjectContext: SessionObjects.currentManageContext, entityName: "Trip")
        }
        
        trip.coveredKm = Int(self.coveredKm.text!)!
        trip.initialOdemeter = Int(self.currentOdemeter.text!)!
        
        
        
        trip.coordinates = NSSet(array: [firstCoordinate,secondCoordinate])
        
        trip.vehicle = selectedVehicle
        trip.vehicle?.currentOdemeter = Int(trip.initialOdemeter!) + Int(trip.coveredKm!)
        trip.save()
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    // MARK:vehicle picker methods
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return vehicles.count;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return vehicles[row].name
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        selectedVehicle = vehicles[row]
        currentOdemeter.text = String( selectedVehicle.currentOdemeter)
        
        coveredKm.text = ""
        finalOdemeter.text = ""
        
        isVehicleValid = true
        validateSave()
    }
    
    //MARK: date picker
    @IBAction func dateEditingBegin(sender: HoshiTextField) {
        
        
        datePickerView.datePickerMode = UIDatePickerMode.Date
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
        
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        
        dateTextField.text = dateFormatter.stringFromDate(sender.date)
        
        isDateValid = true
        validateSave()
    }
    
    
    
    @IBAction func vehicleEditingBegin(sender: HoshiTextField) {
    }
    
    
    //MARK: Odemeter textField editing
    @IBAction func finalOdemeterEdited(sender:AnyObject) {
        
        if ( self.finalOdemeter.text!.isNotEmpty && DataValidations.hasNoWhiteSpaces(self.finalOdemeter.text!)){
            let dif : Int = Int(self.finalOdemeter.text!)! - Int(self.currentOdemeter.text!)!
            if( dif > 0 && (String(dif)).characters.count < self.coveredKm.maxLength){
                self.coveredKm.text = String(dif)
                hideErrorMessage("current Odemeter", textField: self.finalOdemeter)
                isfinalOdemeterValid = true
                isCoveredKmValid = true
                validateSave()
            }
            else{
                showErrorMessage("enter a valid odemeter value", textField: self.finalOdemeter)
                isfinalOdemeterValid = false
                isCoveredKmValid = false
                validateSave()
            }
            
        }
        else{
            showErrorMessage("enter a valid odemeter value", textField: self.finalOdemeter)
            isfinalOdemeterValid = false
            isCoveredKmValid = false
            validateSave()
        }
    }
    
    @IBAction func coveredKmEdited(sender: AnyObject){
        
        if ( self.coveredKm.text!.isNotEmpty && DataValidations.hasNoWhiteSpaces(self.coveredKm.text!) && Int(self.coveredKm.text!)! > 0 ){
            let km = Int(self.coveredKm.text!)
            let distance : Int = km! + Int(self.currentOdemeter.text!)!
            
            if((String(distance)).characters.count < self.finalOdemeter.maxLength){
                
                
                self.finalOdemeter.text = String(distance)
                hideErrorMessage("covered Km", textField: self.coveredKm)
                isCoveredKmValid = true
                isfinalOdemeterValid = true
                validateSave()
            }
            else{
                showErrorMessage("entered a valid value", textField: self.coveredKm)
                isCoveredKmValid = false
                isfinalOdemeterValid = false
                validateSave()
            }
        }
        else{
            showErrorMessage("entered a valid value", textField: self.coveredKm)
            isCoveredKmValid = false
            isfinalOdemeterValid = false
            validateSave()
        }
        
    }
    
    
    
    //MARK: get user Location
    @IBAction func getStartPoint(sender : AnyObject){
        
        isSecondPoint = false
        presentMap()
        isFirstCoordinateValid = true
        validateSave()
        
    }
    
    @IBAction func getEndPoint(sender : AnyObject){
        isSecondPoint = true
        presentMap()
        isDestinationCoordinateValid = true
        validateSave()
    }
    
    func presentMap(){
        
        let mapViewController: MapController = self.storyboard!.instantiateViewControllerWithIdentifier("MapView") as! MapController
        mapViewController.delegate = self
        if ( isSecondPoint ) {
            mapViewController.firstCoordinate = self.startCoordinate
        }
        else {
            mapViewController.firstCoordinate = self.destinationCoordinate
        }
        self.navigationController?.pushViewController(mapViewController, animated: true)
        
    }
    
    func getuserSelectedCoordinate(coordinate: CLLocationCoordinate2D) {
        
        //should set coordinate value here
        if(!isSecondPoint){
            getLocation(coordinate, sender: self.startingPointTextField)
            startCoordinate = coordinate
        }
        else{
            getLocation(coordinate, sender: self.endingPointTextField)
            destinationCoordinate = coordinate
        }
    }
    
    func getLocation(coordinate : CLLocationCoordinate2D,sender : HoshiTextField){
        
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (places, error) in
            dispatch_async(dispatch_get_main_queue(), {
                sender.text = places!.first?.name
            })
            
            
        })
        
    }
    
    
    //MARK:  text field error message
    func showErrorMessage(message:String , textField:HoshiTextField)
    {
        textField.borderInactiveColor = UIColor.redColor()
        textField.borderActiveColor = UIColor.redColor()
        textField.placeholderColor = UIColor.redColor()
        textField.placeholderLabel.text = message
        textField.placeholderLabel.sizeToFit()
        textField.placeholderLabel.alpha = 1.0
    }
    
    func hideErrorMessage(message : String , textField: HoshiTextField)
    {
        textField.borderInactiveColor = UIColor.greenColor()
        textField.borderActiveColor = UIColor.greenColor()
        textField.placeholderColor = UIColor.whiteColor()
        textField.placeholderLabel.text = message
        textField.placeholderLabel.alpha = 1.0
    }
    
    func validateSave(){
        
        
        let valid = isDateValid && isCoveredKmValid && isfinalOdemeterValid && isVehicleValid && isFirstCoordinateValid && isDestinationCoordinateValid
        if (valid){
            self.saveBtn.enabled = true
            self.saveBtn.tintColor = UIColor.whiteColor()
            
        }
        else{
            
            self.saveBtn.enabled = false
            self.saveBtn.tintColor = UIColor.grayColor()
            
        }
        
        
    }
    
    
    @IBAction func showUserProfile(sender: UIBarButtonItem) {
        
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("userProfile") as! UserProfileViewController
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func dateDonePicker(){
        
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        
        dateTextField.text = dateFormatter.stringFromDate(datePickerView.date)
        dateTextField.resignFirstResponder()
        isDateValid = true
        validateSave()
        
    }
    func dateCancelPicker(){
        
        dateTextField.resignFirstResponder()
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
    
    func prepareNavigationBar(title:String)
    {
        self.title = title
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.whiteColor(),
             NSFontAttributeName: UIFont(name: "Continuum Medium", size: 22)!]
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "nav-background"), forBarMetrics: .Default)
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor();
        
        saveBtn.enabled = false
        saveBtn.tintColor = UIColor.grayColor()
        
    }
    
}
