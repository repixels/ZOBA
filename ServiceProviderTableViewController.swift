//
//  ServiceProviderTableViewController.swift
//  ZOBA
//
//  Created by Angel mas on 6/23/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import UIKit
import TextFieldEffects

class ServiceProviderTableViewController: UITableViewController {
    
    var serviceProviders : [ServiceProvider] = [ServiceProvider]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dao = AbstractDao(managedObjectContext: SessionObjects.currentManageContext)
        serviceProviders = dao.selectAll(entityName: "ServiceProvider") as! [ServiceProvider]
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return serviceProviders.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("serviceCell", forIndexPath: indexPath) as! ServiceProviderCell
        
        cell.name.text = serviceProviders[indexPath.row].name
        let address = serviceProviders[indexPath.row].address
        
        if address != nil {
            cell.address.text = address!.street! + " , " + address!.city!
        }
        
        let serviceMakes  = serviceProviders[indexPath.row].make
        
        serviceMakes?.forEach({ (make ) in
            if (make as! Make).name == SessionObjects.currentVehicle.vehicleModel?.model?.make?.name
            {
                cell.supportBtn.backgroundColor = UIColor.flatGreenColor()
                cell.supportBtn.setTitle("supports your car", forState: .Normal)
            }
            else {
                
                
                cell.supportBtn.backgroundColor = UIColor.flatRedColor()
                cell.supportBtn.setTitle("doesn't support your car", forState: .Normal)
            }
        })
        
        
        var serviceInitial = ""
        if SessionObjects.currentUser.firstName?.characters.first != nil
        {
            serviceInitial.append((SessionObjects.currentUser.firstName?.characters.first)!)
            
            
            if SessionObjects.currentUser.lastName?.characters.first != nil
            {
                
                serviceInitial.append((SessionObjects.currentUser.lastName?.characters.first)!)
            }
            else
            {
                serviceInitial.append((SessionObjects.currentUser.lastName?.characters.last)!)
                
            }
        }
        
        cell.nameInitial.text = serviceInitial.capitalizedString
        
        // Configure the cell...
        
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
    
}
