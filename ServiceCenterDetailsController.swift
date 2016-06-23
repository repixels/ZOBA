//
//  ServiceCenterDetailsController.swift
//  ZOBA
//
//  Created by Angel mas on 6/23/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import UIKit
import MapKit

class ServiceCenterDetailsController: UIViewController {
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var serviceProvider : ServiceProvider!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameInitiallabel: UILabel!
    
    @IBOutlet weak var phoneLabel: UILabel!
    
    
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var landMarkLabel: UILabel!
    
    
    @IBOutlet weak var websiteLabel: UILabel!
    
    @IBOutlet weak var container: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = serviceProvider.name!
        prepareInitials()
        prepareNavigationBar(serviceProvider.name!)
        self.addAnnotation()
        
        let address = serviceProvider.address
        cityLabel.text = address?.city
        streetLabel.text = address?.street
        landMarkLabel.text = address?.landMark
        
       websiteLabel.text =  serviceProvider.webSite
        
        let phone = serviceProvider.phone?.allObjects[0] as! ServiceProviderPhone
        phoneLabel.text = phone.phone
        emailLabel.text = serviceProvider.email
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func prepareInitials(){
        
        var serviceInitial = ""
        if SessionObjects.currentUser.firstName?.characters.first != nil
        {
            serviceInitial.append((SessionObjects.currentUser.firstName?.characters.first)!)
            
            
            if SessionObjects.currentUser.lastName?.characters.first != nil
            {
                
                serviceInitial.append((SessionObjects.currentUser.lastName?.characters.first)!)
            }
            else
            {
                serviceInitial.append((SessionObjects.currentUser.lastName?.characters.last)!)
                
            }
        }
        
        nameInitiallabel.text = serviceInitial.capitalizedString
        
    }
    
    func addAnnotation(){
        
        let annotation = MKPointAnnotation()
        print(serviceProvider.address?.latitude!.doubleValue)
        
        //        serviceProvider.address?.latitude?.doubleValue
//        annotation.coordinate = CLLocationCoordinate2D(latitude: (serviceProvider.address?.latitude!.doubleValue)!, longitude: (serviceProvider.address?.longtiude!.doubleValue)!)
//        
//        map.addAnnotation(annotation)
//        
//        let location = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
//        
//        let region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
//        map.setRegion(region, animated: true)
    }
    
    func prepareNavigationBar(title: String)
    {
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.whiteColor(),
             NSFontAttributeName: UIFont(name: "Continuum Medium", size: 22)!]
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor();
        // self.title = self.contextAwareTitle()
        self.title = title
        self.navigationController?.navigationBar.userInteractionEnabled = true
        
        
    }
    
    
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if segue.identifier == "servicesSegue"
        {
            let controller = segue.destinationViewController as! ServicesTableViewController
            
            controller.serviceProvider = self.serviceProvider
        
        }
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
 
    
}

