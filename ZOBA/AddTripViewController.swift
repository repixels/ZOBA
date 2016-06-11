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
    
    
    
    
    @IBOutlet weak var currentOdemeter: HoshiTextField!
    
    @IBOutlet weak var initialOdemeter: HoshiTextField!
    
    @IBOutlet weak var coveredKm: HoshiTextField!
    
    @IBOutlet weak var stratPointBtn: UIButton!
    
    @IBOutlet weak var endPointBtn: UIButton!
    
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    
    @IBOutlet weak var startLocationLbl: UILabel!
    @IBOutlet weak var destinationLocationLbl: UILabel!
    
    
    @IBOutlet weak var vehicleTextField: HoshiTextField!
    @IBOutlet weak var dateTextField: HoshiTextField!
    
    
    
    var selectedVehicle : Vehicle!
    
    var vehicles : [Vehicle]!
    
    var isSecondPoint = false
    var trip : Trip!
    var isEditingTrip = false
    
    var startCoordinate : CLLocationCoordinate2D!
    var destinationCoordinate : CLLocationCoordinate2D!
    
    
    var isDateValid = false
    var isCoveredKmValid = false
    var isCurrentOdemeterValid = false
    var isVehicleValid = false
    var isFirstCoordinateValid = false
    var isDestinationCoordinateValid = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add Trip"
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.whiteColor(),
             NSFontAttributeName: UIFont(name: "Continuum Medium", size: 22)!]
        // Do any additional setup after loading the view.
        
        saveBtn.enabled = false
        saveBtn.tintColor = UIColor.grayColor()
        
        let moc = ( UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        
        let dao  = AbstractDao(managedObjectContext: moc)
        vehicles = dao.selectAll(entityName: "Vehicle") as! [Vehicle]
        
        
        
        
        
        initialOdemeter.text = String(vehicles[0].currentOdemeter)
        
        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        
        vehicleTextField.inputView = pickerView
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        if(isEditingTrip && trip != nil)
        {
            self.isDateValid = true
            self.isVehicleValid = true
            self.isCoveredKmValid = true
            self.isCurrentOdemeterValid = true
            self.isFirstCoordinateValid = true
            self.isDestinationCoordinateValid = true
            
            initialOdemeter.text = String(trip.initialOdemeter)
            coveredKm.text = String(trip.coveredKm)
            currentOdemeter.text = String(trip.initialOdemeter + trip.coveredKm)
            vehicleTextField.text = trip.vehicle?.name
            let coordinates = trip.coordinates?.allObjects as! [TripCoordinate]
            
            self.startCoordinate = CLLocationCoordinate2D(latitude: Double((coordinates.first?.latitude)!), longitude: Double((coordinates.first?.longtitude)!))
            self.destinationCoordinate = CLLocationCoordinate2D(latitude: Double((coordinates.last?.latitude)!), longitude:Double(( coordinates.last?.longtitude)!))
            getLocation(self.startCoordinate, label: startLocationLbl)
            getLocation(self.destinationCoordinate , label: destinationLocationLbl)
            
            saveBtn.enabled = true
            saveBtn.tintColor = UIColor.blueColor()
        }
        
    }
    
    @IBAction func saveTrip(sender: AnyObject) {
        
        //save Trip
        
        
        let moc = ( UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let firstCoordinate = TripCoordinate(managedObjectContext: moc, entityName: "TripCoordinate")
        firstCoordinate.latitude = NSDecimalNumber(double: startCoordinate.latitude)
        firstCoordinate.longtitude = NSDecimalNumber(double:startCoordinate.longitude)
        firstCoordinate.save()
        
        let secondCoordinate = TripCoordinate(managedObjectContext: moc, entityName: "TripCoordinate")
        secondCoordinate.latitude = NSDecimalNumber(double:destinationCoordinate.latitude)
        secondCoordinate.longtitude = NSDecimalNumber(double:destinationCoordinate.longitude)
        secondCoordinate.save()
        
        if(isEditingTrip && trip != nil){}
        else{
            trip = Trip(managedObjectContext: moc, entityName: "Trip")
        }
        
        trip.coveredKm = Int64(self.coveredKm.text!)!
        trip.initialOdemeter = Int64(self.initialOdemeter.text!)!
        
        
        trip.coordinates = NSSet(array: [firstCoordinate,secondCoordinate])
        
        trip.vehicle = selectedVehicle
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
        //should set trip vehicle value here
        print(vehicles[row])
        vehicleTextField.text = vehicles[row].name
        selectedVehicle = vehicles[row]
        vehicleTextField.resignFirstResponder()
        
        isVehicleValid = true
        validateSave()
    }
    
    //MARK: date picker
    @IBAction func dateEditingBegin(sender: HoshiTextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        
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
    @IBAction func currentOdemeterEdited(sender:AnyObject) {
        
        if ( self.currentOdemeter.text!.isNotEmpty && DataValidations.hasNoWhiteSpaces(self.currentOdemeter.text!)){
            let dif : Int = Int(self.currentOdemeter.text!)! - Int(self.initialOdemeter.text!)!
            if( dif > 0){
                self.coveredKm.text = String(dif)
                hideErrorMessage("current Odemeter", textField: self.currentOdemeter)
                isCurrentOdemeterValid = true
                validateSave()
            }
            else{
                showErrorMessage("enter a valid odemeter value", textField: self.currentOdemeter)
                isCurrentOdemeterValid = false
                validateSave()
            }
        }
        else{
            showErrorMessage("enter a valid odemeter value", textField: self.currentOdemeter)
            isCurrentOdemeterValid = false
            validateSave()
        }
    }
    
    @IBAction func coveredKmEdited(sender: AnyObject){
        
        if ( self.coveredKm.text!.isNotEmpty && DataValidations.hasNoWhiteSpaces(self.coveredKm.text!)){
            let km = Int(self.coveredKm.text!)!
            
            if(km>0){
                let distance : Int = km + Int(self.initialOdemeter.text!)!
                
                self.currentOdemeter.text = String(distance)
                hideErrorMessage("covered Km", textField: self.coveredKm)
                isCoveredKmValid = true
                validateSave()
            }
            else{
                showErrorMessage("entered a valid value", textField: self.coveredKm)
                isCoveredKmValid = false
                validateSave()
            }
        }
        else{
            showErrorMessage("entered a valid value", textField: self.coveredKm)
            isCoveredKmValid = false
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
        
        let mapViewController: mapController = self.storyboard!.instantiateViewControllerWithIdentifier("MapView") as! mapController
        mapViewController.modalPresentationStyle = .Popover
        mapViewController.preferredContentSize = CGSizeMake(50, 200)
        mapViewController.delegate = self
        let popoverMenuViewController = mapViewController.popoverPresentationController
        popoverMenuViewController?.permittedArrowDirections = .Any
        popoverMenuViewController?.delegate = self
        
        presentViewController(mapViewController,animated: true,completion: nil)
        
    }
    
    func getuserSelectedCoordinate(coordinate: CLLocationCoordinate2D) {
        
        //should set coordinate value here
        if(!isSecondPoint){
            print("first point at : \(coordinate)")
            getLocation(coordinate, label: self.startLocationLbl)
            startCoordinate = coordinate
        }
        else{
            print("second point at : \(coordinate)")
            getLocation(coordinate, label: self.destinationLocationLbl)
            destinationCoordinate = coordinate
        }
    }
    
    func getLocation(coordinate : CLLocationCoordinate2D,label : UILabel){
        
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (places, error) in
            dispatch_async(dispatch_get_main_queue(), {
                label.text = places!.first?.name
                
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
        
        
        let valid = isDateValid && isCoveredKmValid && isCurrentOdemeterValid && isVehicleValid && isFirstCoordinateValid && isDestinationCoordinateValid
        if (valid){
            self.saveBtn.enabled = true
            self.saveBtn.tintColor = UIColor.blueColor()
            
        }
        else{
            
            self.saveBtn.enabled = false
            self.saveBtn.tintColor = UIColor.grayColor()
            
        }
        
        
    }
    
    
    @IBAction func showUserProfile(sender: UIBarButtonItem) {
        
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("userProfile") as! UserProfileViewController
        
        let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let dao = AbstractDao(managedObjectContext: moc)
        let user = dao.selectAll(entityName: "MyUser")[0] as! MyUser
        print(user.userName)
        print(user.email)
        print(user.firstName)
        print(user.password)
        controller.user = user
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
