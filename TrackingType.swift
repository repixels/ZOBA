//
//  TrackingType.swift
//  ZOBA
//
//  Created by ZOBA on 6/7/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import Foundation
import CoreData
import ObjectMapper


class TrackingType: NSManagedObject , Mappable{

// Insert code here to add functionality to your managed object subclass
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    required init?(_ map: Map) {
        
        let managedContext = SessionObjects.currentManageContext
        let entity = NSEntityDescription.entityForName("TrackingType", inManagedObjectContext: managedContext)
        
        super.init(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
    }
    
    func mapping(map: Map) {
        
        
        self.name <- map["name"]
        self.typeId <- map["id"]
        self.measuringUnit <- map["measuringUnit"]
        self.service <- map["service"]
        self.trackingData <- map[""]
        
    }
}
