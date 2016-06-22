//
//  TrackingData.swift
//  ZOBA
//
//  Created by ZOBA on 6/7/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import Foundation
import CoreData
import ObjectMapper


class TrackingData: NSManagedObject , Mappable {

// Insert code here to add functionality to your managed object subclass
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    required init?(_ map: Map) {
        
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appdelegate.managedObjectContext
        let entity = NSEntityDescription.entityForName("TrackingData", inManagedObjectContext: managedContext)
        
        super.init(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
//        mapping(map)
        
    }
    
    func mapping(map: Map) {
                
        self.dateAdded <- map["dateAdded"]
        self.dateModified <- map["dateModified"]
        self.initialOdemeter <- map["intialOdemeter"]
        self.trackingId <- map["id"]
        self.value <- map["value"]
        self.vehicle = SessionObjects.currentVehicle!
    }
}
