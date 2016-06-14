//
//  RegisterViewController.swift
//  ZOBA
//
//  Created by RE Pixels on 5/30/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import Foundation
import UIKit
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit
import TextFieldEffects
import CoreData
import Alamofire
import SwiftyUserDefaults

class RegisterViewController: UIViewController,FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
    
    var managedObjectContext : NSManagedObjectContext!
    
    /*
     * Text Fields
     * Hoshi Text Fields
     * https://github.com/raulriera/TextFieldEffects
     */
    @IBOutlet weak var firstNameTextField: HoshiTextField!
    @IBOutlet weak var lastNameTextField: HoshiTextField!
    @IBOutlet weak var emailTextField: HoshiTextField!
    @IBOutlet weak var userNameTextField: HoshiTextField!
    @IBOutlet weak var passwordTextField: HoshiTextField!
    
    //Validation Indicatiors
    
    var isFirstNameValid = false
    var isLastNameValid = false
    var isEmailValid = false
    var isPasswordValid = false
    var isUserNameValid = false
    
    
    let facebookReadPermissions = ["public_profile", "email", "user_friends"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.hideKeyboardWhenTappedAround()
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        setViewBackgroundImage("street")
        
        facebookLoginButton.readPermissions = facebookReadPermissions
        facebookLoginButton.delegate = self
        facebookLoginButton.loginBehavior = FBSDKLoginBehavior.Native
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if ((error) != nil)
        {
            let alert = UIAlertController(title: "Facebook Login Failed", message: "Sorry Champ! We Couldn't Login with your Facebook. Try Again Later!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            print("\(error)")
            //handle error
        } else {
            loginButton.readPermissions = ["public_profile", "email", "user_friends"]
            loginButton.loginBehavior = FBSDKLoginBehavior.SystemAccount
            loginButton.delegate = self
            returnUserData()
        }
    }
    
    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id,first_name,last_name,email,age_range,name,picture.width(480).height(480)"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                let alert = UIAlertController(title: "Facebook Login Failed", message: "Sorry Champ! We Couldn't Login with your Facebook. Try Again Later!", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                print("Error: \(error)")
            }
            else
            {
                let firstName = result.valueForKey("first_name") as? String
                let lastName = result.valueForKey("last_name") as? String
                let userEmail = (result.valueForKey("email") as? String)!
                let userName = userEmail.componentsSeparatedByString("@")[0]
                
                self.firstNameTextField.text = firstName
                self.lastNameTextField.text = lastName
                self.emailTextField.text = result.valueForKey("email") as? String
                self.userNameTextField.text = userName
                self.passwordTextField.text = self.randomAlphaNumericString(6)
                print(self.passwordTextField.text)
                self.facebookLoginButton.hidden = true
            }
        })
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
    }
    
    func setViewBackgroundImage(imageName:String)
    {
        let backgroundImageView: UIImageView = UIImageView(frame: self.view.bounds)
        backgroundImageView.contentMode = UIViewContentMode.ScaleAspectFill;
        backgroundImageView.image = UIImage(named: imageName)
        
        let backgroundImageMask: UIView =  UIView(frame: self.view.bounds)
        backgroundImageMask.backgroundColor = UIColor(white: 0.0, alpha: 0.6)
        
        self.view.insertSubview(backgroundImageView, atIndex: 0)
        self.view.insertSubview(backgroundImageMask, atIndex: 1)
        
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
 
    
    
    @IBAction func validateUserEmail(sender: AnyObject)
    {
        if(DataValidations.isValidEmail(emailTextField.text!))
        {
            hideErrorMessage("Email", textField: emailTextField)
            isEmailValid = true
        }
        else
        {
            showErrorMessage("Enter a valid Email", textField: emailTextField)
            isEmailValid = false
        }
        validateRegisterButton()
    }
    
    @IBAction func validateFirstName(sender: AnyObject)
    {
        if(firstNameTextField.text?.isNotEmpty == true && DataValidations.hasNoWhiteSpaces(firstNameTextField.text!))
        {
            hideErrorMessage("First Name", textField: firstNameTextField)
            isFirstNameValid = true
        }
        else
        {
            isFirstNameValid = false
            showErrorMessage("Enter First Name", textField: firstNameTextField)
        }
        validateRegisterButton()
    }
    
    @IBAction func validateLastName(sender: AnyObject)
    {
        if(lastNameTextField.text?.isNotEmpty == true && DataValidations.hasNoWhiteSpaces(lastNameTextField.text!))
        {
            hideErrorMessage("Last Name", textField: lastNameTextField)
            isLastNameValid = true
        }
        else
        {
            showErrorMessage("Enter Last Name", textField: lastNameTextField)
            isLastNameValid = false
        }
        validateRegisterButton()
    }
    
    @IBAction func validateUserName(sender: AnyObject)
    {
        if(userNameTextField.text?.isNotEmpty == true && DataValidations.hasNoWhiteSpaces(userNameTextField.text!))
        {
            hideErrorMessage("User Name", textField: userNameTextField)
            isUserNameValid = true
        }
        else
        {
            showErrorMessage("Enter a valid user name", textField: userNameTextField)
            isUserNameValid = false
        }
        validateRegisterButton()
    }
    
    @IBAction func validatePassword(sender: AnyObject)
    {
        if(passwordTextField.text?.isNotEmpty == true && DataValidations.hasNoWhiteSpaces(passwordTextField.text!))
        {
            hideErrorMessage("Password", textField: passwordTextField)
            isPasswordValid = true
        }
        else
        {
            showErrorMessage("Enter a valid password", textField: passwordTextField)
            isPasswordValid = false
        }
        validateRegisterButton()
    }
    
    func validateRegisterButton()
    {
        if (isEmailValid && isLastNameValid && isPasswordValid && isFirstNameValid && isUserNameValid)
        {
            enableRegisterButton()
        }
        else
        {
            disableRegisterButton()
        }
    }
    
    func enableRegisterButton()
    {
        registerButton.enabled = true
        registerButton.alpha = 1.0
    }
    
    func disableRegisterButton()
    {
        registerButton.enabled = false
        registerButton.alpha = 0.7
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
    }
    
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        switch identifier {
        case "Register To Main":
            
            let managedUser = MyUser(managedObjectContext: SessionObjects.currentManageContext , entityName:"MyUser")
            let userWebservice = UserWebservice(currentUser: managedUser)
            
            
            managedUser.email = emailTextField.text
            managedUser.password = passwordTextField.text
            managedUser.firstName = firstNameTextField.text
            managedUser.lastName = lastNameTextField.text
            managedUser.userName = userNameTextField.text
            
            userWebservice.registerUser({ (user, code) in
                
                switch code
                {
                case "success":
                    SessionObjects.currentUser = user!
                    if((Defaults[.deviceToken]) != nil)
                    {
                        SessionObjects.currentUser.deviceToken = Defaults[.deviceToken]!
                    }
                    SessionObjects.currentUser.save()
                    self.performSegueWithIdentifier(identifier,sender: sender)
                    break;
                default:
                    self.generateErrorAlert(code)
                    break;
                }
            })
            break;
        default:
            self.generateErrorAlert("None")
            break;
            
        }
        return false
    }
    
    func generateErrorAlert(errorMessage: String?)
    {
        if errorMessage != nil
        {
            let alert = UIAlertController(title: "Registeration Failed", message: errorMessage!, preferredStyle: UIAlertControllerStyle.Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(defaultAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    
    func randomAlphaNumericString(length: Int) -> String {
        
        let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let allowedCharsCount = UInt32(allowedChars.characters.count)
        var randomString = ""
        
        for _ in (0..<length) {
            let randomNum = Int(arc4random_uniform(allowedCharsCount))
            let newCharacter = allowedChars[allowedChars.startIndex.advancedBy(randomNum)]
            randomString += String(newCharacter)
        }
        
        return randomString
    }
}