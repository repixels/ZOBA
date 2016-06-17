//
//  AppDelegate.swift
//  ZOBA
//
//  Created by RE Pixels on 5/27/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import UIKit
import CoreData
import Onboard
import CoreLocation
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit
import SwiftyUserDefaults
import AlamofireNetworkActivityIndicator

let isFirstTime = "isFirstTime"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    
    var window: UIWindow?
    var locationManager = CLLocationManager()
    var application : UIApplication?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        //Set Managed Context
        SessionObjects.currentManageContext = self.managedObjectContext
        self.application = application
        
        //AlamoFire Network Indicator
        NetworkActivityIndicatorManager.sharedManager.isEnabled = true
        NetworkActivityIndicatorManager.sharedManager.startDelay = 0
        NetworkActivityIndicatorManager.sharedManager.completionDelay = 0.5
        
        // Override point for customization after application launch.
        
        if(Defaults[.isLoggedIn] == false)
        {
            window = UIWindow(frame: UIScreen.mainScreen().bounds)
            if let window = window
            {
                window.backgroundColor = UIColor.whiteColor()
                window.rootViewController = generateOnBoardingWithImage()
                window.makeKeyAndVisible()
            }
        }
        else
        {
            let abstractDAO = AbstractDao(managedObjectContext: managedObjectContext)
            SessionObjects.currentUser = abstractDAO.selectAll(entityName: "MyUser")[0] as! MyUser
            
            let vehicleName = Defaults[.curentVehicleName]
            let vehicles = abstractDAO.selectByString(entityName: "Vehicle", AttributeName: "name", value: vehicleName!) as! [Vehicle]
            if(vehicles.count > 0){
                SessionObjects.currentVehicle = vehicles.first
            }
            else{
                print("no car selected")
            }
        }
        
        
        
        SessionObjects.motionMonitor = LocationMonitor(delegate: nil)
        SessionObjects.motionMonitor.stopTrip()
        SessionObjects.motionMonitor.startDetection()
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func application(application: UIApplication,
                     openURL url: NSURL,
                             sourceApplication: String?,
                             annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(
            application,
            openURL: url,
            sourceApplication: sourceApplication,
            annotation: annotation)
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "RE.ZOBA" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("ZOBA", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("zobadb.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    func generateOnBoardingWithImage() -> OnboardingViewController
    {
        let trackingPage = OnboardingContentViewController(title: "Auto Trip Tracking", body: "ZOBA Auto Tracks your Trips with your permission to collect data about your vehicle", image: UIImage(named: "tracking"), buttonText: "Enable Location") { () -> Void in
            // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
            if CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedAlways
            {
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                self.locationManager.requestAlwaysAuthorization()
            }
        }
        
        trackingPage.titleLabel.font = UIFont(name: "Continuum Medium" , size: 28.0)
        trackingPage.bodyLabel.font = UIFont(name: "Continuum Light" , size: 28.0)
        
        
        
        let autoTracking = OnboardingContentViewController(title: "Track your Consumption", body: "Are you a road runner with alot of busy days? No Worries we will keep you UpToDate with your vehicle consumption", image: UIImage(named: "statistics"), buttonText: "") { () -> Void in
            // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
            
        }
        
        autoTracking.titleLabel.font = UIFont(name: "Continuum Medium" , size: 28.0)
        autoTracking.bodyLabel.font = UIFont(name: "Continuum Light" , size: 28.0)
        
        let servicesPage = OnboardingContentViewController(title: "Push To Rescue", body: "Need a Quick Gas Fill Up or and Emergency Car Towing ? We are here for you", image: UIImage(named: "rescue"), buttonText: "") { () -> Void in
            // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
            NSLog("Services Page")
        }
        
        servicesPage.titleLabel.font = UIFont(name: "Continuum Medium" , size: 28.0)
        servicesPage.bodyLabel.font = UIFont(name: "Continuum Light" , size: 28.0)
        
        let tipsPage = OnboardingContentViewController(title: "Smart Tips", body: "Dont' know the ideal tire pressure for your vehicle? We are here for you", image: UIImage(named: "tips"), buttonText: "Enable Push Notifications") { () -> Void in
            // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
            NSLog("Tips Page")
            let notificationTypes: UIUserNotificationType = [UIUserNotificationType.Alert, UIUserNotificationType.Badge, UIUserNotificationType.Sound]
            let pushNotificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: nil)
            self.application!.registerUserNotificationSettings(pushNotificationSettings)
            self.application!.registerForRemoteNotifications()
            
        }
        tipsPage.titleLabel.font = UIFont(name: "Continuum Medium" , size: 28.0)
        tipsPage.bodyLabel.font = UIFont(name: "Continuum Light" , size: 28.0)
        
        let serviceCentersPage = OnboardingContentViewController(title: "Service Centers", body: "View the nearest Service Centers to you From their location to their working hours and the offered services", image: UIImage(named: "service-centers"), buttonText: "") { () -> Void in
            // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
            NSLog("Tracking Page")
        }
        
        serviceCentersPage.titleLabel.font = UIFont(name: "Continuum Medium" , size: 28.0)
        serviceCentersPage.bodyLabel.font = UIFont(name: "Continuum Light" , size: 28.0)
        
        let zobaPage = OnboardingContentViewController(title: "Zoba", body: "Your Car Pal", image: UIImage(named: "logo"), buttonText: "Lets Get Started") { () -> Void in
            // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
            NSLog("Tracking Page")
            self.handleOnboardingCompletion()
        }
        
        zobaPage.titleLabel.font = UIFont(name: "Continuum Medium" , size: 72.0)
        zobaPage.bodyLabel.font = UIFont(name: "Continuum Light" , size: 28.0)
        zobaPage.actionButton.tintColor = UIColor.blueColor()
        zobaPage.actionButton.setTitleColor(UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0), forState: UIControlState.Normal)
        
        
        // Image
        let onboardingVC = OnboardingViewController(backgroundImage: UIImage(named: "street"), contents: [trackingPage, autoTracking, servicesPage,tipsPage,serviceCentersPage,zobaPage])
        
        onboardingVC.shouldFadeTransitions = true
        onboardingVC.allowSkipping = true
        onboardingVC.fadeSkipButtonOnLastPage = true
        onboardingVC.skipHandler = {
            self.handleOnboardingCompletion()
        };
        
        
        
        return onboardingVC
    }
    
    func handleOnboardingCompletion() {
        // Now that we are done onboarding, we can set in our NSUserDefaults that we've onboarded now, so in the
        // future when we launch the application we won't see the onboarding again.
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: isFirstTime)
        
        // Setup the normal root view controller of the application, and set that we want to do it animated so that
        // the transition looks nice from onboarding to normal app.
        setupNormalRootVC(true)
    }
    
    func setupNormalRootVC(animated : Bool) {
        // Here I'm just creating a generic view controller to represent the root of my application.
        let loginViewController = UIViewController()
        
        // If we want to animate it, animate the transition - in this case we're fading, but you can do it
        // however you want.
        if animated {
            UIView.transitionWithView(self.window!, duration: 0.5, options:.TransitionCrossDissolve, animations: { () -> Void in
                let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let initialViewControlleripad : LoginViewController = mainStoryboardIpad.instantiateViewControllerWithIdentifier("mainStoryBoard") as! LoginViewController
                initialViewControlleripad.managedObjectContext = self.managedObjectContext
                let loginNavigationController = UINavigationController()
                loginNavigationController.addChildViewController(initialViewControlleripad)
                self.window!.rootViewController = loginNavigationController
                }, completion:nil)
        }
            
            // Otherwise we just want to set the root view controller normally.
        else {
            self.window?.rootViewController = loginViewController;
        }
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
        var tokenString = ""
        
        for i in 0..<deviceToken.length {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        Defaults[.deviceToken] = tokenString
        print("tokenString: \(tokenString)")
        print("Device Token is : \(deviceToken)")
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        print(userInfo)
    }
    
    
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        
        
        //get current active view controller
        let tabController = application.windows[0].rootViewController as! UITabBarController
        let navigationController = tabController.selectedViewController as! UINavigationController
        let activeViewCont = navigationController.visibleViewController
//        SessionObjects.motionMonitor.showStartTripAlert(viewController: activeViewCont!)
//        
//        
        
        switch notification.category! {
        case "zoba_start_motion":
            print("delegate : start motion")
            SessionObjects.motionMonitor.showStartTripAlert(viewController: activeViewCont!)
        case "zoba_stop_motion":
            
            print("delegate : stop motion")
            SessionObjects.motionMonitor.showStopTripAlert(viewController: activeViewCont!)
        case "zoba_check_if_running":
            print("delegate : check if running")
            SessionObjects.motionMonitor.checkIfMoving()
            
        default:
            print("not motion notification")
        }
        
        
        
        
    }
}

