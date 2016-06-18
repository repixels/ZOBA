//
//  mapController.swift
//  ZOBA
//
//  Created by Angel mas on 6/9/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import UIKit
import MapKit


class MapController: UIViewController , CLLocationManagerDelegate{
    
    let locationmgr : CLLocationManager! = CLLocationManager()
    var firstCoordinate : CLLocationCoordinate2D!
    
    
    @IBOutlet var longPressGesture: UILongPressGestureRecognizer!
    
    @IBOutlet weak var map: MKMapView!
    
    var delegate : mapDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationmgr.delegate = self
        locationmgr.requestWhenInUseAuthorization()
        longPressGesture.addTarget(self, action: #selector(MapController.getUserselectedCoordinate(_:)))
        
        locationmgr.requestLocation()
        setAnnotation()
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
    
    func setAnnotation(){
        
        if firstCoordinate != nil
        {
            
            print("setting first annotation at : \(firstCoordinate.latitude)  &&&&  \( firstCoordinate.longitude)")
            let annotation = MKPointAnnotation()
            annotation.coordinate = firstCoordinate
            map.addAnnotation(annotation)
        }
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        var latDelta:CLLocationDegrees = 0.05
        
        var lonDelta:CLLocationDegrees = 0.05
        
        var span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        
        let region   = MKCoordinateRegion(center: (locations.first?.coordinate)!, span: span)
        self.map.setRegion(region, animated: true)
//        self.map.setCenterCoordinate(locations.first!.coordinate, animated: true)
        
    }
    
    func getUserselectedCoordinate(gestureRecognizer:UIGestureRecognizer){
        
        if gestureRecognizer.state == .Began{
            let touchPoint = gestureRecognizer.locationInView(map)
            let newCoordinates = map.convertPoint(touchPoint, toCoordinateFromView: map)
            let annotation = MKPointAnnotation()
            annotation.coordinate = newCoordinates
            map.addAnnotation(annotation)
            
            
            print("user select : \(newCoordinates.latitude)  &&&&  \( newCoordinates.longitude)")
            
            self.delegate?.getuserSelectedCoordinate(annotation.coordinate)
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
protocol mapDelegate {
    func getuserSelectedCoordinate(coordinate : CLLocationCoordinate2D)
}