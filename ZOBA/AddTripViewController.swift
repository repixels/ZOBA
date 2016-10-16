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
    @IBOutlet weak var scrollview: UIScrollView!
    
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    
    @IBOutlet weak var finalOdemeter: HoshiTextField!
    
    @IBOutlet weak var currentOdemeter: HoshiTextField!
    
    @IBOutlet weak var coveredKm: HoshiTextField!
    @IBOutlet weak var dateTextField: HoshiTextField!
    
    @IBOutlet weak var startingPointTextField: HoshiTextField!
    @IBOutlet weak var endingPointTextField: HoshiTextField!
    
    @IBOutlet weak var vehiclesPickerView: UIPickerView!
    
    var selectedVehicle : Vehicle!
    var selectedDate : NSDate!
    
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
        
        self.prepareNavigationBar(title: "Add a New Trip")
        
        let dao  = AbstractDao(managedObjectContext: SessionObjects.currentManageContext)
        vehicles = dao.selectAll(entityName: "Vehicle") as! [Vehicle]
        
        let DateToolBar = UIToolbar()
        DateToolBar.barStyle = UIBarStyle.default
        DateToolBar.isTranslucent = true
        DateToolBar.tintColor = UIColor.red
        DateToolBar.sizeToFit()
        
        let modelDoneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(AddTripViewController.dateDonePicker))
        let modelSpaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let modelCancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(AddTripViewController.dateCancelPicker))
        
        DateToolBar.setItems([modelCancelButton, modelSpaceButton, modelDoneButton], animated: false)
        DateToolBar.isUserInteractionEnabled = true
        
        
        dateTextField.inputAccessoryView = DateToolBar
        
        
        self.vehiclesPickerView.delegate = self
        
        self.hideKeyboardWhenTappedAround()
        
        // set selected vehicle in picker to current vehicle
        let index = getCurrentVehicleIndex()
        if index >= 0 {
            vehiclesPickerView.selectRow(index, inComponent: 0, animated: false)
        }
        
        
        selectedVehicle = vehicles[vehiclesPickerView.selectedRow(inComponent: 0)]
        currentOdemeter.text = String(describing: selectedVehicle.currentOdemeter!)
        
        
        
        //register keyboard notification
        let notCenter = NotificationCenter.default
        notCenter.addObserver(self, selector: #selector (keyboardWillHide), name: 	NSNotification.Name.UIKeyboardWillHide, object: nil)
        notCenter.addObserver(self, selector: #selector (keyBoardWillAppear), name: 	NSNotification.Name.UIKeyboardWillShow, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if(isEditingTrip && trip != nil)
        {
            prepareNavigationBar(title: "Edit Your Trip")
            self.isDateValid = true
            self.isVehicleValid = true
            self.isCoveredKmValid = true
            self.isfinalOdemeterValid = true
            self.isFirstCoordinateValid = true
            self.isDestinationCoordinateValid = true
            
            currentOdemeter.text = String(describing: trip.initialOdemeter!)
            coveredKm.text = String(describing: trip.coveredKm)
            finalOdemeter.text = String(Int(trip.initialOdemeter!) + Int(trip.coveredKm!))
            let coordinates = trip.coordinates?.allObjects as! [TripCoordinate]
            
            self.startCoordinate = CLLocationCoordinate2D(latitude: Double((coordinates.first?.latitude)!), longitude: Double((coordinates.first?.longtitude)!))
            self.destinationCoordinate = CLLocationCoordinate2D(latitude: Double((coordinates.last?.latitude)!), longitude:Double(( coordinates.last?.longtitude)!))
            getLocation(coordinate: self.startCoordinate, sender: self.startingPointTextField)
            getLocation(coordinate: self.destinationCoordinate , sender: self.endingPointTextField)
            
            saveBtn.isEnabled = true
            saveBtn.tintColor = UIColor.blue
        }
        
        
    }
    
    
    // MARK:vehicle picker methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return vehicles.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return vehicles[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        selectedVehicle = vehicles[row]
        currentOdemeter.text = String( describing: selectedVehicle.currentOdemeter!)
        
        coveredKm.text = ""
        finalOdemeter.text = ""
        
        isVehicleValid = true
        validateSave()
    }
    
    //MARK: date picker
    @IBAction func dateEditingBegin(_ sender: HoshiTextField) {
        
        datePickerView.maximumDate = Date()
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
        
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        dateTextField.text = dateFormatter.string(from: sender.date)
        
        isDateValid = true
        validateSave()
    }
    
    
    
    @IBAction func vehicleEditingBegin(_ sender: HoshiTextField) {
    }
    
    
    //MARK: Odemeter textField editing
    @IBAction func finalOdemeterEdited(_ sender:AnyObject) {
        
        if ( self.finalOdemeter.text!.isNotEmpty && DataValidations.hasNoWhiteSpaces(str: self.finalOdemeter.text!)){
            let dif : Int = Int(self.finalOdemeter.text!)! - Int(self.currentOdemeter.text!)!
            if( dif > 0 && (String(dif)).characters.count < self.coveredKm.maxLength){
                self.coveredKm.text = String(dif)
                hideErrorMessage(message: "current Odemeter", textField: self.finalOdemeter)
                isfinalOdemeterValid = true
                isCoveredKmValid = true
                validateSave()
            }
            else{
                showErrorMessage(message: "enter a valid odemeter value", textField: self.finalOdemeter)
                isfinalOdemeterValid = false
                isCoveredKmValid = false
                validateSave()
            }
            
        }
        else{
            showErrorMessage(message: "enter a valid odemeter value", textField: self.finalOdemeter)
            isfinalOdemeterValid = false
            isCoveredKmValid = false
            validateSave()
        }
    }
    
    @IBAction func coveredKmEdited(_ sender: AnyObject){
        
        if ( self.coveredKm.text!.isNotEmpty && DataValidations.hasNoWhiteSpaces(str: self.coveredKm.text!) && Int(self.coveredKm.text!)! > 0 ){
            let km = Int(self.coveredKm.text!)
            let distance : Int = km! + Int(self.currentOdemeter.text!)!
            
            if((String(distance)).characters.count < self.finalOdemeter.maxLength){
                
                
                self.finalOdemeter.text = String(distance)
                hideErrorMessage(message: "covered Km", textField: self.coveredKm)
                isCoveredKmValid = true
                isfinalOdemeterValid = true
                validateSave()
            }
            else{
                showErrorMessage(message: "entered a valid value", textField: self.coveredKm)
                isCoveredKmValid = false
                isfinalOdemeterValid = false
                validateSave()
            }
        }
        else{
            showErrorMessage(message: "entered a valid value", textField: self.coveredKm)
            isCoveredKmValid = false
            isfinalOdemeterValid = false
            validateSave()
        }
        
    }
    
    
    
    //MARK: get user Location
    @IBAction func getStartPoint(_ sender : AnyObject){
        
        isSecondPoint = false
        presentMap()
        isFirstCoordinateValid = true
        validateSave()
        
    }
    
    @IBAction func getEndPoint(_ sender : AnyObject){
        isSecondPoint = true
        presentMap()
        isDestinationCoordinateValid = true
        validateSave()
    }
    
    func presentMap(){
        
        let mapViewController: MapController = self.storyboard!.instantiateViewController(withIdentifier: "MapView") as! MapController
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
            getLocation(coordinate: coordinate, sender: self.startingPointTextField)
            startCoordinate = coordinate
        }
        else{
            getLocation(coordinate: coordinate, sender: self.endingPointTextField)
            destinationCoordinate = coordinate
        }
    }
    
    func getLocation(coordinate : CLLocationCoordinate2D,sender : HoshiTextField){
        
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (places, error) in
            DispatchQueue.main.async(execute: {
                sender.text = places!.first?.name
            })
            
            
        })
        
    }
    
    
    //MARK:  text field error message
    func showErrorMessage(message:String , textField:HoshiTextField)
    {
        textField.borderInactiveColor = UIColor.red
        textField.borderActiveColor = UIColor.red
        textField.placeholderColor = UIColor.red
        textField.placeholderLabel.text = message
        textField.placeholderLabel.sizeToFit()
        textField.placeholderLabel.alpha = 1.0
    }
    
    func hideErrorMessage(message : String , textField: HoshiTextField)
    {
        textField.borderInactiveColor = UIColor.green
        textField.borderActiveColor = UIColor.green
        textField.placeholderColor = UIColor.white
        textField.placeholderLabel.text = message
        textField.placeholderLabel.alpha = 1.0
    }
    
    func validateSave(){
        
        
        let valid = isDateValid && isCoveredKmValid && isfinalOdemeterValid && isVehicleValid && isFirstCoordinateValid && isDestinationCoordinateValid
        if (valid){
            self.saveBtn.isEnabled = true
            self.saveBtn.tintColor = UIColor.white
            
        }
        else{
            
            self.saveBtn.isEnabled = false
            self.saveBtn.tintColor = UIColor.gray
            
        }
        
        
    }
    
    func dateDonePicker(){
        
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        
        dateTextField.text = dateFormatter.string(from: datePickerView.date)
        dateTextField.resignFirstResponder()
        isDateValid = true
        selectedDate = datePickerView.date as NSDate!
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
            [NSForegroundColorAttributeName: UIColor.white,
             NSFontAttributeName: UIFont(name: "Continuum Medium", size: 22)!]
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "nav-background"), for: .default)
        self.navigationController!.navigationBar.tintColor = UIColor.white
        
        saveBtn.isEnabled = false
        saveBtn.tintColor = UIColor.gray
        
    }
    
    
    @IBAction func saveTrip(_ sender: AnyObject) {
        
        //save Trip
        
        let firstCoordinate = TripCoordinate(managedObjectContext: SessionObjects.currentManageContext, entityName: "TripCoordinate")
        
        firstCoordinate.latitude = Decimal( startCoordinate.latitude) as NSDecimalNumber
        firstCoordinate.longtitude = Decimal(startCoordinate.longitude)as NSDecimalNumber
        firstCoordinate.address = startingPointTextField.text != nil ? startingPointTextField.text : ""
        
        let secondCoordinate = TripCoordinate(managedObjectContext: SessionObjects.currentManageContext, entityName: "TripCoordinate")
        secondCoordinate.latitude = Decimal(destinationCoordinate.latitude) as NSDecimalNumber?
        secondCoordinate.longtitude = Decimal(destinationCoordinate.longitude) as NSDecimalNumber?
        secondCoordinate.address = endingPointTextField.text != nil ? endingPointTextField.text : ""
        
        if !isEditingTrip || self.trip == nil
        {
            self.trip = Trip(managedObjectContext: SessionObjects.currentManageContext, entityName: "Trip")
        }
        
        trip.coveredKm = Int(self.coveredKm.text!)! as NSNumber
        trip.initialOdemeter = Int(self.currentOdemeter.text!)! as NSNumber
        
        
        trip.dateAdded =  selectedDate != nil ? (selectedDate.timeIntervalSince1970) as NSNumber: (NSDate().timeIntervalSince1970) as NSNumber
        
        trip.coordinates = NSSet(array: [firstCoordinate,secondCoordinate])
        
        trip.vehicle = selectedVehicle
        trip.vehicle?.currentOdemeter = (Int(trip.initialOdemeter!) + Int(trip.coveredKm!)) as NSNumber
        saveTripToWebService(trip: trip)
        
        
        //trip.save()
        
        
        
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func saveTripToWebService(trip :Trip)
    {
        let tripWebService = TripWebService()
        tripWebService.saveTrip(trip: trip) { (returnedTrip, code) in
            
            
            switch code {
            case "success":
                
                self.saveTripCoordinateToWebService(trip: returnedTrip!, tripCoordinate: trip.coordinates?.allObjects.first as! TripCoordinate)
                
                self.saveTripCoordinateToWebService(trip: returnedTrip!, tripCoordinate: trip.coordinates?.allObjects.last as! TripCoordinate)
                
                trip.tripId = returnedTrip?.tripId
                SessionObjects.currentManageContext.delete(returnedTrip!)
                trip.save()
                break
            case "error" :
                trip.save()
                break
            default:
                break
                
            }
        }
    }
    
    func saveTripCoordinateToWebService(trip : Trip, tripCoordinate : TripCoordinate){
        
        let tripWebService = TripWebService()
        tripWebService.saveCoordinate(vehicleId: Int(selectedVehicle.vehicleId!), coordinate:  tripCoordinate, tripId: Int(trip.tripId!)){ (returnedCoordinate , code )in
            
            
            switch code {
            case "success":
                SessionObjects.currentManageContext.delete(returnedCoordinate!)
                
                break
            case "error" :
                break
            default:
                break
                
            }
            
        }
        print("coordiate saved")
    }
    
    
    
    //MARK: - keyboard
    func keyBoardWillAppear(notification : NSNotification){        
        if let userInfo = notification.userInfo {
            if let keyboardSize: CGSize =    (userInfo[UIKeyboardFrameEndUserInfoKey]  as! NSValue).cgRectValue.size {
                let contentInset = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height,  0.0);
                
                self.scrollview.contentInset = contentInset
                self.scrollview.scrollIndicatorInsets = contentInset
                
                self.scrollview.contentOffset = CGPoint(x:self.scrollview.contentOffset.x,y: 0 + ( keyboardSize.height/2)) //set zero instead
                
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let _: CGSize =  (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size {
                let contentInset = UIEdgeInsets.zero;
                
                self.scrollview.contentInset = contentInset
                self.scrollview.scrollIndicatorInsets = contentInset
                self.scrollview.contentOffset = CGPoint(x:self.scrollview.contentOffset.x,y:self.scrollview.contentOffset.y)
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
