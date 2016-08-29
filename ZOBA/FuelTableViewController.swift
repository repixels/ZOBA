//
//  FuelTableViewController.swift
//  ZOBA
//
//  Created by ZOBA on 6/12/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import UIKit

class FuelTableViewController: UITableViewController {
    
    var dao : AbstractDao!
    
    var fuelTrackingData =  [TrackingData]?()
    
    @IBOutlet weak var addDataBTN: UIBarButtonItem!
    override func viewWillAppear(animated: Bool) {
        if SessionObjects.currentVehicle != nil
        {
            addDataBTN.enabled = true
            addDataBTN.tintColor = UIColor.whiteColor()
            fuelTrackingData = [TrackingData]()
            let vehicleName = SessionObjects.currentVehicle.name != nil ? SessionObjects.currentVehicle.name!+" " : ""
            self.prepareNavigationBar(vehicleName + "Fuel")
            
            for trackingData in SessionObjects.currentVehicle.traclingData!.allObjects as! [TrackingData]
            {
                if(trackingData.trackingType!.name == StringConstants.fuelTrackingType)
                {
                    fuelTrackingData!.append(trackingData)
                }
            }
            
            self.tableView.reloadData()
            
        }
        else
        {
            addDataBTN.enabled = false
            addDataBTN.tintColor = UIColor.flatGrayColor()
            self.prepareNavigationBar("No Vehicle Selected")
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
        return fuelTrackingData != nil ? fuelTrackingData!.count : 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("fuelCell", forIndexPath: indexPath) as! FuelTableViewCell
        let serviceProviderName = fuelTrackingData![indexPath.row].serviceProviderName
        
        cell.fuelAmountLabel.text = fuelTrackingData![indexPath.row].value!
        cell.fuelUnitLabel.text = fuelTrackingData![indexPath.row].trackingType!.measuringUnit!.name!
        cell.serviceProviderNameLabel.text = serviceProviderName != nil ? serviceProviderName! : "Not Available"
        cell.startingOdemeterLabel.text = String(fuelTrackingData![indexPath.row].initialOdemeter!)
        cell.dateLabel.text  = String(fuelTrackingData![indexPath.row].dateAdded!)
        // Configure the cell...
            return cell
    }
 

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       
        let detailsView = self.storyboard?.instantiateViewControllerWithIdentifier("details") as! FuelDetailViewController
        
        detailsView.data = fuelTrackingData![indexPath.row]
        
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
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
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
    }
    */
    
    func prepareNavigationBar(title:String)
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
