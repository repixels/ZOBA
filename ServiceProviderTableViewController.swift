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
        
        prepareNavigationBar("Service Providers")
        
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
            if SessionObjects.currentVehicle != nil {
            if (make as! Make).name == SessionObjects.currentVehicle.vehicleModel?.model?.make?.name
            {
                cell.supportBtn.backgroundColor = UIColor.flatGreenColor()
                cell.supportBtn.setTitle("supports your car", forState: .Normal)
            }
            else {
                
                
                cell.supportBtn.backgroundColor = UIColor.flatRedColor()
                cell.supportBtn.setTitle("doesn't support your car", forState: .Normal)
               }
            }
            else {
            
                
                cell.supportBtn.backgroundColor = UIColor.flatGrayColor()
                cell.supportBtn.setTitle("you have no car", forState: .Normal)
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
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("serviceProviderDetails") as! ServiceCenterDetailsController
        
        controller.serviceProvider = serviceProviders[indexPath.row]
        
        self.navigationController?.pushViewController(controller, animated: true)
        
        
    }
    
    func prepareNavigationBar(title: String)
    {
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.whiteColor(),
             NSFontAttributeName: UIFont(name: "Continuum Medium", size: 22)!]
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor();
        // self.title = self.contextAwareTitle()
        self.title = title
        self.navigationController?.navigationBar.userInteractionEnabled = true
        
        
    }
    
    func contextAwareTitle() -> String?
    {
        let now = NSDate()
        let cal = NSCalendar.currentCalendar()
        let comps = cal.component(NSCalendarUnit.Hour, fromDate: now)
        
        switch comps {
        case 0 ... 12:
            return "Good Morning"
        case 13 ... 17:
            return "Good Afternoon"
        case 18 ... 23:
            return "Good Evening"
        default:
            return "Welcome Back"
        }
    }
    
    @IBAction func menuButtonClicked(sender: AnyObject) {
        self.slideMenuController()?.openLeft()
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
