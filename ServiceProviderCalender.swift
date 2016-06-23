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
        
        let managedContext = SessionObjects.currentManageContext
        let entity = NSEntityDescription.entityForName("ServiceProviderCalender", inManagedObjectContext: managedContext)
        
        super.init(entity: entity!, insertIntoManagedObjectContext: managedContext)
    }
    
    func mapping(map: Map) {
        
        var endingHRStr : String?
        var startingHRStr : String?
        
        endingHRStr <- map["endingHour"]
        startingHRStr <- map["startingHour"]
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "hh:mm:ss"
        
        
        if endingHRStr != nil {
            self.endingHour      = formatter.dateFromString(endingHRStr!)!.timeIntervalSinceNow
        }
        
        if startingHRStr != nil {
            self.startingHour      = formatter.dateFromString(startingHRStr!)!.timeIntervalSinceNow
        }
        
        
        self.calenderId <- map["id"]
        
        self.day <- map["dayDTO"]
        self.serviceProvider <- map[""]
        
    }
}
