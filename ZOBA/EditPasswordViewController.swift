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
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func isOldPasswordValid(_ sender: HoshiTextField)
    {
        if(sender.text!.isNotEmpty && !DataValidations.hasNoWhiteSpaces(str: sender.text!))
        {
            showErrorMessage(message: "Password Invalid", textField: sender)
            
        }
        else
        {
            hideErrorMessage(message: "Current Pasword", textField: sender)
            
        }
    }
    
    @IBAction func isOldPasswordMatch(_ sender: HoshiTextField)
    {
        if SessionObjects.currentUser.password == currentPassword.text
        {
            showErrorMessage(message: "Password Mismatch", textField: self.currentPassword)
        }
        else
        {
            hideErrorMessage(message: "Current Password Valid", textField: self.currentPassword)
        }
    }
    
    @IBAction func checkNewPassword(_ sender: HoshiTextField)
    {
        if(newPassword.text!.isNotEmpty && !DataValidations.hasNoWhiteSpaces(str: newPassword.text!))
        {
            showErrorMessage(message: "Enter a valid password", textField: self.newPassword)
        }
        else
        {
            
            hideErrorMessage(message: "New Password Valid", textField: self.newPassword)
        }
    }
    
    @IBAction func checkConfirmNewPassword(_ sender: HoshiTextField)
    {
        if(newPasswordConfirm.text!.isNotEmpty && !DataValidations.hasNoWhiteSpaces(str: newPasswordConfirm.text!))
        {
            showErrorMessage(message: "Enter a valid password", textField: self.newPasswordConfirm)
        }
        else if(newPassword.text == newPasswordConfirm.text)
        {
            showErrorMessage(message: "Enter a valid password", textField: self.newPasswordConfirm)
        }
        else
        {
            hideErrorMessage(message: "Confirm New Password", textField: self.newPasswordConfirm)
        }
    }
    
    
    @IBAction func isNewPasswordMatch(_ sender: HoshiTextField)
    {
        if(newPassword.text == newPasswordConfirm.text)
        {
            hideErrorMessage(message: "Password Matched", textField: self.newPasswordConfirm)
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
        else
        {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    func showErrorMessage(message:String , textField:HoshiTextField)
    {
        textField.borderInactiveColor = UIColor.red
        textField.borderActiveColor = UIColor.red
        textField.placeholderColor = UIColor.red
        textField.placeholderLabel.text = message
        textField.placeholderLabel.sizeToFit()
        textField.placeholderLabel.alpha = 1.0
    }
    
    func hideErrorMessage(message : String , textField: HoshiTextField)
    {
        textField.borderInactiveColor = UIColor.green
        textField.borderActiveColor = UIColor.green
        textField.placeholderColor = UIColor.white
        textField.placeholderLabel.sizeToFit()
        textField.placeholderLabel.text = message
    }
    
    
    @IBAction func updateUserPassword(_ sender:AnyObject)
    {
        SessionObjects.currentUser.password = newPassword.text
        SessionObjects.currentUser.save()
        navigationController?.popViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
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
