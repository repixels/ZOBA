//
//  AllOilTableViewController.swift
//  ZOBA
//
//  Created by ZOBA on 6/11/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import UIKit

class AllOilTableViewController: UITableViewController {
    
    var dao : AbstractDao!
    
    var data: [TrackingData]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        
         dao = AbstractDao(managedObjectContext: appDel.managedObjectContext)
       // data = dao.selectAll(entityName: "TrackingData") as! [TrackingData]
        data = dao.selectByString(entityName: "TrackingData", AttributeName: "trackingType.name", value: "oil") as![TrackingData]
        
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
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        // Configure the cell...
        
        
        cell.textLabel?.text = String(data[indexPath.row].initialOdemeter)
        cell.detailTextLabel?.text = data[indexPath.row].value
        
        return cell
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
