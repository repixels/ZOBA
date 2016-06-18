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
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    required init?(_ map: Map) {
        
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appdelegate.managedObjectContext
        let entity = NSEntityDescription.entityForName("VehicleModel", inManagedObjectContext: managedContext)
        
        super.init(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        mapping(map)
        
    }
    
    func mapping(map: Map) {
        
        var featuresValueArray : [CarFeature]?
        
        self.vehicleModelId <- map[""]
        self.model <- map[""]
        self.trim <- map[""]
        //self.vehicle <- map[""]
        self.year <- map[""]
        featuresValueArray <- map[""]
        
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
