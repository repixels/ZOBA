//
//  VehicleTableViewController.swift
//  ZOBA
//
//  Created by Angel mas on 6/14/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class VehicleTableViewController: UITableViewController {
    
    var vehicles : [Vehicle]!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if SessionObjects.currentUser != nil && (SessionObjects.currentUser.vehicle?.count)! > 0 {
            self.vehicles = SessionObjects.currentUser.vehicle?.allObjects as! [Vehicle]
            self.tableView.reloadData()
        }
        else {
            
            self.vehicles = [Vehicle]()
        }
        
        self.navigationController?.navigationBar.barTintColor = UIColor.blue
        self.navigationController?.navigationController?.navigationBar.tintColor = UIColor.blue
        self.navigationController?.navigationBar.backItem?.backBarButtonItem?.tintColor = UIColor.blue
        self.tabBarController?.navigationController?.navigationBar.tintColor = UIColor.blue
        self.tabBarController?.moreNavigationController.navigationBar.tintColor = UIColor.brown
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return vehicles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "vehicleCell", for: indexPath) as! VehicleTableViewCell
        
        let vehicle = vehicles[indexPath.row]
        var modelTrimYear = ""
        
        
        // Configure Image View
        if vehicle.vehicleModel?.model?.make?.image != nil
        {
            cell.vehicleNameInitialsLabel.isHidden = true
            cell.makeImageView.image = UIImage(data: (vehicle.vehicleModel?.model?.make?.image)! as Data)
        }
        else
        {
            cell.makeImageView.isHidden = true
            
            if vehicle.name != nil
            {
                cell.vehicleNameInitialsLabel.isHidden = false
                cell.vehicleNameInitialsLabel.text = String(vehicle.name!.characters.prefix(2)).uppercased()
            }
        }
        
        //Configure Name
        cell.vehicleNameLabel.text = vehicle.name
        
        //Configure Make
        cell.vehicleMakeLabel.text = vehicle.vehicleModel?.model?.make?.name != nil ? vehicle.vehicleModel?.model?.make?.name : ""
        
        //Configure Model Year Trim
        modelTrimYear = vehicle.vehicleModel?.model?.name != nil ? (vehicle.vehicleModel?.model?.name)!+" " : ""
        modelTrimYear += vehicle.vehicleModel?.trim?.name != nil ? (vehicle.vehicleModel?.trim?.name)!+" " : " "
        modelTrimYear += vehicle.vehicleModel?.year?.name?.stringValue != nil ? (vehicle.vehicleModel?.year?.name?.stringValue)!+" " : " "
        cell.modelTrimYearLabel.text = modelTrimYear != "" ? modelTrimYear : "N/A"
        
        //Configure Initial Odemter
        
        cell.initialOdemeterLabel.text = vehicle.initialOdemeter?.stringValue != nil ? vehicle.initialOdemeter?.stringValue : "Not Available"
        
        //Configure Current Odemter
        cell.currentOdemeterLabel.text = vehicle.currentOdemeter?.stringValue != nil ? vehicle.currentOdemeter?.stringValue : "Not Available"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vehicle = vehicles[indexPath.row]
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "vehicleDetail") as! vehicleDetailsViewController
        controller.vehicle = vehicle
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            deleteAlert(indexPath: indexPath )
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    func deleteAlert(indexPath : IndexPath){
        
        let vehicleName = self.vehicles[indexPath.row].name
        let alert  = UIAlertController(title: "Deleting A Trip", message: "We love " + vehicleName! + ", Are you sure you want to delete it?", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Delete ", style: .destructive, handler: { (action) in
            
            
            self.tableView.beginUpdates()
            self.vehicles[indexPath.row].delete()
            
            self.vehicles = SessionObjects.currentUser.vehicle?.allObjects as! [Vehicle]
            
            
            self.tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
            
            if Defaults[.curentVehicleName] == vehicleName
            {
                if self.vehicles != nil && self.vehicles.count > 0
                {
                    SessionObjects.currentVehicle = self.vehicles.first
                    Defaults[.curentVehicleName] = self.vehicles[0].name
                }
                else
                {
                    SessionObjects.motionMonitor.stopDetection()
                    SessionObjects.currentVehicle = nil
                    Defaults[.curentVehicleName] = nil
                    
                }
            }
            self.tableView.endUpdates()
            self.tableView.reloadData()
            
        })
        
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler:nil)
        
        alert.addAction(deleteAction)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func openSideMenu()
    {
        self.slideMenuController()?.openLeft()
        print("hello")
    }
    
}
