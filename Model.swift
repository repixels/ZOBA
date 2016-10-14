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
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    
    required init?( map: Map) {
        
        let managedContext = SessionObjects.currentManageContext
        let entity = NSEntityDescription.entity(forEntityName: "Model", in: managedContext!)
        
        super.init(entity: entity!, insertInto: managedContext)
        
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
