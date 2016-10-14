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
        UIApplication.shared.statusBarStyle = .lightContent
        
        fbLoginButton.readPermissions = facebookReadPermissions
        fbLoginButton.delegate = self
        fbLoginButton.loginBehavior = FBSDKLoginBehavior.native
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if ((error) != nil)
        {
            let alert = UIAlertController(title: "Facebook Login Failed", message: "Sorry Champ! We Couldn't Login with your Facebook. Try Again Later!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            print("\(error)")
            //handle error
        } else {
            loginButton.readPermissions = ["public_profile", "email", "user_friends"]
            loginButton.loginBehavior = FBSDKLoginBehavior.systemAccount
            loginButton.delegate = self
            returnUserData()
        }
    }
    
    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id,first_name,last_name,email,age_range,name,picture.width(480).height(480)"])
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                let alert = UIAlertController(title: "Facebook Login Failed", message: "Sorry Champ! We Couldn't Login with your Facebook. Try Again Later!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                print("Error: \(error)")
            }
            else if let userData = result as? [String:AnyObject]
            {
                let userId = userData["id"] as? String
                let firstName = userData["first_name"] as? String
                let lastName =  userData["last_name"] as? String
                let userEmail = (userData[ "email"] as? String)!
                let userName = userEmail.components(separatedBy: "@")[0]
                let userProfileImage = "http://graph.facebook.com/\(userId!)/picture?type=large"
            
                 let  fbUser = MyUser(managedObjectContext: SessionObjects.currentManageContext, entityName: "MyUser")
                fbUser.email = userEmail
                fbUser.userName = userName
                fbUser.firstName = firstName
                fbUser.lastName = lastName
                fbUser.phone = "1234567"
                fbUser.password = self.randomAlphaNumericString(6)
            
                let userWebService = UserWebservice(currentUser: fbUser)
                
                userWebService.getUserImageFromFacebook(profilePictureURL: userProfileImage, result: { (imageData, code) in
                    switch code
                    {
                    case "success":
                        userWebService.user?.image = imageData
                        self.navigateToMain(userWebService)
                        break;
                    case "error":
                        self.navigateToMain(userWebService)
                    default:
                        self.navigateToMain(userWebService)
                    }
                })
            }
        
        })
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
    }
    
    func setViewBackgroundImage(_ imageName:String)
    {
        let backgroundImageView: UIImageView = UIImageView(frame: self.view.bounds)
        backgroundImageView.contentMode = UIViewContentMode.scaleAspectFill;
        backgroundImageView.image = UIImage(named: imageName)
        
        let backgroundImageMask: UIView =  UIView(frame: self.view.bounds)
        backgroundImageMask.backgroundColor = UIColor(white: 0.0, alpha: 0.6)
        
        self.view.insertSubview(backgroundImageView, at: 0)
        self.view.insertSubview(backgroundImageMask, at: 1)
        
    }
    
    @IBAction func forgotPasswordClicked(_ sender: AnyObject) {
        
        let alert = UIAlertController(title: "Reset Your Password", message: "Enter your email below to reset your password!", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addTextField(configurationHandler: configurationTextField)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler:handleCancel))
        alert.addAction(UIAlertAction(title: "Reset Password", style: UIAlertActionStyle.destructive, handler:{ (UIAlertAction)in
            print("User Email is : \(self.resetPasswordAlertTextField.text)")
        }))
        self.present(alert, animated: true, completion: {
            print("Alert Ended")
        })
        
    }
    
    func configurationTextField(_ textField: UITextField!)
    {
        print("generating the TextField")
        textField.placeholder = "Enter an item"
        resetPasswordAlertTextField = textField
    }
    
    
    func handleCancel(_ alertView: UIAlertAction!)
    {
        print("Cancel Button Clicked")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
        
    }
    
    /*
     * Detect when text field gains focus
     */
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        print("\(textField.text)")
        return true
    }
    
    @IBAction func emailEditingDidEnd(_ sender: AnyObject) {
        
        if(DataValidations.isValidEmail(testStr: emailTextField.text!))
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
    
    @IBAction func emailEditingDidBegin(_ sender: AnyObject)
    {
        if(DataValidations.isValidEmail(testStr: emailTextField.text!))
        {
            isEmailReady = true
        }
        else
        {
            isEmailReady = false
        }
        validateLoginBtn()
    }
    
    @IBAction func emailEditingChanged(_ sender: AnyObject)
    {
        if(DataValidations.isValidEmail(testStr: emailTextField.text!))
        {
            isEmailReady = true
        }
        else
        {
            isEmailReady = false
        }
        validateLoginBtn()
    }
    
    @IBAction func passwordEditingDidEnd(_ sender: AnyObject)
    {
        if(passwordTextField.text?.isNotEmpty == true && DataValidations.hasNoWhiteSpaces(str: passwordTextField.text!))
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
        loginButton.isEnabled = true
        loginButton.alpha = 1.0
    }
    
    func disableLoginBTN()
    {
        loginButton.isEnabled = false
        loginButton.alpha = 0.7
        
    }
    
    func showEmailErrorMessage(_ message:String)
    {
        self.emailTextField.borderInactiveColor = UIColor.red
        self.emailTextField.borderActiveColor = UIColor.red
        self.emailTextField.placeholderColor = UIColor.red
        self.emailTextField.placeholderLabel.text = message
        self.emailTextField.placeholderLabel.sizeToFit()
        self.emailTextField.placeholderLabel.alpha = 1.0
        
    }
    
    func showEmailValidMessage(_ message:String)
    {
        self.emailTextField.borderInactiveColor = UIColor.green
        self.emailTextField.borderActiveColor = UIColor.green
        self.emailTextField.placeholderColor = UIColor.white
        self.emailTextField.placeholderLabel.text = message
        enableLoginBTN()
    }
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == "loginSegue"
        {

            let managedUser = MyUser(managedObjectContext: SessionObjects.currentManageContext, entityName: "MyUser")
            managedUser.email = emailTextField.text
            managedUser.password = passwordTextField.text
            
            let userWebservice = UserWebservice(currentUser: managedUser)
            userWebservice.loginUser(result: { (user, code) in
                switch code
                {
                case "success":
                    SessionObjects.currentUser = user!
                    if((Defaults[.deviceToken]) != nil)
                    {
                        SessionObjects.currentUser.deviceToken = Defaults[.deviceToken]!
                        let deviceWebService = DeviceWebservice(deviceToken: Defaults[.deviceToken]!,currentUser: SessionObjects.currentUser)
                        deviceWebService.registerUserDevice()
                    }
                    
                    SessionObjects.currentUser.save()
                    Defaults[.isLoggedIn] = true
                    Defaults[.useremail] = user!.email
                    Defaults[.launchCount] += 1
                    
                    
                    let homeStoryBoard : UIStoryboard = UIStoryboard(name: "HomeStoryBoard", bundle: nil)
                    let homeTabController : HomeViewController = homeStoryBoard.instantiateViewController(withIdentifier: "HomeTabController") as! HomeViewController
                    
                    let sideMenuStoryBoard : UIStoryboard = UIStoryboard(name: "SideMenu", bundle: nil)
                    let sideMenuController : MenuTableViewController = sideMenuStoryBoard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuTableViewController
                    
                    
                    let slideMenuController = SlideMenuController(mainViewController: homeTabController, leftMenuViewController: sideMenuController)
                    slideMenuController.automaticallyAdjustsScrollViewInsets = true
                    
                    let app = UIApplication.shared.delegate as! AppDelegate
                    app.window?.rootViewController = slideMenuController
                    
                    print(SessionObjects.currentUser.vehicle?.count )
                    if (SessionObjects.currentUser.vehicle?.count)! > 0 {
                        SessionObjects.currentVehicle = SessionObjects.currentUser.vehicle?.allObjects[0] as! Vehicle
                        Defaults[.curentVehicleName] = SessionObjects.currentVehicle.name
                    }
                    
                    
                    if SessionObjects.currentVehicle != nil {
                        SessionObjects.motionMonitor = LocationMonitor()
                        
                        SessionObjects.motionMonitor.startDetection()
                    }
                    
                    let serviceCenterWebSevice = ServiceProviderWebService()
                    serviceCenterWebSevice.getServiceProvider(result: { (serviceProvider, code) in
                        switch code{
                        case "success" :
                            print("serviceProviders count : \(serviceProvider?.count)")
                            serviceProvider?[0].save()
                        default :
                            DummyDataBaseOperation.populateOnlyOnce()
                        }
                    })
                    
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
    
    func generateErrorAlert(_ errorMessage: String?)
    {
        if errorMessage != nil
        {
            let alert = UIAlertController(title: "Login Failed", message: errorMessage!, preferredStyle: UIAlertControllerStyle.alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(defaultAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func randomAlphaNumericString(_ length: Int) -> String {
        
        let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let allowedCharsCount = UInt32(allowedChars.characters.count)
        var randomString = ""
        
        for _ in (0..<length) {
            let randomNum = Int(arc4random_uniform(allowedCharsCount))
            let newCharacter = allowedChars[allowedChars.characters.index(allowedChars.startIndex, offsetBy: randomNum)]
            randomString += String(newCharacter)
        }
        
        return randomString
    }
    
    func navigateToMain(_ userWebService: UserWebservice)
    {
        userWebService.registerWithFaceBook(result: { (user, code) in
            
            switch code{
                
            case "success":
                SessionObjects.currentUser = user!
                if((Defaults[.deviceToken]) != nil)
                {
                    SessionObjects.currentUser.deviceToken = Defaults[.deviceToken]!
                }
                SessionObjects.currentUser.save()
                
                Defaults[.isFBLogin] = true
                Defaults[.isLoggedIn] = true
                Defaults[.useremail] = user!.email
                Defaults[.launchCount] += 1
                
                //To be removed
                //                        DummyDataBaseOperation.populateOnlyOnce()
                //                        DummyDataBaseOperation.populateData()
                
                self.fbLoginButton.isHidden = true
                
                let homeStoryBoard : UIStoryboard = UIStoryboard(name: "HomeStoryBoard", bundle: nil)
                let homeTabController : HomeViewController = homeStoryBoard.instantiateViewController(withIdentifier: "HomeTabController") as! HomeViewController
                
                let sideMenuStoryBoard : UIStoryboard = UIStoryboard(name: "SideMenu", bundle: nil)
                let sideMenuController : MenuTableViewController = sideMenuStoryBoard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuTableViewController
                
                
                let slideMenuController = SlideMenuController(mainViewController: homeTabController, leftMenuViewController: sideMenuController)
                slideMenuController.automaticallyAdjustsScrollViewInsets = true
                
                let app = UIApplication.shared.delegate as! AppDelegate
                app.window?.rootViewController = slideMenuController
                
                //start detection if user has car
                if SessionObjects.currentVehicle != nil {
                    SessionObjects.motionMonitor = LocationMonitor()
                    
                    SessionObjects.motionMonitor.startDetection()
                }
            default :
                self.generateErrorAlert(code)
                break
                
                
            }
        })
        
    }
    
}

