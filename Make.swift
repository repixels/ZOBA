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
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    

    required init?( map: Map) {

        
        let managedContext = SessionObjects.currentManageContext
        let entity = NSEntityDescription.entity(forEntityName: "Make", in: managedContext!)
        
        super.init(entity: entity!, insertInto: managedContext)
        
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
