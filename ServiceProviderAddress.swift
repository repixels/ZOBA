//
//  ServiceProviderAddress.swift
//  ZOBA
//
//  Created by ZOBA on 6/7/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import Foundation
import CoreData
import ObjectMapper


class ServiceProviderAddress: NSManagedObject , Mappable{

// Insert code here to add functionality to your managed object subclass
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    required init?(_ map: Map) {
        
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appdelegate.managedObjectContext
        let entity = NSEntityDescription.entityForName("ServiceProviderAddress", inManagedObjectContext: managedContext)
        
        super.init(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
//        mapping(map)
        
    }
    
    func mapping(map: Map) {
        
        self.addressId <- map["id"]
        self.city <- map[""]
        self.country <- map[""]
        self.landMark <- map[""]
        self.latitude <- map[""]
        self.longtiude <- map[""]
        self.others <- map[""]
        self.postalCode <- map[""]
        self.street <- map[""]
        self.serviceProvider <- map[""]
    }
}
