//
//  Days.swift
//  ZOBA
//
//  Created by ZOBA on 6/7/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import Foundation
import CoreData
import ObjectMapper


class Days: NSManagedObject , Mappable {
    
    // Insert code here to add functionality to your managed object subclass
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    required init?(_ map: Map) {
        
        let managedContext = SessionObjects.currentManageContext
        let entity = NSEntityDescription.entityForName("Days", inManagedObjectContext: managedContext)
        
        super.init(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
    }
    
    func mapping(map: Map) {
        
        var calendars : [ServiceProviderCalender]?
        
        self.dayId <- map["dayId"]
        self.name <- map["dayName"]
        calendars <- map["serviceProviderCalendars"]
        if map.mappingType == .ToJSON {}
        else{
            if calendars != nil
            {
                self.calender = NSSet(array: calendars!)
            }
            else
            {
                self.calender = nil
            }
        }
    }
}
