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
        
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appdelegate.managedObjectContext
        let entity = NSEntityDescription.entityForName("Year", inManagedObjectContext: managedContext)
        
        super.init(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        mapping(map)
        
    }
    
    
    func mapping(map: Map) {
        
        var vehicleModelsArrray : [VehicleModel]?
        
        self.name <- map[""]
        self.yearId <- map[""]
        vehicleModelsArrray <- map[""]
        
        if vehicleModelsArrray != nil
        {
            self.vehicleModel = NSSet(array: vehicleModelsArrray!)
        }
        else
        {
            self.vehicleModel = nil
        }
    }
}
