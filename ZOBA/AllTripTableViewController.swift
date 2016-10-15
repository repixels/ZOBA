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
    
    @IBOutlet weak var addBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        if SessionObjects.currentVehicle != nil
        {   
            var vehicleName = ""
            vehicleName =  SessionObjects.currentVehicle.name!
            self.prepareNavigationBar(title: vehicleName+" Trips")
            trips = SessionObjects.currentVehicle.trip?.allObjects as! [Trip]
            addBtn.isEnabled = true
            addBtn.tintColor = UIColor.white
            self.view.reloadInputViews()
            tableView.reloadData()
        }
        else
        {
            addBtn.isEnabled = false
            addBtn.tintColor = UIColor.gray
            self.prepareNavigationBar(title: "No Trips Available")
        }
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        //might be days sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return trips != nil ? trips.count : 0
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let trip = trips[indexPath.row]
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "tripDetails") as! TripDetailController
        
        controller.trip = trip
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Trip Cell", for: indexPath) as! TripTableViewCell
        
        cell.coveredMilageLabel.text = trips[indexPath.row].coveredKm!.stringValue
        let coordinates = trips[indexPath.row].coordinates!.allObjects as![TripCoordinate]
        if coordinates.count > 0 {
            cell.endingLocationLabel.text = coordinates.last!.address != nil ? coordinates.last!.address : "Not Available"
            cell.startingLocationLabel.text = coordinates.first!.address != nil ? coordinates.first!.address : "Not Available"
        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // delete only first trip
        if indexPath.row == 0
        {
            return true
        }
        else {
            return false
        }
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            deleteAlert(indexPath: indexPath)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    func deleteAlert(indexPath : IndexPath){
        
        let alert  = UIAlertController(title: "delete trip", message: "are you sure to delete this trip", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "delete ", style: .destructive, handler: { (action) in
            
            self.tableView.beginUpdates()
            let dao = AbstractDao(managedObjectContext: SessionObjects.currentManageContext)
            
            
            //      self.trips.removeAtIndex(indexPath.row)
            self.trips[indexPath.row].delete()
            self.trips[indexPath.row].release(managedObjectContext: SessionObjects.currentManageContext)
            self.trips = dao.selectByString(entityName: "Trip", AttributeName: "vehicle.name", value: SessionObjects.currentVehicle.name!) as! [Trip]
            
            //remove object from data base
            //trips[indexPath.row].delete()
            
            
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            
            self.tableView.endUpdates()
            self.tableView.reloadData()
            
        })
        
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        
        alert.addAction(deleteAction)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
        
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
    func prepareNavigationBar(title: String)
    {
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.white,
             NSFontAttributeName: UIFont(name: "Continuum Medium", size: 22)!]
        self.navigationController!.navigationBar.tintColor = UIColor.white;
        self.title = title
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
    }
    
    @IBAction func menuButtonClicked(_ sender: AnyObject) {
        self.slideMenuController()?.openLeft()
    }
    
    
}
