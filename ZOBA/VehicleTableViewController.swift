//
//  VehicleTableViewController.swift
//  ZOBA
//
//  Created by Angel mas on 6/14/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class VehicleTableViewController: UITableViewController {
    
    var vehicles : [Vehicle]!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let dao = AbstractDao(managedObjectContext: SessionObjects.currentManageContext)
        //MARK: delete 
        vehicles = dao.selectAll(entityName: "Vehicle") as![Vehicle]
        //                self.vehicles = SessionObjects.currentUser.vehicle?.allObjects as! [Vehicle]
        self.tableView.reloadData()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.blueColor()
        self.navigationController?.navigationController?.navigationBar.tintColor = UIColor.blueColor()
        self.navigationController?.navigationBar.backItem?.backBarButtonItem?.tintColor = UIColor.blueColor()
        self.tabBarController?.navigationController?.navigationBar.tintColor = UIColor.blueColor()
        self.tabBarController?.moreNavigationController.navigationBar.tintColor = UIColor.brownColor()
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return vehicles.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("vehicleCell", forIndexPath: indexPath) as! VehicleTableViewCell
        
        let vehicle = vehicles[indexPath.row]
        var modelTrimYear = ""
        
        
        // Configure Image View
        if vehicle.vehicleModel?.model?.make?.image != nil
        {
            cell.vehicleNameInitialsLabel.hidden = true
            cell.makeImageView.image = UIImage(data: (vehicle.vehicleModel?.model?.make?.image)!)
        }
        else
        {
            cell.makeImageView.hidden = true
            
            if vehicle.name != nil
            {
                cell.vehicleNameInitialsLabel.hidden = false
                cell.vehicleNameInitialsLabel.text = String(vehicle.name!.characters.prefix(2))
            }
        }
        
        //Configure Name
        cell.vehicleNameLabel.text = vehicle.name
        
        //Configure Make
        cell.vehicleMakeLabel.text = vehicle.vehicleModel?.model?.make?.name != nil ? vehicle.vehicleModel?.model?.make?.name : ""
        
        //Configure Model Year Trim
        modelTrimYear = vehicle.vehicleModel?.model?.name != nil ? (vehicle.vehicleModel?.model?.name)!+" " : ""
        modelTrimYear += vehicle.vehicleModel?.trim?.name != nil ? (vehicle.vehicleModel?.trim?.name)!+" " : " "
        modelTrimYear += vehicle.vehicleModel?.year?.name?.stringValue != nil ? (vehicle.vehicleModel?.year?.name?.stringValue)!+" " : " "
        cell.modelTrimYearLabel.text = modelTrimYear != "" ? modelTrimYear : "N/A"
        
        //Configure Initial Odemter
        
        cell.initialOdemeterLabel.text = vehicle.initialOdemeter?.stringValue != nil ? vehicle.initialOdemeter?.stringValue : "Not Available"
        
        //Configure Current Odemter
        cell.currentOdemeterLabel.text = vehicle.currentOdemeter?.stringValue != nil ? vehicle.currentOdemeter?.stringValue : "Not Available"
        
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let vehicle = vehicles[indexPath.row]
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("vehicleDetail") as! vehicleDetailsViewController
        controller.vehicle = vehicle
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            deleteAlert(indexPath)
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    func deleteAlert(indexPath : NSIndexPath){
        
        let alert  = UIAlertController(title: "Deleting A Trip", message: "Trips are your car memory, Are you sure you want to delete it?", preferredStyle: .Alert)
        let deleteAction = UIAlertAction(title: "Delete ", style: .Destructive, handler: { (action) in
            
            
            self.tableView.beginUpdates()
            let vehicleName = self.vehicles[indexPath.row].name
            
            
            
            self.vehicles[indexPath.row].delete()
            
            self.vehicles = SessionObjects.currentUser.vehicle?.allObjects as! [Vehicle]

            
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            print(SessionObjects.currentVehicle.name)
            
            if Defaults[.curentVehicleName] == vehicleName
            {
                print(self.vehicles!.count)
                if self.vehicles != nil && self.vehicles.count > 0
                {
                    SessionObjects.currentVehicle = self.vehicles.first
                    Defaults[.curentVehicleName] = self.vehicles[0].name
                }
                else
                {
                    SessionObjects.currentVehicle = nil
                    Defaults[.curentVehicleName] = nil
                }
            }
            self.tableView.endUpdates()
            self.tableView.reloadData()
            
        })
        
        let cancel = UIAlertAction(title: "cancel", style: .Cancel, handler: { (action) in
            print("user canceled")
        })
        
        alert.addAction(deleteAction)
        alert.addAction(cancel)
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    
    func showStopAlert(){
        let alert = UIAlertController(title: "Zoba", message: "you have stopped  ", preferredStyle: .Alert)
        
        let activateAutoReport = UIAlertAction(title: "ok", style:.Default) { (action) in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }
        
        
        
        alert.addAction(activateAutoReport)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func openSideMenu()
    {
        self.slideMenuController()?.openLeft()
        print("hello")
    }
    
}