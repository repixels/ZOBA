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
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    required init?(map: Map) {
        
        
        let managedContext = SessionObjects.currentManageContext
        let entity = NSEntityDescription.entity(forEntityName: "Year", in: managedContext!)
        
        super.init(entity: entity!, insertInto: managedContext)
        
    }
    
    
    func mapping(map: Map) {
        
        var vehicleModelsArrray : [VehicleModel]?
        var nameInt : Int = 0
        
        nameInt <- map["name"]
        self.name = NSNumber(value: nameInt)
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
