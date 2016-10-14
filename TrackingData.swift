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
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    required init?(map: Map) {
        
        let managedContext = SessionObjects.currentManageContext
        let entity = NSEntityDescription.entity(forEntityName: "TrackingData", in: managedContext!)
        
        super.init(entity: entity!, insertInto: managedContext)
        
    }
    
    func mapping(map: Map) {
                
        self.dateAdded <- map["dateAdded"]
        self.dateModified <- map["dateModified"]
        self.initialOdemeter <- map["intialOdemeter"]
        self.trackingId <- map["id"]
        self.value <- map["value"]
        self.vehicle = SessionObjects.currentVehicle != nil ? SessionObjects.currentVehicle! : nil
    }
}
