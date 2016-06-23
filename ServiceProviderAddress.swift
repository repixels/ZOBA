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
        
        let managedContext = SessionObjects.currentManageContext
        let entity = NSEntityDescription.entityForName("ServiceProviderAddress", inManagedObjectContext: managedContext)
        
        super.init(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
    }
    
    func mapping(map: Map) {
        
        self.addressId <- map["id"]
        self.city <- map["city"]
        self.country <- map["country"]
        self.landMark <- map["landmark"]
        self.latitude <- map["latitude"]
        self.longtiude <- map["longitude"]
        self.others <- map["others"]
        self.postalCode <- map["postalCode"]
        self.street <- map["street"]
        self.serviceProvider <- map["serviceProvider"]
    }
}
