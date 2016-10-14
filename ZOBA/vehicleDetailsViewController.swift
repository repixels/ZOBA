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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.currentOdemter.text = vehicle.currentOdemeter!.stringValue
        self.licensePlateTextField.text = vehicle.licensePlate != nil ? vehicle.licensePlate! : ""
        self.vehicleNameTextField.text = vehicle.name != nil ? vehicle.name! : ""
        self.makeTextField.text = vehicle.vehicleModel?.model?.make?.name != nil ? vehicle.vehicleModel?.model?.make?.name! : ""
        self.modelTextField.text = vehicle.vehicleModel?.model?.name != nil ? vehicle.vehicleModel?.model?.name! : ""
        self.yearTextField.text = vehicle.vehicleModel?.year?.name!.stringValue != nil ? vehicle.vehicleModel?.year?.name!.stringValue : ""
        self.trimTextField.text = vehicle.vehicleModel?.trim?.name != nil ? vehicle.vehicleModel?.trim?.name : ""
        self.initialOdemterTextField.text = vehicle.initialOdemeter!.stringValue != nil ? vehicle.initialOdemeter!.stringValue : ""
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
