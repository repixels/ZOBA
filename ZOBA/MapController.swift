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
        longPressGesture.addTarget(self, action: #selector(MapController.getUserselectedCoordinate(gestureRecognizer:)))
        
        locationmgr.requestLocation()
        setAnnotation()
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print(error)
    }
    
    func setAnnotation(){
        
        if firstCoordinate != nil
        {
            let annotation = MKPointAnnotation()
            annotation.coordinate = firstCoordinate
            map.addAnnotation(annotation)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let latDelta:CLLocationDegrees = 0.05
        
        let lonDelta:CLLocationDegrees = 0.05
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        
        let region   = MKCoordinateRegion(center: (locations.first?.coordinate)!, span: span)
        self.map.setRegion(region, animated: true)
//        self.map.setCenterCoordinate(locations.first!.coordinate, animated: true)
        
    }
    
    func getUserselectedCoordinate(gestureRecognizer:UIGestureRecognizer){
        
        if gestureRecognizer.state == .began{
            let touchPoint = gestureRecognizer.location(in: map)
            let newCoordinates = map.convert(touchPoint, toCoordinateFrom: map)
            let annotation = MKPointAnnotation()
            annotation.coordinate = newCoordinates
            map.addAnnotation(annotation)
            
            self.delegate?.getuserSelectedCoordinate(coordinate: annotation.coordinate)
            self.navigationController?.popViewController(animated: true)
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
