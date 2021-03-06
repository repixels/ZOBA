//
//  Year.swift
//  ZOBA
//
//  Created by ZOBA on 6/7/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import Foundation
import CoreData
import ObjectMapper


class Year: NSManagedObject , Mappable
{
    
    // Insert code here to add functionality to your managed object subclass
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    required init?(_ map: Map) {
        
        
        let managedContext = SessionObjects.currentManageContext
        let entity = NSEntityDescription.entityForName("Year", inManagedObjectContext: managedContext)
        
        super.init(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
    }
    
    
    func mapping(map: Map) {
        
        var vehicleModelsArrray : [VehicleModel]?
        var nameInt : Int = 0
        
        nameInt <- map["name"]
        self.name = NSNumber(integer: nameInt)
        self.yearId <- map["id"]
        
        vehicleModelsArrray <- map["vehicleModel"]
        
        if vehicleModelsArrray != nil
        {
            self.vehicleModel = NSSet(array: vehicleModelsArrray!)
        }
        else
        {
            self.vehicleModel = nil
        }
        self.vehicleModel = nil
    }
}
