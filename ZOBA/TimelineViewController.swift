//
//  TimelineViewController.swift
//  ZOBA
//
//  Created by RE Pixels on 6/5/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import UIKit

class TimelineViewController: UITableViewController {

    let arr = ["date","oil","fuel","trip"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Welcome To ZOBA"
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.whiteColor(),
             NSFontAttributeName: UIFont(name: "Continuum Medium", size: 22)!]
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 70, 0)
        self.edgesForExtendedLayout = UIRectEdge.None
        self.extendedLayoutIncludesOpaqueBars = false
        self.automaticallyAdjustsScrollViewInsets = false

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200 ;
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9;
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        if (indexPath.row % 2 == 0 ){
            
            let cell = tableView.dequeueReusableCellWithIdentifier(DaySummaryCell.identifier, forIndexPath: indexPath) as! DaySummaryCell
        
            cell.currentOdemeter?.text = "1000 "
            cell.date!.text = "9"
            return cell
        }
        else if (indexPath.row % 3 == 0 ){
            let cell = tableView.dequeueReusableCellWithIdentifier(TripCell.identifier, forIndexPath: indexPath) as! TripCell
            
            cell.initialOdemeter!.text = "1000 "
            cell.distanceCovered!.text = "20 km"
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCellWithIdentifier(FuelCell.identifier, forIndexPath: indexPath) as! FuelCell
            cell.fuelAmount!.text = "50 Litters"
            cell.serviceProvider?.text = "fuel service"
           return cell
        
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
