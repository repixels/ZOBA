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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return serviceProviders.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "serviceCell", for: indexPath) as! ServiceProviderCell
        
        cell.name.text = serviceProviders[(indexPath as NSIndexPath).row].name
        let address = serviceProviders[(indexPath as NSIndexPath).row].address
        
        if address != nil {
            cell.address.text = address!.street! + " , " + address!.city!
        }
        
        let serviceMakes  = serviceProviders[(indexPath as NSIndexPath).row].make
        
        serviceMakes?.forEach({ (make ) in
            if SessionObjects.currentVehicle != nil {
            if (make as! Make).name == SessionObjects.currentVehicle.vehicleModel?.model?.make?.name
            {
                cell.supportBtn.backgroundColor = UIColor.flatGreen()
                cell.supportBtn.setTitle("supports your car", for: UIControlState())
            }
            else {
                
                
                cell.supportBtn.backgroundColor = UIColor.flatRed()
                cell.supportBtn.setTitle("doesn't support your car", for: UIControlState())
               }
            }
            else {
            
                
                cell.supportBtn.backgroundColor = UIColor.flatGray()
                cell.supportBtn.setTitle("you have no car", for: UIControlState())
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
        
        cell.nameInitial.text = serviceInitial.capitalized
        
        // Configure the cell...
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "serviceProviderDetails") as! ServiceCenterDetailsController
        
        controller.serviceProvider = serviceProviders[(indexPath as NSIndexPath).row]
        
        self.navigationController?.pushViewController(controller, animated: true)
        
        
    }
    
    func prepareNavigationBar(_ title: String)
    {
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.white,
             NSFontAttributeName: UIFont(name: "Continuum Medium", size: 22)!]
        self.navigationController!.navigationBar.tintColor = UIColor.white;
        // self.title = self.contextAwareTitle()
        self.title = title
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
        
        
    }
    
    func contextAwareTitle() -> String?
    {
        let now = Date()
        let cal = Calendar.current
        let comps = (cal as NSCalendar).component(NSCalendar.Unit.hour, from: now)
        
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
    
    @IBAction func menuButtonClicked(_ sender: AnyObject) {
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
