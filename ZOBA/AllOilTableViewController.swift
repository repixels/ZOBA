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
        
        
        if SessionObjects.currentVehicle != nil
        {
            let vehicleName = SessionObjects.currentVehicle.name != nil ? SessionObjects.currentVehicle.name!+" " : ""
            self.prepareNavigationBar(vehicleName + "Oil")
            dao = AbstractDao(managedObjectContext: SessionObjects.currentManageContext)
            data = dao.selectByString(entityName: "TrackingData", AttributeName: "trackingType.name", value: "oil") as![TrackingData]
            self.tableView.reloadData()
        }
        else
        {
            self.prepareNavigationBar("No Car Selected")
        }
        
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
        
       // compare()NSComparisonResult.OrderedAscending
        
        cell.dateLabel.text = String(data[indexPath.row].dateAdded)
        cell.oilAmountLabel.text = data[indexPath.row].value
        cell.oilMesuringUnitLabel.text = "Liters"
        cell.startingOdemeterLabel.text = String(data[indexPath.row].initialOdemeter)

        
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
    
    func prepareNavigationBar(title: String)
    {
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.whiteColor(),
             NSFontAttributeName: UIFont(name: "Continuum Medium", size: 22)!]
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor();
        self.title = title
        self.navigationController?.navigationBar.userInteractionEnabled = true
    }
    
    @IBAction func menuButtonClicked(sender: AnyObject) {
        self.slideMenuController()?.openLeft()
    }
    
}
