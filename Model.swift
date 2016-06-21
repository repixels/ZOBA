//
//  Model.swift
//  ZOBA
//
//  Created by ZOBA on 6/7/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import Foundation
import CoreData
import ObjectMapper


class Model: NSManagedObject , Mappable {
    
    // Insert code here to add functionality to your managed object subclass
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    required init?(_ map: Map) {
        
        let managedContext = NSManagedObject.getPrivateContext() //SessionObjects.managedObjectContext
        let entity = NSEntityDescription.entityForName("Model", inManagedObjectContext: managedContext)
        
        super.init(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        //        mapping(map)
        
    }
    
    func mapping(map: Map) {
        
        var vehicleModelsArray : [VehicleModel]?
        
        self.modelId <- map["id"]
        self.name <- map["name"]
        self.niceName <- map["niceName"]
        self.make <- map["make"]
        vehicleModelsArray <- map["vehicleModel"]
        
        if(vehicleModelsArray != nil)
        {
            self.vehicleModel = NSSet(array: vehicleModelsArray!)
        }
        else
        {
            self.vehicleModel = nil
        }
        
    }
}
