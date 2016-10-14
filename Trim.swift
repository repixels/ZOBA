//
//  Trim.swift
//  ZOBA
//
//  Created by ZOBA on 6/7/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import Foundation
import CoreData
import ObjectMapper


class Trim: NSManagedObject , Mappable {
    
    // Insert code here to add functionality to your managed object subclass
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    required init?(map: Map) {
        
        let managedContext = SessionObjects.currentManageContext
        let entity = NSEntityDescription.entity(forEntityName: "Trim", in: managedContext!)
        
        super.init(entity: entity!, insertInto: managedContext)
        
    }
    
    func mapping(map: Map)
    {
        var vehicleModelsArray : [VehicleModel]?
        
        self.name <- map["name"]
        self.trimId <- map["id"]
        vehicleModelsArray <- map["vehicleModels"]
        
        if vehicleModelsArray != nil
        {
            self.vehicleModel = NSSet(array: vehicleModelsArray!)
        }
        else
        {
            self.vehicleModel = nil
        }
        
    }
}
