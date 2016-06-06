//
//  TimelineViewController.swift
//  ZOBA
//
//  Created by RE Pixels on 6/5/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import UIKit
import BTNavigationDropdownMenu
import ChameleonFramework

class TimelineViewController: UIViewController {

      var menuView: BTNavigationDropdownMenu!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // Do any additional setup after loading the view.
        
        let items = ["Car one","car two","car two","car two"]

        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName : UIFont(name: "Continuum Medium", size: 22)! ,NSForegroundColorAttributeName: UIColor.whiteColor() ]
        
        
        self.navigationItem.titleView = menuView
        
        menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, title: items[0], items: items)
        menuView.cellHeight = 50
        menuView.cellBackgroundColor = UIColor.flatWhiteColor()
        menuView.cellSelectionColor = UIColor.flatSandColor()
        menuView.keepSelectedCellColor = true
        menuView.cellTextLabelColor = UIColor.flatWatermelonColor()
        menuView.cellTextLabelFont = UIFont(name: "Continuum Medium", size: 20)
        
        
        menuView.cellTextLabelAlignment = .Center // .Center // .Right // .Left
        
        menuView.arrowPadding = 10
        
        menuView.animationDuration = 0.5
        menuView.maskBackgroundColor = UIColor.blackColor()
        menuView.maskBackgroundOpacity = 0.3
        menuView.checkMarkImage = nil
        
        menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> () in
            print("Did select item at index: \(indexPath)")
            //self.selectedCellLabel.text = items[indexPath]
        }
        
        self.navigationItem.titleView = menuView
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
