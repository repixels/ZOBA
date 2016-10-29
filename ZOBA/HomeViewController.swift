//
//  HomeViewController.swift
//  ZOBA
//
//  Created by RE Pixels on 6/5/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import UIKit
import FoldingTabBar

class HomeViewController: YALFoldingTabBarController ,YALTabBarDelegate {//,YALTabBarInteracting {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareTabBar()
        self.tabBarView.delegate = self
        
       
        
        UINavigationBar.appearance().setBackgroundImage(UIImage(named: "nav-background"), for: .default)
        UINavigationBar.appearance().tintColor = UIColor.white
        
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
    
    func prepareTabBar()
    {
        
        let item1 = YALTabBarItem(itemImage: UIImage(named: "home-icon"), leftItemImage: UIImage(named: "add-vehicle"), rightItemImage: UIImage(named: "auto-report"))
        
        let item2 = YALTabBarItem(itemImage: UIImage(named: "add-trip"), leftItemImage:nil, rightItemImage: nil)
        
        self.leftBarItems = [item1, item2]
        
        let item3 = YALTabBarItem(itemImage: UIImage(named: "add-fuel"), leftItemImage: nil, rightItemImage: nil)
        
        let item4 = YALTabBarItem(itemImage: UIImage(named: "add-oil"), leftItemImage: nil, rightItemImage: nil)
        
        self.rightBarItems = [item3, item4]
      
        
        self.centerButtonImage = UIImage(named: "plus_icon")!
        self.selectedIndex = 1
        

        self.tabBarView.backgroundColor = UIColor(red: 94.0/255.0, green: 91.0/255.0, blue: 149.0/255.0, alpha: 1)
        
        self.tabBarView.tabBarColor = UIColor(red: 72.0/255.0, green: 211.0/255.0, blue: 178.0/255.0, alpha: 1)
        
        self.tabBarView.offsetForExtraTabBarItems = YALForExtraTabBarItemsDefaultOffset
        self.tabBarView.extraTabBarItemHeight = YALExtraTabBarItemsDefaultHeight
        self.tabBarViewHeight = YALTabBarViewDefaultHeight
        self.tabBarView.tabBarViewEdgeInsets = YALTabBarViewHDefaultEdgeInsets
        self.tabBarView.tabBarItemsEdgeInsets = YALTabBarViewItemsDefaultEdgeInsets
     
        self.selectedIndex = 0
    }
    
    
}
