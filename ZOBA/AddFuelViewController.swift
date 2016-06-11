//
//  AddFuelViewController.swift
//  ZOBA
//
//  Created by RE Pixels on 6/5/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import UIKit
import TextFieldEffects

class AddFuelViewController: UIViewController , UIPickerViewDelegate {

    @IBOutlet weak var saveBtn: UIBarButtonItem!
    
    
    @IBAction func dateApperance(sender: HoshiTextField) {
        
        let datePickerView  : UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.Date
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(AddFuelViewController.handleDatePicker(_:)), forControlEvents: UIControlEvents.ValueChanged)

    }
   
    @IBOutlet weak var dateTextField: HoshiTextField!

    @IBOutlet weak var fuelAmountTextField: HoshiTextField!
    @IBOutlet weak var currentOdometerTextField: HoshiTextField!

    @IBOutlet weak var dateAndTimeImage: UIImageView!
    
    @IBOutlet weak var OdometerImage: UIImageView!
    
    @IBOutlet weak var fuelAmountImage: UIImageView!
    
  
   
    @IBOutlet weak var serviceProviderImage: UIImageView!
   
    
    
    func disableBtn()  {
        
        saveBtn.enabled = false
        saveBtn.tintColor = UIColor.grayColor()
    }
    
    func enablBtn()  {
        
        saveBtn.enabled = true
        saveBtn.tintColor = UIColor.blueColor()
    }
    
    
    
    @IBAction func saveFuelData(sender: AnyObject) {
      
        
    }
    
    func handleDatePicker(sender: UIDatePicker) {
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        
        dateTextField.text = dateFormatter.stringFromDate(sender.date)
        
    }
    
    var pickOption = ["one", "two" , "three" , "four"]

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickOption[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        fuelAmountTextField.text = pickOption[row]
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickOption.count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add Fuel"
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.whiteColor(),
             NSFontAttributeName: UIFont(name: "Continuum Medium", size: 22)!]
        // Do any additional setup after loading the view.
        
        
      disableBtn()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
