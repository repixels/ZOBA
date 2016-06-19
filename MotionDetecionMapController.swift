//
//  MotionDetecionMapController.swift
//  ZOBA
//
//  Created by Angel mas on 6/15/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import UIKit
import MapKit
import TextFieldEffects
import SwiftyUserDefaults

class MotionDetecionMapController: UIViewController ,CLLocationManagerDelegate ,MapDetectionDelegate{
    
    
    @IBOutlet weak var map: MKMapView!
    var monitor : LocationMonitor! = nil
    
    @IBOutlet weak var currentSpeed: HoshiTextField!
    @IBOutlet weak var totalDistance: HoshiTextField!
    @IBOutlet weak var havingTripTextField: HoshiTextField!
    
    @IBOutlet weak var autoReportingControlButton: UIButton!
    @IBOutlet weak var currentSpeedLabel: UILabel!
    @IBOutlet weak var speedMeasuringUnitLabel: UILabel!
    @IBOutlet weak var coveredDistanceLabel: UILabel!
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    
    
    
    let manager  = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.map.showsUserLocation = true
        
        self.manager.delegate = self
        manager.requestAlwaysAuthorization()
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        let block :(Double,Double)->() = {(speed,distance) in
            
            
            
            self.currentSpeed.text = String.localizedStringWithFormat("%.2f %@", speed, " Km/Hr")
            self.totalDistance.text = String.localizedStringWithFormat("%.2f %@", distance, " Km")
            self.havingTripTextField.text = String(Defaults[.isHavingTrip])
        }
        
        SessionObjects.motionMonitor.updateLocationBlock = block
        SessionObjects.motionMonitor.delegate = self
    }
    let annotation = MKPointAnnotation()
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        annotation.coordinate = (locations.first?.coordinate)!
        self.map.addAnnotation(annotation)
        self.map.centerCoordinate = annotation.coordinate
        
    }
    @IBAction func stopDetecionTapped(sender: AnyObject) {
        SessionObjects.motionMonitor.stopTrip()
        self.havingTripTextField.text = String(Defaults[.isHavingTrip])
    }
    
    
    
    
    @IBAction func cancelTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Zoba", message: "looks like you are moving  ", preferredStyle: .Alert)
        
        let activateAutoReport = UIAlertAction(title: "Auto report", style:.Default) { (action) in
            print("auto reprt started")
            SessionObjects.motionMonitor.startNewTrip()
            self.havingTripTextField.text = String(Defaults[.isHavingTrip])
            alert.dismissViewControllerAnimated(true, completion: nil)
        }
        
        let cancel = UIAlertAction(title: "cancel", style: .Cancel, handler: nil)
        
        
        alert.addAction(activateAutoReport)
        alert.addAction(cancel)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func showStopAlert() {
        
        let alert = UIAlertController(title: "Zoba", message: "you have stopped  ", preferredStyle: .Alert)
        
        let stopAutoReport = UIAlertAction(title: "ok", style:.Default) { (action) in
            
            SessionObjects.motionMonitor.stopTrip()
            alert.dismissViewControllerAnimated(true, completion: nil)
        }
        
        let cancel = UIAlertAction(title: "cancel", style:.Default) { (action) in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }
        
        
        alert.addAction(stopAutoReport)
        alert.addAction(cancel)
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func startDetection(sender: AnyObject) {
        
        SessionObjects.motionMonitor.startNewTrip()
    }
    
}
