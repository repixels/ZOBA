//
//  UserProfileEditController.swift
//  ZOBA
//
//  Created by Angel mas on 6/8/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import UIKit
import TextFieldEffects

class UserProfileEditController: UIViewController,UIPopoverPresentationControllerDelegate {
    
    //tex field outlets
    @IBOutlet weak var firstNameTextField: HoshiTextField!
    @IBOutlet weak var emailTextField: HoshiTextField!
    @IBOutlet weak var userNameTextField: HoshiTextField!
    @IBOutlet weak var phoneTextField: HoshiTextField!
    @IBOutlet weak var lastNameTextField: HoshiTextField!
    @IBOutlet weak var passwordTextField: HoshiTextField!
    
    
    //navigation button
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    
    //managed object of user
    var user : MyUser!
    
    //flags
    var userEmailValid = true
    var userNameValid = true
    var passwordValid = true
    var phoneValid = true
    var firstNameValid = true
    var lastNameValid = true
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("========================")
        print(user.email)
        
        //update fieldswith user data
        phoneTextField.text = (user.phone != nil) ? user.phone : ""
        firstNameTextField.text = (user.firstName != nil) ? user.firstName : ""
        lastNameTextField.text = (user.lastName != nil) ? user.lastName : ""
        emailTextField.text = (user.email != nil) ? user.email : ""
        userNameTextField.text = (user.userName != nil) ? user.userName : ""
        passwordTextField.text = (user.password != nil) ? user.password : ""
        
        
        // disable button
        self.saveBtn.enabled = false
        self.saveBtn.tintColor = UIColor.grayColor()
        
        //register keyboard notification
        let notCenter = NSNotificationCenter.defaultCenter()
        notCenter.addObserver(self, selector: #selector (keyboardWillHide), name: 	UIKeyboardWillHideNotification, object: nil)
        notCenter.addObserver(self, selector: #selector (keyBoardWillAppear), name: 	UIKeyboardWillShowNotification, object: nil)
        
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    //MARK: - keyboard
    func keyBoardWillAppear(notification : NSNotification){
        
        if let userInfo = notification.userInfo {
            if let keyboardSize: CGSize =    userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue().size {
                let contentInset = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height,  0.0);
                
                self.scrollView.contentInset = contentInset
                self.scrollView.scrollIndicatorInsets = contentInset
                
                self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, 0 + keyboardSize.height) //set zero instead
                
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize: CGSize =  userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue().size {
                let contentInset = UIEdgeInsetsZero;
                
                self.scrollView.contentInset = contentInset
                self.scrollView.scrollIndicatorInsets = contentInset
                self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, self.scrollView.contentOffset.y)
            }
        }
    }
    
    //Mark: - validating textfields
    @IBAction func emailEndEditing(sender: AnyObject) {
        
        if(emailTextField.text!.isNotEmpty && DataValidations.isValidEmail(emailTextField.text!))
        {
            hideErrorMessage("Email", textField: emailTextField)
            userEmailValid = true
            
        }
        else
        {
            showErrorMessage("Enter a valid Email", textField: emailTextField)
            userEmailValid = false
        }
        validateSaveButton()
        
    }
    
    @IBAction func passwordEndEditing(sender: AnyObject) {
        
        if(passwordTextField.text!.isNotEmpty && DataValidations.isValidPassword(passwordTextField.text!))
        {
            hideErrorMessage("Password", textField: passwordTextField)
            passwordValid = true
            
        }
        else
        {
            showErrorMessage("Enter a valid password", textField: passwordTextField)
            passwordValid = false
        }
        validateSaveButton()
        
    }
    
    @IBAction func userNameEndEditing(sender: AnyObject) {
        if(userNameTextField.text!.isNotEmpty && DataValidations.isValidUesrName(userNameTextField.text!))
        {
            hideErrorMessage("User name", textField: userNameTextField)
            userNameValid = true
        }
        else
        {
            showErrorMessage("Enter a valid user name", textField: userNameTextField)
            userNameValid = false
        }
        validateSaveButton()
        
    }
    
    @IBAction func phoneEndEditing(sender: AnyObject) {
        
        if(phoneTextField.text!.isNotEmpty && DataValidations.isValidPhone(phoneTextField.text!))
        {
            hideErrorMessage("Phone", textField: phoneTextField)
            phoneValid = true
        }
        else
        {
            showErrorMessage("Enter a valid phone", textField: phoneTextField)
            phoneValid = false
        }
        validateSaveButton()
        
    }
    
    @IBAction func firstNameEndEditing(sender: AnyObject) {
        
        if(firstNameTextField.text!.isNotEmpty && DataValidations.hasNoWhiteSpaces(firstNameTextField.text!))
        {
            hideErrorMessage("First name", textField: firstNameTextField)
            firstNameValid = true
        }
        else
        {
            showErrorMessage("Enter a valid first name", textField: firstNameTextField)
            firstNameValid = false
        }
        validateSaveButton()
        
    }
    
    @IBAction func lastNameEndEditing(sender: AnyObject) {
        
        if(lastNameTextField.text!.isNotEmpty && DataValidations.hasNoWhiteSpaces(lastNameTextField.text!))
        {
            hideErrorMessage("Last name", textField: lastNameTextField)
            lastNameValid = true
        }
        else
        {
            showErrorMessage("Enter a valid last name", textField: lastNameTextField)
            lastNameValid = false
        }
        validateSaveButton()
        
    }
    
    func validateSaveButton(){
        
        if (userNameValid && userEmailValid && passwordValid && firstNameValid && lastNameValid && phoneValid){
            self.saveBtn.enabled = true
            self.saveBtn.tintColor = UIColor.blueColor()
            
        }
        else{
            
            self.saveBtn.enabled = false
            self.saveBtn.tintColor = UIColor.grayColor()
            
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
        textField.placeholderLabel.text = message
        textField.placeholderLabel.alpha = 1.0
    }
    
    
    
    @IBAction func save(sender: AnyObject) {
        
        
        user.phone = phoneTextField.text != nil ? phoneTextField.text  : nil
        user.firstName = firstNameTextField.text != nil ? firstNameTextField.text  : nil
        user.lastName = lastNameTextField.text != nil ? lastNameTextField.text  : nil
        user.email = emailTextField.text != nil ? emailTextField.text  : nil
        user.userName = userNameTextField.text != nil ? userNameTextField.text  : nil
        user.password = passwordTextField.text != nil ? passwordTextField.text  : nil
        
        user.save()
        print(user.email)
        print(" you should save user data ")
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    
}