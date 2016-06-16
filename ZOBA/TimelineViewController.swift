//
//  TimelineViewController.swift
//  ZOBA
//
//  Created by RE Pixels on 6/5/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import UIKit
import BTNavigationDropdownMenu
import ChameleonFramework
import SwiftyUserDefaults
import CoreLocation
import FoldingTabBar

class TimelineViewController: UITableViewController , YALTabBarViewDelegate , YALTabBarInteracting {
    var menuView: BTNavigationDropdownMenu!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 70, 0)
        self.edgesForExtendedLayout = UIRectEdge.None
        self.extendedLayoutIncludesOpaqueBars = false
        self.automaticallyAdjustsScrollViewInsets = false
        
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName : UIFont(name: "Continuum Medium", size: 22)! ,NSForegroundColorAttributeName: UIColor.whiteColor() ]

        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let dao = AbstractDao(managedObjectContext: SessionObjects.currentManageContext)
        let vehicles = dao.selectAll(entityName: "Vehicle") as! [Vehicle]
        
        var items :[String] = [String]()//= ["Car one","car two","car two","car two" ,"Add Vehicles"]
        vehicles.forEach { (vehicle) in
            items.append(vehicle.name!)
        }
        
        
        var menuTitle : String = "Add vehicle"
        if SessionObjects.currentVehicle != nil{
            let selectedVehicle : Vehicle =   SessionObjects.currentVehicle
            menuTitle = selectedVehicle.name!
            
        }else {
            //            items.append(menuTitle)
            
            print("no car selected in time lline")
        }
        items.append("Add vehicle")
        
        menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, title: menuTitle, items: items)
        menuView.cellHeight = 40
        menuView.cellBackgroundColor = UIColor.flatWhiteColor()
        menuView.cellSelectionColor = UIColor.flatSandColor()
        menuView.keepSelectedCellColor = true
        menuView.cellTextLabelColor = UIColor.flatWatermelonColor()
        menuView.cellTextLabelFont = UIFont(name: "Continuum Medium", size: 20)
        
        
        menuView.cellTextLabelAlignment = .Center // .Center // .Right // .Left
        
        menuView.arrowPadding = 10
        
        menuView.animationDuration = 0.5
        menuView.maskBackgroundColor = UIColor.blackColor()
        menuView.maskBackgroundOpacity = 0.3
        menuView.checkMarkImage = nil
        
        menuView.checkMarkImage = UIImage(named: "plus_icon")
        
        menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> () in
            
            let itemCount = items.count - 1
            
            if indexPath == itemCount {
                
                let story = UIStoryboard.init(name: "Vehicle", bundle: nil)
                let controller = story.instantiateViewControllerWithIdentifier("addVehicle") as! AddVehicleTableViewController
                
                self.navigationController!.pushViewController(controller, animated: true)
            }else{
                print(" out ")
                
                SessionObjects.currentVehicle = vehicles[indexPath]
                Defaults[.curentVehicleName] = SessionObjects.currentVehicle.name
                
                
            }
            //self.selectedCellLabel.text = items[indexPath]
        }
        
        
        self.navigationItem.titleView = menuView
        
        isLocationEnabled()
        isNotificationsEnabled()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200 ;
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0;
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if (indexPath.row % 2 == 0 ){
            
            let cell = tableView.dequeueReusableCellWithIdentifier(DaySummaryCell.identifier, forIndexPath: indexPath) as! DaySummaryCell
            
            cell.currentOdemeter?.text = "1000 "
            cell.date!.text = "9"
            return cell
        }
        else if (indexPath.row % 3 == 0 ){
            let cell = tableView.dequeueReusableCellWithIdentifier(TripCell.identifier, forIndexPath: indexPath) as! TripCell
            
            cell.initialOdemeter!.text = "1000 "
            cell.distanceCovered!.text = "20 km"
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCellWithIdentifier(FuelCell.identifier, forIndexPath: indexPath) as! FuelCell
            cell.fuelAmount!.text = "50 Litters"
            cell.serviceProvider?.text = "fuel service"
            return cell
            
        }
    }
    
    
    func isLocationEnabled()
    {
        if CLLocationManager.authorizationStatus() != .AuthorizedAlways {
            
            
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    func isNotificationsEnabled()
    {
        let application = UIApplication.sharedApplication()
        
        let notificationTypes: UIUserNotificationType = [UIUserNotificationType.Alert, UIUserNotificationType.Badge, UIUserNotificationType.Sound]
        
        if(application.isRegisteredForRemoteNotifications() == false)
        {
            let pushNotificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: nil)
            application.registerUserNotificationSettings(pushNotificationSettings)
            application.registerForRemoteNotifications()
            if((Defaults[.deviceToken]) != nil)
            {
                SessionObjects.currentUser.deviceToken = Defaults[.deviceToken]!
            }
        }
    }
    
    
    @IBAction func menuButtonClicked(sender: AnyObject) {
        self.slideMenuController()?.openLeft()
    }
    
        func extraLeftItemDidPressInTabBarView(tabBarView: YALFoldingTabBar!) {
    //        let vehiclesStoryBoard =  UIStoryboard(name: "Vehicle", bundle: nil)
    //        let vehicleNavigationController =
    //            vehiclesStoryBoard.instantiateViewControllerWithIdentifier("VehicleNavigation")
    //        vehicleNavigationController.tabBarController?.view = self.tabBarView
    //        self.showViewController(vehicleNavigationController, sender: self)
//            performSegueWithIdentifier("Vehicle Segue", sender: self)
            print("Pressed")
        }

    func extraRightItemDidPressInTabBarView(tabBarView: YALFoldingTabBar!) {
        print("Yemeen")
    }
    func extraLeftItemDidPress() {
//        performSegueWithIdentifier("Vehicle Segue", sender: self)
        let vehiclesStoryBoard =  UIStoryboard(name: "Vehicle", bundle: nil)
        let vehicleNavigationController = vehiclesStoryBoard.instantiateViewControllerWithIdentifier("vehicleTable")
        self.navigationController?.pushViewController(vehicleNavigationController, animated: true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     //        
     //        if condition {
     //            <#code#>
     //        }
     }
     */
    
}
//        cell.checkmarkIcon.hidden = (indexPath.row == selectedIndexPath) ? false : true
//if self.configuration.keepSelectedCellColor == true {
//    cell.contentView.backgroundColor = (selectedIndexPath != nil && indexPath.row == selectedIndexPath) ? self.configuration.cellSelectionColor : self.configuration.cellBackgroundColor
//}
//