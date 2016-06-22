//
//  EditPasswordViewController.swift
//  ZOBA
//
//  Created by RE Pixels on 6/12/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import UIKit
import TextFieldEffects

class EditPasswordViewController: UIViewController {

    @IBOutlet weak var currentPassword: HoshiTextField!
    @IBOutlet weak var newPassword: HoshiTextField!
    @IBOutlet weak var newPasswordConfirm: HoshiTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.navigationItem.rightBarButtonItem?.enabled = false
        self.navigationItem.rightBarButtonItem?.enabled = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    @IBAction func isOldPasswordValid(sender: HoshiTextField)
    {
        if(sender.text!.isNotEmpty && !DataValidations.hasNoWhiteSpaces(sender.text!))
        {
            showErrorMessage("Password Invalid", textField: sender)
            
        }
        else
        {
            hideErrorMessage("Current Pasword", textField: sender)
            
        }
    }
    
    @IBAction func isOldPasswordMatch(sender: HoshiTextField)
    {
        if SessionObjects.currentUser.password == currentPassword.text
        {
            showErrorMessage("Password Mismatch", textField: self.currentPassword)
        }
        else
        {
            hideErrorMessage("Current Password Valid", textField: self.currentPassword)
        }
    }
    
    @IBAction func checkNewPassword(sender: HoshiTextField)
    {
        if(newPassword.text!.isNotEmpty && !DataValidations.hasNoWhiteSpaces(newPassword.text!))
        {
            showErrorMessage("Enter a valid password", textField: self.newPassword)
        }
        else
        {
            
            hideErrorMessage("New Password Valid", textField: self.newPassword)
        }
    }
    
    @IBAction func checkConfirmNewPassword(sender: HoshiTextField)
    {
        if(newPasswordConfirm.text!.isNotEmpty && !DataValidations.hasNoWhiteSpaces(newPasswordConfirm.text!))
        {
            showErrorMessage("Enter a valid password", textField: self.newPasswordConfirm)
        }
        else if(newPassword.text == newPasswordConfirm.text)
        {
            showErrorMessage("Enter a valid password", textField: self.newPasswordConfirm)
        }
        else
        {
            hideErrorMessage("Confirm New Password", textField: self.newPasswordConfirm)
        }
    }
    
    
    @IBAction func isNewPasswordMatch(sender: HoshiTextField)
    {
        if(newPassword.text == newPasswordConfirm.text)
        {
            hideErrorMessage("Password Matched", textField: self.newPasswordConfirm)
            self.navigationItem.rightBarButtonItem?.enabled = true
        }
        else
        {
            self.navigationItem.rightBarButtonItem?.enabled = false
        }
    }
    
    func showErrorMessage(message:String , textField:HoshiTextField)
    {
        textField.borderInactiveColor = UIColor.redColor()
        textField.borderActiveColor = UIColor.redColor()
        textField.placeholderColor = UIColor.redColor()
        textField.placeholderLabel.text = message
        textField.placeholderLabel.sizeToFit()
        textField.placeholderLabel.alpha = 1.0
    }
    
    func hideErrorMessage(message : String , textField: HoshiTextField)
    {
        textField.borderInactiveColor = UIColor.greenColor()
        textField.borderActiveColor = UIColor.greenColor()
        textField.placeholderColor = UIColor.whiteColor()
        textField.placeholderLabel.sizeToFit()
        textField.placeholderLabel.text = message
    }
    
    
    @IBAction func updateUserPassword(sender:AnyObject)
    {
        SessionObjects.currentUser.password = newPassword.text
        SessionObjects.currentUser.save()
        navigationController?.popViewControllerAnimated(true)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
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
