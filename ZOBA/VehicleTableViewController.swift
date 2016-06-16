//
//  VehicleTableViewController.swift
//  ZOBA
//
//  Created by Angel mas on 6/14/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import UIKit

class VehicleTableViewController: UITableViewController , MapDetectionDelegate {
    
    var vehicles : [Vehicle]!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SessionObjects.motionMonitor = LocationMonitor(delegate: self)
        SessionObjects.motionMonitor.stopTrip()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let dao = AbstractDao(managedObjectContext: SessionObjects.currentManageContext)
        //MARK: delete 
        vehicles = dao.selectAll(entityName: "Vehicle") as![Vehicle]
        //                self.vehicles = SessionObjects.currentUser.vehicle?.allObjects as! [Vehicle]
        self.tableView.reloadData()
        
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
        let cell = tableView.dequeueReusableCellWithIdentifier("vehicleCell", forIndexPath: indexPath)
        cell.textLabel?.text = vehicles[indexPath.row].name
        cell.detailTextLabel?.text = String(vehicles[indexPath.row].currentOdemeter)
        // Configure the cell...
        
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
        
        let alert  = UIAlertController(title: "delete trip", message: "are you sure to delete this trip", preferredStyle: .Alert)
        let deleteAction = UIAlertAction(title: "delete ", style: .Destructive, handler: { (action) in
            
            
            self.tableView.beginUpdates()
            let dao = AbstractDao(managedObjectContext: SessionObjects.currentManageContext)
            let vehicleName = self.vehicles[indexPath.row].name
            
            //      self.trips.removeAtIndex(indexPath.row)
            self.vehicles[indexPath.row].delete()
            //            self.vehicles[indexPath.row].release(SessionObjects.currentManageContext)
            self.vehicles = SessionObjects.currentUser.vehicle?.allObjects as! [Vehicle]
            //            self.vehicles =  dao.selectAll(entityName: "Vehicle") as! [Vehicle]
            
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            if SessionObjects.currentVehicle.name == vehicleName {
                SessionObjects.currentVehicle = self.vehicles.first
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
    
    
    func showAlert(){
        let alert = UIAlertController(title: "Zoba", message: "looks like you are moving  ", preferredStyle: .Alert)
        
        let activateAutoReport = UIAlertAction(title: "Auto report", style:.Default) { (action) in
            print("auto reprt started")
            SessionObjects.motionMonitor.startNewTrip()
            //                        SessionObjects.motionMonitor.startDetection()
            dispatch_async(dispatch_get_main_queue(), { 
                
                let story = UIStoryboard.init(name: "MotionDetection", bundle: nil)
                let controller = story.instantiateInitialViewController()
                
                self.presentViewController(controller!, animated: true, completion: nil)
                
            })
            alert.dismissViewControllerAnimated(true, completion: nil)
        }
        
        let cancel = UIAlertAction(title: "cancel", style: .Cancel, handler: nil)
        
        
        alert.addAction(activateAutoReport)
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
    
}