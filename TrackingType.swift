//
//  TrackingType.swift
//  ZOBA
//
//  Created by ZOBA on 6/7/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import Foundation
import CoreData
import ObjectMapper


class TrackingType: NSManagedObject , Mappable{

// Insert code here to add functionality to your managed object subclass
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    required init?(_ map: Map) {
        
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appdelegate.managedObjectContext
        let entity = NSEntityDescription.entityForName("TrackingType", inManagedObjectContext: managedContext)
        
        super.init(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        mapping(map)
        
    }
    
    func mapping(map: Map) {
        
        var servicesArray : [Service]?
        
        self.name <- map[""]
        self.typeId <- map[""]
        self.measuringUnit <- map[""]
        self.trackingData <- map[""]
        servicesArray <- map[""]
        
        if servicesArray != nil
        {
            self.service = NSSet(array: servicesArray!)
        }
        else
        {
            self.service = nil
        }
        
    }
}
