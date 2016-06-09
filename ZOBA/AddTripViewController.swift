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
    
    
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var currentOdemeter: HoshiTextField!
    
    @IBOutlet weak var initialOdemeter: HoshiTextField!
    @IBOutlet weak var vehiclePicker: UIPickerView!
    @IBOutlet weak var coveredKm: HoshiTextField!
    
    @IBOutlet weak var stratPointBtn: UIButton!
    
    @IBOutlet weak var endPointBtn: UIButton!
    
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    
    var isSecondPoint = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add Trip"
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.whiteColor(),
             NSFontAttributeName: UIFont(name: "Continuum Medium", size: 22)!]
        // Do any additional setup after loading the view.
        
        initialOdemeter.text = String(100000)
        
        vehiclePicker.dataSource = self
        vehiclePicker.delegate = self
        
        
    }
    
    
    
    @IBAction func saveTrip(sender: AnyObject) {
        
        //save Trip
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    //should be real vehicles data from database
    let vehicles = ["vehicle 1 ","vehicle 2" , "vehicle 3","vehicle 4" , "vehicle 5"]
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return vehicles.count;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return vehicles[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        //should set trip vehicle value here
        print(vehicles[row])
        
    }
    
    
    @IBAction func currentOdemeterEdited(sender:AnyObject) {
        
        let dif : Int = Int(self.currentOdemeter.text!)! - Int(self.initialOdemeter.text!)!
        if( dif > 0){
            self.coveredKm.text = String(dif)
            hideErrorMessage("current Odemeter", textField: self.currentOdemeter)
        }
        else{
            showErrorMessage("enter a valid odemeter value", textField: self.currentOdemeter)
        }
    }
    
    @IBAction func coveredKmEdited(sender: AnyObject){
        
        let km = Int(self.coveredKm.text!)!
        
        if(km>0){
            let distance : Int = km + Int(self.initialOdemeter.text!)!
            
            self.currentOdemeter.text = String(distance)
            hideErrorMessage("covered Km", textField: self.coveredKm)
        }
        else{
            showErrorMessage("entered a valid value", textField: self.coveredKm)
        }
    }
    
    @IBAction func getStartPoint(sender : AnyObject){
        
        isSecondPoint = false
        presentMap()
    }
    
    @IBAction func getEndPoint(sender : AnyObject){
        isSecondPoint = true
        presentMap()
    }
    
    
    
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
    
  
    
    func presentMap(){
        let storyboard : UIStoryboard = UIStoryboard(
            name: "HomeStoryBoard",
            bundle: nil)
        let mapViewController: mapController = storyboard.instantiateViewControllerWithIdentifier("MapView") as! mapController
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
            
        }
        else{
            print("second point at : \(coordinate)")
        }
    }
    
    
}
