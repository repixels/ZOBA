//
//  Trip.swift
//  ZOBA
//
//  Created by ZOBA on 6/7/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import Foundation
import CoreData
import ObjectMapper


class Trip: NSManagedObject , Mappable {
    
    // Insert code here to add functionality to your managed object subclass
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    required init?(_ map: Map) {
        
        let managedContext = SessionObjects.currentManageContext
        let entity = NSEntityDescription.entityForName("Trip", inManagedObjectContext: managedContext)
        
        super.init(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
    }
    
    func mapping(map: Map) {
        
        var coordinatesArray : [TripCoordinate]?
        
        self.coveredKm <- map["coveredMilage"]
        self.initialOdemeter <- map["intialOdemeter"]
        self.tripId <- map["id"]
        self.vehicle = SessionObjects.currentVehicle != nil ? SessionObjects.currentVehicle! : nil
        
        coordinatesArray <- map["coordinates"]
        
        if coordinatesArray != nil
        {
            self.coordinates = NSSet(array: coordinatesArray!)
        }
        else
        {
            self.coordinates = nil
        }
        
        
        
    }
}
