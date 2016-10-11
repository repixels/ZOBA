//
//  VehicleModel.swift
//  ZOBA
//
//  Created by ZOBA on 6/7/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import Foundation
import CoreData
import ObjectMapper

class VehicleModel: NSManagedObject , Mappable{

// Insert code here to add functionality to your managed object subclass
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    required init?(map: Map) {
        
        let managedContext = SessionObjects.currentManageContext
        let entity = NSEntityDescription.entity(forEntityName: "VehicleModel", in: managedContext!)
        
        super.init(entity: entity!, insertInto: managedContext)
        
    }
    
    func mapping(map: Map) {
        
        var featuresValueArray : [CarFeature]?
        
        self.vehicleModelId <- map["id"]
        self.model <- map["model"]
        self.trim <- map["trim"]
        self.vehicle <- map[""]
        self.year <- map["year"]
        featuresValueArray <- map["features"]
        
        if featuresValueArray != nil
        {
            self.featuresValue = NSSet(array: featuresValueArray!)
        }
        else
        {
            self.featuresValue = nil
        }
        
        
    }
}
