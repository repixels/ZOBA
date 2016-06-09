//
//  MyUser.swift
//  ZOBA
//
//  Created by ZOBA on 6/7/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import Foundation
import CoreData
import ObjectMapper


class MyUser: NSManagedObject , Mappable {

// Insert code here to add functionality to your managed object subclass
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    required init?(_ map: Map) {
        
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appdelegate.managedObjectContext
        let entity = NSEntityDescription.entityForName("MyUser", inManagedObjectContext: managedContext)
        
        super.init(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        mapping(map)
        
    }
    
    func mapping(map: Map) {
        
        var vehicle : [Vehicle]?
        
        self.deviceToken <- map[""]
        self.email <- map[""]
        self.firstName <- map[""]
        self.lastName <- map[""]
        self.password <- map[""]
        self.phone <- map[""]
        self.userId <- map[""]
        self.userName <- map[""]
        vehicle <- map[""]
        
        if vehicle != nil
        {
            self.vehicle = NSSet(array: vehicle!)
        }
        else
        {
            self.vehicle = nil
        }
        
        
    }
}
