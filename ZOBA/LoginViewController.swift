//
//  ViewController.swift
//  ZOBA
//
//  Created by RE Pixels on 5/27/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import UIKit
import Onboard
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit
import TextFieldEffects
import CoreData
import SwiftyUserDefaults
import SlideMenuControllerSwift

class LoginViewController:UIViewController ,FBSDKLoginButtonDelegate , UITextFieldDelegate{
    
    //Buttons
    @IBOutlet weak var fbLoginButton: FBSDKLoginButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var fogotPasswordButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    
    
    var managedObjectContext :NSManagedObjectContext!
    /*
     * Text Fields
     * Hoshi Text Fields
     * https://github.com/raulriera/TextFieldEffects
     */
    @IBOutlet weak var emailTextField: HoshiTextField!
    @IBOutlet weak var passwordTextField: HoshiTextField!
    
    //Validation Indicatiors
    var isPasswordReady = false
    var isEmailReady = true
    
    var resetPasswordAlertTextField: UITextField!
    
    //Facebook Permissions
    let facebookReadPermissions = ["public_profile", "email", "user_friends"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //Change View Background Image
        setViewBackgroundImage("street")
        
        //Hide Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        //Change Status Bar Style to Light
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        fbLoginButton.readPermissions = facebookReadPermissions
        fbLoginButton.delegate = self
        fbLoginButton.loginBehavior = FBSDKLoginBehavior.Native
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                _ = result.valueForKey("first_name") as? String
                _ = result.valueForKey("last_name") as? String
                let userEmail = (result.valueForKey("email") as? String)!
                _ = userEmail.componentsSeparatedByString("@")[0]
                
                self.emailTextField.text = result.valueForKey("email") as? String
                self.passwordTextField.text = self.randomAlphaNumericString(6)
                print(self.passwordTextField.text)
                self.fbLoginButton.hidden = true
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
    
    @IBAction func forgotPasswordClicked(sender: AnyObject) {
        
        let alert = UIAlertController(title: "Reset Your Password", message: "Enter your email below to reset your password!", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addTextFieldWithConfigurationHandler(configurationTextField)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:handleCancel))
        alert.addAction(UIAlertAction(title: "Reset Password", style: UIAlertActionStyle.Destructive, handler:{ (UIAlertAction)in
            print("User Email is : \(self.resetPasswordAlertTextField.text)")
        }))
        self.presentViewController(alert, animated: true, completion: {
            print("Alert Ended")
        })
        
    }
    
    func configurationTextField(textField: UITextField!)
    {
        print("generating the TextField")
        textField.placeholder = "Enter an item"
        resetPasswordAlertTextField = textField
    }
    
    
    func handleCancel(alertView: UIAlertAction!)
    {
        print("Cancel Button Clicked")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
        
    }
    
