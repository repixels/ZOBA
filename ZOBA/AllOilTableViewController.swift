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
    
    var oilTrackingData: [TrackingData]!
    
    var ArraysortedByDate : [TrackingData]!
    
    @IBOutlet weak var addDataBTN: UIBarButtonItem!
    
    override func viewWillAppear(_ animated: Bool) {
        if SessionObjects.currentVehicle != nil
        {
            addDataBTN.isEnabled = true
            addDataBTN.tintColor = UIColor.white
            oilTrackingData = [TrackingData]()
            let vehicleName = SessionObjects.currentVehicle.name != nil ? SessionObjects.currentVehicle.name!+" " : ""
            self.prepareNavigationBar(title: vehicleName + "Oil")
            for trackingData in SessionObjects.currentVehicle.traclingData!.allObjects as! [TrackingData]
            {
                if(trackingData.trackingType!.name == StringConstants.oilTrackingType)
                {
                    oilTrackingData!.append(trackingData)
                }
            }
            self.tableView.reloadData()
        }
        else
        {
            addDataBTN.isEnabled = false
            addDataBTN.tintColor = UIColor.flatGray()
            self.prepareNavigationBar(title: "No Car Selected")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return oilTrackingData != nil ? oilTrackingData.count : 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "oilCell", for: indexPath) as! OilTableViewCell
        
        // Configure the cell...
        
       // compare()NSComparisonResult.OrderedAscending
        
        let serviceProviderName = oilTrackingData![indexPath.row].serviceProviderName
        
        cell.oilAmountLabel.text = oilTrackingData![indexPath.row].value!
        cell.oilMesuringUnitLabel.text = oilTrackingData![indexPath.row].trackingType!.measuringUnit!.name!
        cell.serviceProvideLabel.text = serviceProviderName != nil ? serviceProviderName! : "Not Available"
        cell.startingOdemeterLabel.text = String(describing: oilTrackingData![indexPath.row].initialOdemeter!)
        cell.dateLabel.text  = String(describing: oilTrackingData![indexPath.row].dateAdded!)

        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailsView = self.storyboard?.instantiateViewController(withIdentifier: "details") as! OilDetailsViewController

         detailsView.data = oilTrackingData[indexPath.row]
        
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
            [NSForegroundColorAttributeName: UIColor.white,
             NSFontAttributeName: UIFont(name: "Continuum Medium", size: 22)!]
        self.navigationController!.navigationBar.tintColor = UIColor.white
        self.title = title
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
    }
    
    @IBAction func menuButtonClicked(_ sender: AnyObject) {
        self.slideMenuController()?.openLeft()
    }
    
}
