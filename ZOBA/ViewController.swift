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

class ViewController:UIViewController ,FBSDKLoginButtonDelegate{

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
        
        //let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        
        //self.managedObjectContext = appDel.managedObjectContext
        
//        var client = UserDAO(managedObjectContext: self.managedObjectContext)
//        client.save(managedObjectContext, userId: 2, Email: "omima@", UserName: "omima", firstName: "omima", LastName: "ibra", Phone: "222", ImageUrl: "image" , password: "123")
        
        //client.delete(managedObjectContext, Id: 2)
     //print(client.selectById(managedObjectContext, Id: 2).firstName)
 //print(client.selectAll(managedObjectContext).count)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if ((error) != nil)
        {
            // Process error
            let alert = UIAlertController(title: "Facebook Login Failed", message: "Sorry Champ! We Couldn't Login with your Facebook. Try Again Later!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            print("\(error)")
            //handle error
        } else {
            loginButton.readPermissions = ["public_profile", "email", "user_friends"]
            loginButton.loginBehavior = FBSDKLoginBehavior.Native
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
                let alert = UIAlertController(title: "Facebook Login Failed", message: "Sorry Champ! We Couldn't Login with your Facebook. Try Again Later!", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                // Process error
                print("Error: \(error)")
            }
            else
            {
                self.emailTextField.text = result.valueForKey("email") as? String
            }
        })
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        self.emailTextField.text = ""
        self.emailTextField.borderInactiveColor = UIColor.redColor()
        self.emailTextField.borderActiveColor = UIColor.redColor()
        self.emailTextField.placeholderColor = UIColor.redColor()
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
    

}

