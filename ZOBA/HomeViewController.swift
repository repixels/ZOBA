//
//  HomeViewController.swift
//  ZOBA
//
//  Created by RE Pixels on 6/5/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import UIKit
import FoldingTabBar

class HomeViewController: YALFoldingTabBarController ,YALTabBarViewDelegate ,YALTabBarInteracting {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarView.delegate = self
        prepareTabBar()
        

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
        
        let item1 = YALTabBarItem(itemImage: UIImage(named: "nearby_icon"), leftItemImage: UIImage(named: "nearby_icon"), rightItemImage: UIImage(named: "nearby_icon"))
        let item2 = YALTabBarItem(itemImage: UIImage(named: "edit_icon"), leftItemImage: UIImage(named: "nearby_icon"), rightItemImage: UIImage(named: "nearby_icon"))
        let item3 = YALTabBarItem(itemImage: UIImage(named: "search_icon"), leftItemImage: UIImage(named: "nearby_icon"), rightItemImage: UIImage(named: "nearby_icon"))
        let item4 = YALTabBarItem(itemImage: UIImage(named: "new_chat_icon"), leftItemImage: UIImage(named: "nearby_icon"), rightItemImage: UIImage(named: "nearby_icon"))
        
        self.tabBarView.offsetForExtraTabBarItems = YALForExtraTabBarItemsDefaultOffset
        self.leftBarItems = [item1, item2]
        self.rightBarItems = [item3, item4]
        self.centerButtonImage = UIImage(named: "plus_icon")
        self.tabBarViewHeight = 80.0
        self.tabBarView.backgroundColor = UIColor.init(red: 94.0/255.0, green: 91.0/255.0 , blue: 178.0/255.0, alpha: 1.0)
        
        self.tabBarView.tabBarColor = UIColor.init(red: 72.0/255.0, green: 211.0/255.0 , blue: 178.0/255.0, alpha: 1.0)
        
        self.tabBarView.extraTabBarItemHeight = 60.0
        self.tabBarView.tabBarViewEdgeInsets = YALTabBarViewHDefaultEdgeInsets
        self.tabBarView.tabBarItemsEdgeInsets = YALTabBarViewItemsDefaultEdgeInsets
        
    }
    
    func tabBarViewDidExpand(tabBarView: YALFoldingTabBar!) {
        print("Hello")
        
    }    
    

}
