//
//  MeasuringUnit.swift
//  ZOBA
//
//  Created by ZOBA on 6/7/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import Foundation
import CoreData
import ObjectMapper


class MeasuringUnit: NSManagedObject , Mappable {

// Insert code here to add functionality to your managed object subclass
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    required init?(_ map: Map) {
        
        let managedContext = SessionObjects.currentManageContext
        let entity = NSEntityDescription.entityForName("MeasuringUnit", inManagedObjectContext: managedContext)
        
        super.init(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
    }
    
    func mapping(map: Map) {
        
        var trackingTypesArray : [TrackingType]?
        
        self.name <- map[""]
        self.suffix <- map[""]
        self.unitId <- map[""]
        trackingTypesArray <- map[""]
        
        if trackingTypesArray != nil
        {
            self.trackingType = NSSet(array: trackingTypesArray!)
        }
        else
        {
            self.trackingType = nil
        }
    }
}
