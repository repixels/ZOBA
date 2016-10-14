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
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    required init?(map: Map) {
        
        let managedContext = SessionObjects.currentManageContext
        let entity = NSEntityDescription.entity(forEntityName: "MyUser", in: managedContext!)
        
        super.init(entity: entity!, insertInto: managedContext)
        
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
