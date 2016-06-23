//
//  MenuTableViewController.swift
//  ZOBA
//
//  Created by RE Pixels on 6/15/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class MenuTableViewController: UITableViewController {
    
    var homeStoryBoard : UIStoryboard?
    var userProfileStoryBoard : UIStoryboard?
    var fuelStoryBoard: UIStoryboard?
    var oilStoryBoard: UIStoryboard?
    var vehiclesStoryBoard: UIStoryboard?
    var tripsStoryBoard: UIStoryboard?
    var homeViewController : HomeViewController?
    var serviceProviderStoryBoard : UIStoryboard?
    
    @IBOutlet weak var initialsLabel: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var welcomeMessage: UILabel!
    
    @IBOutlet weak var backgroundColor: UITableViewCell!
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
        
        self.welcomeMessage.text = contextAwareTitle()?.capitalizedString
        loadUserImage()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.homeStoryBoard = UIStoryboard(name: "HomeStoryBoard", bundle: nil)
        self.userProfileStoryBoard =  UIStoryboard(name: "UserProfile", bundle: nil)
        self.fuelStoryBoard =  UIStoryboard(name: "Fuel", bundle: nil)
        self.oilStoryBoard =  UIStoryboard(name: "oil", bundle: nil)
        self.vehiclesStoryBoard =  UIStoryboard(name: "Vehicle", bundle: nil)
        self.tripsStoryBoard =  UIStoryboard(name: "VehicleTrips", bundle: nil)
        self.homeViewController = self.homeStoryBoard!.instantiateViewControllerWithIdentifier("HomeTabController") as? HomeViewController
        self.serviceProviderStoryBoard = UIStoryboard(name: "ServiceProvider", bundle: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 1:
            switch indexPath.row
            {
            case 0:
                
                self.homeViewController?.selectedIndex = 0
                self.slideMenuController()?.changeMainViewController(self.homeViewController!, close: true)
                break;
            default:
                self.slideMenuController()?.closeLeft()
            }
        case 2:
            switch indexPath.row
            {
            case 0:
                let userProfileNavigationController = self.userProfileStoryBoard!.instantiateViewControllerWithIdentifier("UserProfileNavigation")
                self.slideMenuController()?.changeMainViewController(userProfileNavigationController, close: true)
                break;
            case 1:
                let vehicleNavigationController = self.vehiclesStoryBoard?.instantiateViewControllerWithIdentifier("VehicleNavigation") as! UINavigationController
                vehicleNavigationController.title = "Your Vehicles"
             
                
                let vehicleTableVC = vehicleNavigationController.viewControllers[0] as! VehicleTableViewController
                
                let menuButton = UIBarButtonItem(image: UIImage(named: "menu"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MenuTableViewController.openSlideMenu) )
                
                menuButton.tintColor = UIColor.whiteColor()
                    
                vehicleTableVC.navigationItem.leftBarButtonItem = menuButton
              
                
                self.slideMenuController()?.changeMainViewController(vehicleNavigationController, close: true)
                break;
            default:
                self.slideMenuController()?.closeLeft()
                break;
            }
        case 3:
            switch indexPath.row
            {
            case 0:
                let homeTabBarController = self.homeStoryBoard?.instantiateViewControllerWithIdentifier("HomeTabController") as! HomeViewController
                homeTabBarController.selectedIndex = 1
                self.slideMenuController()?.changeMainViewController(homeTabBarController
                    , close: true)
            case 1:
                let homeTabBarController = self.homeStoryBoard?.instantiateViewControllerWithIdentifier("HomeTabController") as! HomeViewController
                homeTabBarController.selectedIndex = 3
                self.slideMenuController()?.changeMainViewController(homeTabBarController
                    , close: true)
                break
            case 2:
                let homeTabBarController = self.homeStoryBoard?.instantiateViewControllerWithIdentifier("HomeTabController") as! HomeViewController
                homeTabBarController.selectedIndex = 2
                self.slideMenuController()?.changeMainViewController(homeTabBarController
                    , close: true)
                break
            default:
                self.slideMenuController()?.closeLeft()
                break
            }
        case 4:
            let serviceProviderNavigationController = self.serviceProviderStoryBoard!.instantiateViewControllerWithIdentifier("ServiceProviders")
            self.slideMenuController()?.changeMainViewController(serviceProviderNavigationController, close: true)
            break;
        case 5:
            print("Logout Clicked")
            break
        default:
            self.closeLeft()
            break;
        }
    }
    
    // MARK: - Scroll View Events
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if self.tableView == scrollView {
            scrollView.alwaysBounceHorizontal = false
            scrollView.alwaysBounceVertical = true
        }
    }
    
    // MARK: - Table view data source

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func openSlideMenu()
    {
        slideMenuController()?.openLeft()
    }
    
    func loadUserImage()
    {
        if (SessionObjects.currentUser.image != nil)
        {
            profilePicture.image = UIImage(data: SessionObjects.currentUser.image!)
            initialsLabel.hidden = true
            
            profilePicture.layer.borderWidth = 2.5
            profilePicture.layer.masksToBounds = false
            profilePicture.layer.borderColor = UIColor.whiteColor().CGColor
            profilePicture.layer.cornerRadius = profilePicture.frame.height/2
            profilePicture.clipsToBounds = true
        }
        else
        {
            var userIntials = ""
            if SessionObjects.currentUser.firstName?.characters.first != nil
            {
                userIntials.append((SessionObjects.currentUser.firstName?.characters.first)!)
                
                
                if SessionObjects.currentUser.lastName?.characters.first != nil
                {
                    
                    userIntials.append((SessionObjects.currentUser.lastName?.characters.first)!)
                }
                else
                {
                    userIntials.append((SessionObjects.currentUser.lastName?.characters.last)!)
                    
                }
            }
            initialsLabel.hidden = false
            initialsLabel.text = userIntials.uppercaseString
        }
    }
    
    func contextAwareTitle() -> String?
    {
        let now = NSDate()
        let cal = NSCalendar.currentCalendar()
        let comps = cal.component(NSCalendarUnit.Hour, fromDate: now)
        
        switch comps {
        case 0 ... 12:
            self.backgroundColor.backgroundColor = UIColor.flatBlueColor()
            return "Good Morning"
        case 13 ... 17:
            self.backgroundColor.backgroundColor = UIColor.flatMintColor()
            return "Good Afternoon"
        case 18 ... 23:
            return "Good Evening"
        default:
            return "Welcome Back"
        }
    }

}


