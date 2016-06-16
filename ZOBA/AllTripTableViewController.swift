//
//  AllTripTableViewController.swift
//  ZOBA
//
//  Created by Angel mas on 6/9/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import UIKit

class AllTripTableViewController: UITableViewController {
    
    var trips : [Trip]!
    
<<<<<<< HEAD
=======
    @IBOutlet weak var addBtn: UIBarButtonItem!
>>>>>>> master
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.whiteColor(),
             NSFontAttributeName: UIFont(name: "Continuum Medium", size: 22)!]
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor();
        
        
<<<<<<< HEAD
        trips = dao.selectAll(entityName: "Trip") as! [Trip]

=======
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
>>>>>>> master
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        let dao = AbstractDao(managedObjectContext: SessionObjects.currentManageContext)
        
        self.navigationController?.title = "Trips"
        self.navigationController?.navigationBar.userInteractionEnabled = true
        
        //        trips = dao.selectAll(entityName: "Trip") as! [Trip]
        var vehicleName = ""
        if SessionObjects.currentVehicle != nil {
            vehicleName =  SessionObjects.currentVehicle.name!
        }
        else{
            addBtn.enabled = false
            addBtn.tintColor = UIColor.grayColor()
        }
        trips = dao.selectByString(entityName: "Trip", AttributeName: "vehicle.name", value: vehicleName) as! [Trip]
        
        
        tableView.reloadData()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        //might be days sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return trips.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("display trip details")
        let trip = trips[indexPath.row]
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("tripDetails") as! TripDetailController
        
        controller.trip = trip
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Trip Cell", forIndexPath: indexPath) as! TripTableViewCell
        
        cell.coveredMilageLabel.text = trips[indexPath.row].coveredKm.stringValue
        let coordinates = trips[indexPath.row].coordinates!.allObjects as![TripCoordinate]
        let first = coordinates.first //as! TripCoordinate
        print(first!.latitude)
        cell.endingLocationLabel.text = String(coordinates.last?.latitude!)
        cell.startingLocationLabel.text = String(coordinates.first?.latitude!)
        
        return cell
    }
    
    
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // delete only first trip
        if indexPath.row == 0
        {
            return true
        }
        else {
            return false
        }
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
            
            
            //      self.trips.removeAtIndex(indexPath.row)
            self.trips[indexPath.row].delete()
            self.trips[indexPath.row].release(SessionObjects.currentManageContext)
            self.trips = dao.selectByString(entityName: "Trip", AttributeName: "vehicle.name", value: SessionObjects.currentVehicle.name!) as! [Trip]
            
            //remove object from data base
            //trips[indexPath.row].delete()
            
            
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
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
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    
    
}
