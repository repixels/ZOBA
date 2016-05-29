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

let isFirstTime = "isFirstTime"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    var locationManager = CLLocationManager()


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestAlwaysAuthorization()
            NSLog("Yalla")
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        if let window = window {
            window.backgroundColor = UIColor.whiteColor()
            window.rootViewController = generateOnBoardingWithImage()
            window.makeKeyAndVisible()
        }
        
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
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
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
        let trackingPage = OnboardingContentViewController(title: "Auto Trip Tracking", body: "Page body goes here.", image: UIImage(named: "tracking"), buttonText: "Text For Button") { () -> Void in
            // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
            if CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedAlways
            {
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                self.locationManager.requestAlwaysAuthorization()
                NSLog("Yalla")
            }
            else
            {
                NSLog("Not Yalla")
            }
        }
        
//        
        trackingPage.titleLabel.font = UIFont(name: "Continuum Medium" , size: 28.0)
        
        
        
        let autoTracking = OnboardingContentViewController(title: "Track your Consumption", body: "Page body goes here.", image: UIImage(named: "statistics"), buttonText: "Text For Button") { () -> Void in
            // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
            NSLog("Tracking Page")
        }
        
        autoTracking.titleLabel.font = UIFont(name: "Continuum Medium" , size: 28.0)
        
        let servicesPage = OnboardingContentViewController(title: "Push To Rescue", body: "Page body goes here.", image: UIImage(named: "rescue"), buttonText: "Text For Button") { () -> Void in
            // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
            NSLog("Tracking Page")
        }
        
        servicesPage.titleLabel.font = UIFont(name: "Continuum Medium" , size: 28.0)
        
        let tripsPage = OnboardingContentViewController(title: "Smart Tips", body: "Page body goes here.", image: UIImage(named: "tips"), buttonText: "Text For Button") { () -> Void in
            // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
            NSLog("Tracking Page")
        }
        
        tripsPage.titleLabel.font = UIFont(name: "Continuum Medium" , size: 28.0)
        
        let serviceCentersPage = OnboardingContentViewController(title: "Service Centers", body: "Page body goes here.", image: UIImage(named: "service-centers"), buttonText: "Text For Button") { () -> Void in
            // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
            NSLog("Tracking Page")
        }
        
        serviceCentersPage.titleLabel.font = UIFont(name: "Continuum Medium" , size: 28.0)
        
        let zobaPage = OnboardingContentViewController(title: "Zoba", body: "Your Car Pal", image: UIImage(named: "logo"), buttonText: "Lets Get Started") { () -> Void in
            // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
            NSLog("Tracking Page")
        }
        
        zobaPage.titleLabel.font = UIFont(name: "Continuum Medium" , size: 72.0)
        zobaPage.bodyLabel.font = UIFont(name: "Continuum Light" , size: 28.0)
        
        let onBoardView = ViewController()
        
        // Image
        let onboardingVC = OnboardingViewController(backgroundImage: UIImage(named: "street"), contents: [trackingPage, autoTracking, servicesPage,tripsPage,serviceCentersPage,onBoardView])
        
        onboardingVC.shouldFadeTransitions = true
        
        return onboardingVC
    }

}

