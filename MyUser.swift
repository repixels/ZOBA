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
        
        let managedContext = SessionObjects.currentManageContext
        let entity = NSEntityDescription.entityForName("MyUser", inManagedObjectContext: managedContext)
        
        super.init(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
    }
    
    func mapping(map: Map) {
        
        var vehicle : [Vehicle]?
        
        self.deviceToken <- map["devices"]
        self.email <- map["email"]
        self.firstName <- map["firstName"]
        self.lastName <- map["lastName"]
        self.password <- map["password"]
        self.phone <- map["phone"]
        self.userId <- map["id"]
        self.userName <- map["username"]
        vehicle <- map["vehicles"]
        
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
