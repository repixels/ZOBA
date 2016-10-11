//
//  TimelineViewController.swift
//  ZOBA
//
//  Created by RE Pixels on 6/5/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import UIKit
//import BTNavigationDropdownMenu
import ChameleonFramework
import SwiftyUserDefaults
import CoreLocation
import FoldingTabBar

class TimelineViewController: UITableViewController , YALTabBarViewDelegate , YALTabBarInteracting {
    var menuView: BTNavigationDropdownMenu!
    let locationManager = CLLocationManager()
    var timelinePopulater : TimelinePopulater?
    
    var tableCells : [TimeLineCell] = [TimeLineCell]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationBar()
        isLocationEnabled()
        isNotificationsEnabled()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadUserVehiclesDropDown()
        
        
        
        
        if SessionObjects.currentVehicle != nil {
            timelinePopulater = TimelinePopulater(tableView: self.tableView)
            tableCells = (timelinePopulater?.populateTableData())!
            if SessionObjects.motionMonitor == nil {
            SessionObjects.motionMonitor = LocationMonitor()
            }
            SessionObjects.motionMonitor.startDetection()
            
        }
        else {
           // SessionObjects.motionMonitor = LocationMonitor()
            if SessionObjects.motionMonitor != nil {
            SessionObjects.motionMonitor.stopDetection()
            }
        }
        
        self.tableView.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200 ;
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (tableCells.count)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableCells[indexPath.row] as? TripCell
        {
            return cell
        }
        else if let cell = tableCells[indexPath.row] as? FuelCell
        {
            return cell
        }
        else if let cell = tableCells[indexPath.row] as? OilCell
        {
            
            return cell
        }
        else if let cell = tableCells[indexPath.row] as? DaySummaryCell
        {
            return cell
        }
        else
        {
            return UITableViewCell()
        }
        
    }
    
    
    func isLocationEnabled()
    {
        if CLLocationManager.authorizationStatus() != .authorizedAlways {
            
            
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    func isNotificationsEnabled()
    {
        let application = UIApplication.shared
        
        let notificationTypes: UIUserNotificationType = [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound]
        
        if(application.isRegisteredForRemoteNotifications == false)
        {
            
            let pushNotificationSettings = UIUserNotificationSettings(types: notificationTypes, categories: nil)
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
        menuView.animationDuration = 0
        menuView.hide()
    }
    
    func extraRightItemDidPress() {
        
        let MotionDetectionStoryBoard =  UIStoryboard(name: "MotionDetection", bundle: nil)
        let MotionNavigationController = MotionDetectionStoryBoard.instantiateViewController(withIdentifier: "autoReporting") as! MotionDetecionMapController
        self.navigationController?.pushViewController(MotionNavigationController, animated: true)
    }
    
    func extraLeftItemDidPress() {
        
        let vehiclesStoryBoard =  UIStoryboard(name: "Vehicle", bundle: nil)
        let vehicleNavigationController = vehiclesStoryBoard.instantiateViewController(withIdentifier: "vehicleTable")
        self.navigationController?.pushViewController(vehicleNavigationController, animated: true)
    }
    
    func prepareNavigationBar()
    {
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 70, 0)
        self.edgesForExtendedLayout = UIRectEdge.None
        self.extendedLayoutIncludesOpaqueBars = false
        self.automaticallyAdjustsScrollViewInsets = false
        
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName : UIFont(name: "Continuum Medium", size: 22)! ,NSForegroundColorAttributeName: UIColor.white ]
    }
    
    func loadUserVehiclesDropDown()
    {
        let dao = AbstractDao(managedObjectContext: SessionObjects.currentManageContext)
        let vehicles = dao.selectAll(entityName: "Vehicle") as! [Vehicle]
        
        var items :[String] = [String]()
        
        vehicles.forEach { (vehicle) in
            items.append(vehicle.name!)
        }
        
        
        var menuTitle : String = "Add vehicle"
        if SessionObjects.currentVehicle != nil
        {
            let selectedVehicle : Vehicle =   SessionObjects.currentVehicle
            menuTitle = selectedVehicle.name!
            
        }
        items.append("Add vehicle")
        
        menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, title: menuTitle, items: items as [AnyObject])
        menuView.cellHeight = 40
        menuView.cellBackgroundColor = UIColor.flatWhite()
        menuView.cellSelectionColor = UIColor.flatSand()
        menuView.keepSelectedCellColor = true
        menuView.cellTextLabelColor = UIColor.flatWatermelon()
        menuView.cellTextLabelFont = UIFont(name: "Continuum Medium", size: 20)
        
        
        menuView.cellTextLabelAlignment = .center // .Center // .Right // .Left
        
        menuView.arrowPadding = 10
        
        menuView.animationDuration = 0.5
        menuView.maskBackgroundColor = UIColor.black
        menuView.maskBackgroundOpacity = 0.3
        menuView.checkMarkImage = nil
        
        //  menuView.checkMarkImage = UIImage(named: "plus_icon")
        
        
        menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> () in
            
            
            
            let itemCount = items.count - 1
            
            if indexPath == itemCount
            {
                let story = UIStoryboard.init(name: "Vehicle", bundle: nil)
                let controller = story.instantiateViewController(withIdentifier: "Add Vehicle") as! AddVehicleTableViewController
                self.navigationController!.pushViewController(controller, animated: true)
            }
            else
            {
                SessionObjects.currentVehicle = vehicles[indexPath]
                Defaults[.curentVehicleName] = SessionObjects.currentVehicle.name
                if self.timelinePopulater == nil {
                    self.timelinePopulater = TimelinePopulater(tableView: self.tableView)
                }
                self.tableCells = self.timelinePopulater!.populateTableData()
                self.tableView.reloadData()
            }
        }
        
        
        self.navigationItem.titleView = menuView
        
        
        
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
