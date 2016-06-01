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
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id,interested_in,gender,birthday,email,age_range,name,picture.width(480).height(480)"])
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
                let fullName = result.valueForKey("name") as? String
                var fullNameArr = fullName!.characters.split{$0 == " "}.map(String.init)
                
                self.firstNameTextField.text = fullNameArr[0]
                self.lastNameTextField.text = String.init(format: "%@ %@", fullNameArr[1],fullNameArr[2])
                
                self.emailTextField.text = result.valueForKey("email") as? String
            }
        })
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
        self.emailTextField.text = ""
        self.emailTextField.borderInactiveColor = UIColor.redColor()
        self.emailTextField.borderActiveColor = UIColor.redColor()
        self.emailTextField.placeholderColor = UIColor.redColor()
        
        self.firstNameTextField.text = ""
        self.firstNameTextField.borderInactiveColor = UIColor.redColor()
        self.firstNameTextField.borderActiveColor = UIColor.redColor()
        self.firstNameTextField.placeholderColor = UIColor.redColor()
        
        self.lastNameTextField.text = ""
        self.lastNameTextField.borderInactiveColor = UIColor.redColor()
        self.lastNameTextField.borderActiveColor = UIColor.redColor()
        self.lastNameTextField.placeholderColor = UIColor.redColor()
        
        print("User Logged Out")
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
    
    
    @IBAction func registerAction(sender: AnyObject) {
//        NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
//        NSString *trimmed = [rawString stringByTrimmingCharactersInSet:whitespace];
//      
       
        
       
        let whitespace = NSCharacterSet.whitespaceCharacterSet()
     //   var trim = emailTextField.text!.stringByTrimmingCharactersInSet(whitespace)

        
        if ((DataValidations.isValidEmail(emailTextField.text!)) && (emailTextField.text?.stringByTrimmingCharactersInSet(whitespace)) != ""){
          print("mail is valid")
        }
        
        
        
//        var userObj = MyUser()
//        userObj.emailS
//
//        var client = UserDAO(managedObjectContext: self.managedObjectContext!)
//        client.save(managedObjectContext!, userId: 2, Email: self.emailTextField.text!, UserName: userNameTextField.text!, firstName: firstNameTextField.text!, LastName: lastNameTextField.text!, Phone: , ImageUrl: "image" , password: "123")
//        
    }
    
}