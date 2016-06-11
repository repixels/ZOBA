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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let dao = AbstractDao(managedObjectContext: moc)
        
        trips = dao.selectAll(entityName: "Trip") as! [Trip]
        
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
        //        let tripCoordinate = TripCoordinate(unmanagedEntity: "TripCoordinate")
        //        tripCoordinate.latitude = 29.9792
        //        tripCoordinate.longtitude = 31.1342
        //        
        //        let tripCoordinate2 = TripCoordinate(unmanagedEntity: "TripCoordinate")
        //        tripCoordinate2.latitude = 29.9791
        //        tripCoordinate2.longtitude = 31.1352
        //        
        //        trip.coordinates = NSSet(array: [tripCoordinate , tripCoordinate2])
        //        
        
        controller.trip = trip
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tripDetail", forIndexPath: indexPath)
        
        cell.textLabel!.text = "initial Odemeter \( trips[indexPath.row].initialOdemeter)"
        cell.detailTextLabel?.text = "covered km  \( trips[indexPath.row].coveredKm)"
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
            let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
            let dao = AbstractDao(managedObjectContext: moc)
            
            
            //      self.trips.removeAtIndex(indexPath.row)
            self.trips[indexPath.row].delete()
            self.trips[indexPath.row].release(moc)
            self.trips = dao.selectAll(entityName: "Trip") as! [Trip]
            
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
