//
//  ServiceProviderCalender.swift
//  ZOBA
//
//  Created by ZOBA on 6/7/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import Foundation
import CoreData
import ObjectMapper


class ServiceProviderCalender: NSManagedObject , Mappable{

// Insert code here to add functionality to your managed object subclass
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    required init?(_ map: Map) {
        
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appdelegate.managedObjectContext
        let entity = NSEntityDescription.entityForName("ServiceProviderCalender", inManagedObjectContext: managedContext)
        
        super.init(entity: entity!, insertIntoManagedObjectContext: managedContext)
            }
    
    func mapping(map: Map) {
        
        self.calenderId <- map["id"]
        self.endingHour <- map["endingHour"]
        self.startingHour <- map["startingHour"]
        self.day <- map["dayDTO"]
        self.serviceProvider <- map[""]
        
    }
}
