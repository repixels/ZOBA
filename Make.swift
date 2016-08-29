//
//  Make.swift
//  ZOBA
//
//  Created by ZOBA on 6/7/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import Foundation
import CoreData
import ObjectMapper


class Make: NSManagedObject , Mappable {
    
    // Insert code here to add functionality to your managed object subclass
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    required init?(_ map: Map) {
        
        let managedContext = SessionObjects.currentManageContext
        let entity = NSEntityDescription.entityForName("Make", inManagedObjectContext: managedContext)
        
        super.init(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
    }
    
    func mapping(map: Map) {
        
        var modelsArray : [Model]?
        var serviceProvidersArray : [ServiceProvider]?
        
        self.makeId <- map["id"]
        self.name <- map["name"]
        self.niceName <- map["niceName"]
        modelsArray <- map[""]
        serviceProvidersArray <- map["serviceProviders"]
        
        if modelsArray != nil
        {
            self.model = NSSet(array: modelsArray!)
        }
        else
        {
            self.model = nil
        }
        
        if(serviceProvidersArray != nil)
        {
            self.serviceProvider = NSSet(array: serviceProvidersArray!)
        }
        else
        {
            self.serviceProvider = nil
        }
        
        
        
    }
}
