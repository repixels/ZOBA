//
//  AllOilTableViewController.swift
//  ZOBA
//
//  Created by ZOBA on 6/11/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import UIKit
import Foundation

class AllOilTableViewController: UITableViewController {
    
    var dao : AbstractDao!
    
    var data: [TrackingData]!
    
    var ArraysortedByDate : [TrackingData]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        
         dao = AbstractDao(managedObjectContext: appDel.managedObjectContext)
        data = dao.selectByInt(entityName: "TrackingData", AttributeName: "trackingType.typeId", value: 2) as![TrackingData]
        
       // data.sort({$0.dateAdded > $1.dateAdded})
        
       data.sortInPlace({$0.dateAdded!.compare($1.dateAdded!) == .OrderedDescending})
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
        return data.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("oilCell", forIndexPath: indexPath) as! OilTableViewCell
        
        // Configure the cell...
        
        cell.dateLabel.text = String(data[indexPath.row].dateAdded!)
        cell.oilAmountLabel.text = data[indexPath.row].value!
        cell.oilMesuringUnitLabel.text = "Liters"
        cell.startingOdemeterLabel.text = String(data[indexPath.row].initialOdemeter)
        cell.serviceProvideLabel.text = data[indexPath.row].serviceProviderName
        
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
     
        let detailsView = self.storyboard?.instantiateViewControllerWithIdentifier("details") as! OilDetailsViewController

         detailsView.data = data[indexPath.row]
        
        self.navigationController?.pushViewController(detailsView, animated: true)

    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
   /*
    
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        
      //  data = dao.selectByInt(entityName: "", AttributeName: <#T##String#>, value: indexPath)
     }
     //    else if editingStyle == .Insert {
     //     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     //     }    
     }
     
 */
    
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
    /*
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        
        if segue.identifier == "oilSegue" {
            
        }
     }
 */
    
}
