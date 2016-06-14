//
//  TripDetailController.swift
//  ZOBA
//
//  Created by Angel mas on 6/10/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import UIKit
import MapKit

class TripDetailController: UIViewController {
    
    
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var vehicleLbl: UILabel!
    
    @IBOutlet weak var startLocationLbl: UILabel!
    
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var initialOdemter: UILabel!
    
    @IBOutlet weak var lastLocationLbl: UILabel!
    
    @IBOutlet weak var coveredKm: UILabel!
    
    @IBOutlet weak var currentOdemeter: UILabel!
    
    
    
    var trip : Trip!
    var firstAnnotation : MKPointAnnotation!
    var secondAnnotation : MKPointAnnotation!
    
    var sourceItem : MKMapItem! = MKMapItem()
    var destinationItem : MKMapItem! = MKMapItem()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        vehicleLbl.text = trip.vehicle?.name
        date.text = "10/10/2020"
        initialOdemter.text = String(trip.initialOdemeter)
        coveredKm.text = String(trip.coveredKm)
        currentOdemeter.text = String ( Int(trip.initialOdemeter) + Int(trip.coveredKm))
        let cordinates = trip.coordinates
        
        let coordinates = cordinates?.allObjects as! [TripCoordinate]
    
        getLocation(coordinates.first!,label: startLocationLbl)
        getLocation(coordinates.last!,label: lastLocationLbl)
        setRegion(coordinates.first! , lastCoordinate: coordinates.last!)
        
    }
    
    func getLocation(coordinate : TripCoordinate,label : UILabel){
        
        let location = CLLocation(latitude: CLLocationDegrees(coordinate.latitude!), longitude: CLLocationDegrees(coordinate.longtitude!))
        location.coordinate
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (places, error) in
            dispatch_async(dispatch_get_main_queue(), {
                label.text = places!.first?.name
            })
            
            
        })
        
    }
    
    func setAnnotation( coordinate  :CLLocationCoordinate2D , title : String)-> MKPointAnnotation{
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        self.map.addAnnotation(annotation)
        return annotation
    }
    
    func setRegion(firstCoordinate : TripCoordinate , lastCoordinate : TripCoordinate){
        
        let firstlocation = CLLocation(latitude: CLLocationDegrees(firstCoordinate.latitude!), longitude: CLLocationDegrees(firstCoordinate.longtitude!))
        
        let lastlocation = CLLocation(latitude: CLLocationDegrees(lastCoordinate.latitude!), longitude: CLLocationDegrees(lastCoordinate.longtitude!))
        
        
        firstAnnotation = setAnnotation(firstlocation.coordinate, title: "first")
        
        secondAnnotation = setAnnotation(lastlocation.coordinate, title: "last")
        
        let diff = lastlocation.distanceFromLocation(firstlocation)
        
        let region =  MKCoordinateRegionMakeWithDistance(firstlocation.coordinate, diff, diff)
        
        map.setRegion(region, animated: true)
    }
    
    func fetchRoute(){
        
        print("fetching ")
        
        if (sourceItem != nil && destinationItem != nil)
        {
            let request:MKDirectionsRequest = MKDirectionsRequest()
            
            // source and destination are the relevant MKMapItems
            request.source = self.sourceItem
            request.destination = destinationItem
            
            // Specify the transportation type
            request.transportType = MKDirectionsTransportType.Automobile;
            
            // If you're open to getting more than one route,
            // requestsAlternateRoutes = true; else requestsAlternateRoutes = false;
            request.requestsAlternateRoutes = true
            
            let directions = MKDirections(request: request)
            
            print(" try to calculate route")
            
            directions.calculateDirectionsWithCompletionHandler ({
                (response: MKDirectionsResponse?, error: NSError?) in
                print("=============================")
                print(response?.routes)
                print(error)
                print("=============================")
                if error == nil {
                    //                self.directionsResponse = response
                    // Get whichever currentRoute you'd like, ex. 0
                    let route = response!.routes[0] as MKRoute
                    self.map.addOverlay(route.polyline, level: MKOverlayLevel.AboveRoads)
                    print("calculate route")
                }
                else{print("error in calculating route")
                    
                }
            })
            
        }
    }
    
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier! == "editTrip" {
            
            let controller = segue.destinationViewController as! AddTripViewController
            controller.trip = self.trip
            controller.isEditingTrip = true
        }
        
        
    }
    
    
}
