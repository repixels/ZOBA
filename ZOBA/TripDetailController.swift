//
//  TripDetailController.swift
//  ZOBA
//
//  Created by Angel mas on 6/10/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import UIKit
import MapKit
import TextFieldEffects

class TripDetailController: UIViewController ,MKMapViewDelegate{
    
    
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var vehicleNameTextField: HoshiTextField!
    
    @IBOutlet weak var startPointTextField: HoshiTextField!
    
    @IBOutlet weak var dateTextField: HoshiTextField!
    
    @IBOutlet weak var initialOdemeterTextField: HoshiTextField!
    
    @IBOutlet weak var endPointTextField: HoshiTextField!
    
    @IBOutlet weak var coveredMilageTextField: HoshiTextField!
    
    @IBOutlet weak var currentOdemeterTextField: HoshiTextField!
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    var trip : Trip!
    var firstAnnotation : MKPointAnnotation!
    var secondAnnotation : MKPointAnnotation!
    
    var sourceItem : MKMapItem! = MKMapItem()
    var destinationItem : MKMapItem! = MKMapItem()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor();
        map.delegate = self
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        vehicleNameTextField.text = trip.vehicle?.name
        
        dateTextField.text = String(NSDate(timeIntervalSince1970:Double(trip.dateAdded!)))
        initialOdemeterTextField.text = String(trip.initialOdemeter!)
        coveredMilageTextField.text = String(trip.coveredKm!)
        currentOdemeterTextField.text = String ( Int(trip.initialOdemeter!) + Int(trip.coveredKm!))
        let cordinates = trip.coordinates
        
        let coordinates = cordinates?.allObjects as! [TripCoordinate]
        
        getLocation(coordinates.first!,sender: startPointTextField)
        getLocation(coordinates.last!,sender: endPointTextField)
        setRegion(coordinates.first! , lastCoordinate: coordinates.last!)
        
        if trip.image != nil {
            imageView.hidden = false
            self.map.hidden = true
            self.map.userInteractionEnabled = false
            imageView.contentMode = .ScaleAspectFill
            imageView.image = UIImage(data:trip.image! )
            
        }
    }
    
    func getLocation(coordinate : TripCoordinate,sender : HoshiTextField){
        
        let location = CLLocation(latitude: CLLocationDegrees(coordinate.latitude!), longitude: CLLocationDegrees(coordinate.longtitude!))
        location.coordinate
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (places, error) in
            dispatch_async(dispatch_get_main_queue(), {
                sender.text = places!.first?.name
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
        var coordinates = [firstlocation.coordinate,lastlocation.coordinate]
        let polyline = MKPolyline(coordinates: &coordinates , count: 2)
        
        map.addOverlay(polyline)
        
        let diff = lastlocation.distanceFromLocation(firstlocation)
        
        let region =  MKCoordinateRegionMakeWithDistance(firstlocation.coordinate, diff, diff)
        
        map.setRegion(region, animated: true)
    }
    
    func fetchRoute(){
        
        
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
            
            
            directions.calculateDirectionsWithCompletionHandler ({
                (response: MKDirectionsResponse?, error: NSError?) in
                if error == nil {
                    let route = response!.routes[0] as MKRoute
                    self.map.addOverlay(route.polyline, level: MKOverlayLevel.AboveRoads)
                }
                else
                {
                    print(error?.description)
                }
            })
            
        }
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blueColor()
        renderer.lineWidth = 5.0
        
        
        return renderer
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
