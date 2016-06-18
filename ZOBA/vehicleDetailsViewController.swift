//
//  vehicleDetailsViewController.swift
//  ZOBA
//
//  Created by Angel mas on 6/14/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import UIKit

class vehicleDetailsViewController: UITableViewController {
    
    var vehicle : Vehicle!
    
    
    
    @IBOutlet weak var vehicleNameTextField: UITextField!
    
    
    @IBOutlet weak var initialOdemterTextField: UITextField!
    
    @IBOutlet weak var currentOdemter: UITextField!
    
    
    @IBOutlet weak var licensePlateTextField: UITextField!
    
    @IBOutlet weak var makeTextField: UITextField!
    
    
    @IBOutlet weak var modelTextField: UITextField!
    
    @IBOutlet weak var trimTextField: UITextField!
    
    @IBOutlet weak var yearTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.currentOdemter.text = String( vehicle.currentOdemeter!)
        self.licensePlateTextField.text = vehicle.licensePlate!
        self.vehicleNameTextField.text = vehicle.name!
        self.makeTextField.text = vehicle.vehicleModel?.model?.make?.name!
        self.modelTextField.text = vehicle.vehicleModel?.model?.name!
        self.yearTextField.text = String(vehicle.vehicleModel?.year?.name!)
        self.trimTextField.text = vehicle.vehicleModel?.trim?.name!
        self.initialOdemterTextField.text = String(vehicle.initialOdemeter!)
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}