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
import SlideMenuControllerSwift
import AlamofireImage

class RegisterViewController: UIViewController,FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
    
    var managedObjectContext : NSManagedObjectContext!
    
    @IBOutlet weak var scrollview: UIScrollView!
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
    
    override func viewWillAppear(_ animated: Bool) {
        let notCenter = NotificationCenter.default
        notCenter.addObserver(self, selector: #selector (keyboardWillHide), name: 	NSNotification.Name.UIKeyboardWillHide, object: nil)
        notCenter.addObserver(self, selector: #selector (keyBoardWillAppear), name: 	NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        super.hideKeyboardWhenTappedAround()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        UIApplication.shared.statusBarStyle = .lightContent
        
        setViewBackgroundImage("street")
        
        facebookLoginButton.readPermissions = facebookReadPermissions
        facebookLoginButton.delegate = self
        facebookLoginButton.loginBehavior = FBSDKLoginBehavior.native
        
        
        
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: NSError!) {
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
            else
            {
                let userId = result.value(forKey: "id") as? String
                let firstName = result.value(forKey: "first_name") as? String
                let lastName = result.value(forKey: "last_name") as? String
                let userEmail = (result.value(forKey: "email") as? String)!
                let userName = userEmail.components(separatedBy: "@")[0]
                let userProfileImage = "http://graph.facebook.com/\(userId!)/picture?type=large"
                
                let  fbUser = MyUser(entity: SessionObjects.currentManageContext, insertIntoManagedObjectContext: "MyUser")
                fbUser.email = userEmail
                fbUser.userName = userName
                fbUser.firstName = firstName
                fbUser.lastName = lastName
                fbUser.phone = "1234567"
                fbUser.password = self.randomAlphaNumericString(6)
                let userWebService = UserWebservice(currentUser: fbUser)
                
                userWebService.getUserImageFromFacebook(userProfileImage, result: { (imageData, code) in
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
    
    func navigateToMain(_ userWebService: UserWebservice)
    {
        userWebService.registerWithFaceBook({ (user, code) in
            
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
                
                
                self.facebookLoginButton.isHidden = true
                
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    @IBAction func validateUserEmail(_ sender: AnyObject)
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
    
    @IBAction func validateFirstName(_ sender: AnyObject)
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
    
    @IBAction func validateLastName(_ sender: AnyObject)
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
    
    @IBAction func validateUserName(_ sender: AnyObject)
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
    
    @IBAction func validatePassword(_ sender: AnyObject)
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
        registerButton.isEnabled = true
        registerButton.alpha = 1.0
    }
    
    func disableRegisterButton()
    {
        registerButton.isEnabled = false
        registerButton.alpha = 0.7
    }
    
    func showErrorMessage(_ message:String , textField:HoshiTextField)
    {
        textField.borderInactiveColor = UIColor.redColor()
        textField.borderActiveColor = UIColor.redColor()
        textField.placeholderColor = UIColor.redColor()
        textField.placeholderLabel.text = message
        textField.placeholderLabel.sizeToFit()
        textField.placeholderLabel.alpha = 1.0
    }
    
    func hideErrorMessage(_ message : String , textField: HoshiTextField)
    {
        textField.borderInactiveColor = UIColor.greenColor()
        textField.borderActiveColor = UIColor.greenColor()
        textField.placeholderColor = UIColor.whiteColor()
        textField.placeholderLabel.text = message
    }
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        switch identifier {
        case "Register To Main":
            
            let managedUser = MyUser(entity: SessionObjects.currentManageContext , insertIntoManagedObjectContext:"MyUser")
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
                    
                    
                    
                    Defaults[.isLoggedIn] = true
                    Defaults[.useremail] = user!.email
                    Defaults[.launchCount] += 1
                    
                    
                    
                    
                    let homeStoryBoard : UIStoryboard = UIStoryboard(name: "HomeStoryBoard", bundle: nil)
                    let homeTabController : HomeViewController = homeStoryBoard.instantiateViewControllerWithIdentifier("HomeTabController") as! HomeViewController
                    
                    let sideMenuStoryBoard : UIStoryboard = UIStoryboard(name: "SideMenu", bundle: nil)
                    let sideMenuController : MenuTableViewController = sideMenuStoryBoard.instantiateViewControllerWithIdentifier("MenuViewController") as! MenuTableViewController
                    
                    
                    let slideMenuController = SlideMenuController(mainViewController: homeTabController, leftMenuViewController: sideMenuController)
                    slideMenuController.automaticallyAdjustsScrollViewInsets = true
                    
                    let app = UIApplication.sharedApplication().delegate as! AppDelegate
                    app.window?.rootViewController = slideMenuController
                    
                    //start detection if user has car
                    if SessionObjects.currentVehicle != nil {
                        SessionObjects.motionMonitor = LocationMonitor()
                        
                        SessionObjects.motionMonitor.startDetection()
                    }
                    
                    let serviceCenterWebSevice = ServiceProviderWebService()
                    serviceCenterWebSevice.getServiceProvider({ (serviceProvider, code) in
                        switch code{
                        case "success" :
                            print("serviceProviders count : \(serviceProvider.count)")
                            serviceProvider[0].save()
                        default :
                            print("failed")
                            DummyDataBaseOperation.populateOnlyOnce()
                        }
                    })
                    
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
    
    func generateErrorAlert(_ errorMessage: String?)
    {
        if errorMessage != nil
        {
            let alert = UIAlertController(title: "Registeration Failed", message: errorMessage!, preferredStyle: UIAlertControllerStyle.alert)
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
    //MARK: - keyboard
    func keyBoardWillAppear(_ notification : Notification){
        if let userInfo = (notification as NSNotification).userInfo {
            if let keyboardSize: CGSize =    (userInfo[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue.size {
                let contentInset = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height,  0.0);
                
                self.scrollview.contentInset = contentInset
                self.scrollview.scrollIndicatorInsets = contentInset
                
                self.scrollview.contentOffset = CGPoint(x: self.scrollview.contentOffset.x, y: 0 + (keyboardSize.height/2)) //set zero instead
                
            }
        }
        
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if let userInfo = (notification as NSNotification).userInfo {
            if let _: CGSize =  (userInfo[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue.size {
                let contentInset = UIEdgeInsets.zero;
                
                self.scrollview.contentInset = contentInset
                self.scrollview.scrollIndicatorInsets = contentInset
                self.scrollview.contentOffset = CGPoint(x: self.scrollview.contentOffset.x, y: self.scrollview.contentOffset.y)
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
}