    /*
     * Detect when text field gains focus
     */
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        print("\(textField.text)")
        return true
    }
    
    @IBAction func emailEditingDidEnd(sender: AnyObject) {
        
        if(DataValidations.isValidEmail(emailTextField.text!))
        {
            showEmailValidMessage("Email")
            isEmailReady = true
        }
        else
        {
            showEmailErrorMessage("Enter a valid Email")
            isEmailReady = false
        }
        validateLoginBtn()
        
    }
    
    @IBAction func emailEditingDidBegin(sender: AnyObject)
    {
        if(DataValidations.isValidEmail(emailTextField.text!))
        {
            isEmailReady = true
        }
        else
        {
            isEmailReady = false
        }
        validateLoginBtn()
    }
    
    @IBAction func emailEditingChanged(sender: AnyObject)
    {
        if(DataValidations.isValidEmail(emailTextField.text!))
        {
            isEmailReady = true
        }
        else
        {
            isEmailReady = false
        }
        validateLoginBtn()
    }
    
    @IBAction func passwordEditingDidEnd(sender: AnyObject)
    {
        if(passwordTextField.text?.isNotEmpty == true && DataValidations.hasNoWhiteSpaces(passwordTextField.text!))
        {
            isPasswordReady = true
        }
        else
        {
            isPasswordReady = false
        }
        
        validateLoginBtn()
        
    }
    
    
    
    func validateLoginBtn()
    {
        if(isEmailReady && isPasswordReady)
        {
            enableLoginBTN()
            
        }
        else
        {
            disableLoginBTN()
        }
    }
    
    func enableLoginBTN()
    {
        loginButton.enabled = true
        loginButton.alpha = 1.0
    }
    
    func disableLoginBTN()
    {
        loginButton.enabled = false
        loginButton.alpha = 0.7
        
    }
    
    func showEmailErrorMessage(message:String)
    {
        self.emailTextField.borderInactiveColor = UIColor.redColor()
        self.emailTextField.borderActiveColor = UIColor.redColor()
        self.emailTextField.placeholderColor = UIColor.redColor()
        self.emailTextField.placeholderLabel.text = message
        self.emailTextField.placeholderLabel.sizeToFit()
        self.emailTextField.placeholderLabel.alpha = 1.0
        
    }
    
    func showEmailValidMessage(message:String)
    {
        self.emailTextField.borderInactiveColor = UIColor.greenColor()
        self.emailTextField.borderActiveColor = UIColor.greenColor()
        self.emailTextField.placeholderColor = UIColor.whiteColor()
        self.emailTextField.placeholderLabel.text = message
        enableLoginBTN()
    }
    
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        
        if identifier == "loginSegue"
        {
            let managedUser = MyUser(managedObjectContext: SessionObjects.currentManageContext , entityName: "MyUser")
            
            managedUser.email = emailTextField.text
            managedUser.password = passwordTextField.text
            
            let userWebservice = UserWebservice(currentUser: managedUser)
            userWebservice.loginUser({ (user, code) in
                switch code
                {
                case "success":
                    SessionObjects.currentUser = user!
                    if((Defaults[.deviceToken]) != nil)
                    {
                        SessionObjects.currentUser.deviceToken = Defaults[.deviceToken]!
                    }
//
//                    let deviceWebService = DeviceWebservice(deviceToken: Defaults[.deviceToken]!,currentUser: SessionObjects.currentUser)
//                    deviceWebService.registerUserDevice()
//                    
                    SessionObjects.currentUser.save()
                    Defaults[.isLoggedIn] = true
                    Defaults[.useremail] = user!.email
                    Defaults[.launchCount] += 1
                    
                    //To be removed

                    
                    DummyDataBaseOperation.populateOnlyOnce()
                    DummyDataBaseOperation.populateData()
                    
                    
                    
                    let homeStoryBoard : UIStoryboard = UIStoryboard(name: "HomeStoryBoard", bundle: nil)
                    let homeTabController : HomeViewController = homeStoryBoard.instantiateViewControllerWithIdentifier("HomeTabController") as! HomeViewController
                    
                    let sideMenuStoryBoard : UIStoryboard = UIStoryboard(name: "SideMenu", bundle: nil)
                    let sideMenuController : MenuTableViewController = sideMenuStoryBoard.instantiateViewControllerWithIdentifier("MenuViewController") as! MenuTableViewController
                    
                    
                    let slideMenuController = SlideMenuController(mainViewController: homeTabController, leftMenuViewController: sideMenuController)
                    slideMenuController.automaticallyAdjustsScrollViewInsets = true
                    
                    let app = UIApplication.sharedApplication().delegate as! AppDelegate
                    app.window?.rootViewController = slideMenuController
                    

                    break;
                default:
                    self.generateErrorAlert(code)
                    break;
                    
                }
                
            })
        }
        else
        {
            return true
        }
        
        return false
    }
    
    func generateErrorAlert(errorMessage: String?)
    {
        if errorMessage != nil
        {
            let alert = UIAlertController(title: "Login Failed", message: errorMessage!, preferredStyle: UIAlertControllerStyle.Alert)
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

