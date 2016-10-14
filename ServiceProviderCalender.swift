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
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    required init?(map: Map) {
        
        let managedContext = SessionObjects.currentManageContext
        let entity = NSEntityDescription.entity(forEntityName: "ServiceProviderCalender", in: managedContext!)
        
        super.init(entity: entity!, insertInto: managedContext)
    }
    
    func mapping(map: Map) {
        
        var endingHRStr : String?
        var startingHRStr : String?
        
        endingHRStr <- map["endingHour"]
        startingHRStr <- map["startingHour"]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm"
        
        
        if endingHRStr != nil {
            
            self.endingHour = formatter.date(from: endingHRStr!)?.timeIntervalSince1970 as NSNumber?
        }
        
        if startingHRStr != nil {
            self.startingHour      = formatter.date(from: startingHRStr!)?.timeIntervalSince1970 as NSNumber?
            
        }
        
        
        self.calenderId <- map["id"]
        
        self.day <- map["dayDTO"]
        self.serviceProvider <- map[""]
        
    }
}
