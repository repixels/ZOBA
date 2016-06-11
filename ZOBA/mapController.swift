//
//  mapController.swift
//  ZOBA
//
//  Created by Angel mas on 6/9/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import UIKit
import MapKit


class mapController: UIViewController , CLLocationManagerDelegate{
    
    let locationmgr : CLLocationManager! = CLLocationManager()
    
    @IBOutlet var longPressGesture: UILongPressGestureRecognizer!
    
    @IBOutlet weak var map: MKMapView!
    
    var delegate : mapDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationmgr.delegate = self
        locationmgr.requestWhenInUseAuthorization()
        longPressGesture.addTarget(self, action: #selector(mapController.action(_:)))
        // Do any additional setup after loading the view.
    }
    
    
    func action(gestureRecognizer:UIGestureRecognizer){
        let touchPoint = gestureRecognizer.locationInView(map)
        let newCoordinates = map.convertPoint(touchPoint, toCoordinateFromView: map)
        let annotation = MKPointAnnotation()
        annotation.coordinate = newCoordinates
       // print(annotation.coordinate)
        map.addAnnotation(annotation)
        
        
        self.dismissViewControllerAnimated(true) { 
            print("map dismissed")
            self.delegate?.getuserSelectedCoordinate(annotation.coordinate)
        }
//        
//        let location = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
//        
//        
//        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (places, error) in
//            places?.forEach({ (place) in
//                print(place.addressDictionary)
//            })
//        })
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