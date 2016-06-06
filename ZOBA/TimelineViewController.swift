//
//  TimelineViewController.swift
//  ZOBA
//
//  Created by RE Pixels on 6/5/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import UIKit

class TimelineViewController: UITableViewController {

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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
