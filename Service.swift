//
//  Service.swift
//  ZOBA
//
//  Created by ZOBA on 6/7/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import Foundation
import CoreData
import ObjectMapper


class Service: NSManagedObject , Mappable {

// Insert code here to add functionality to your managed object subclass
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    required init?(_ map: Map) {
        
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appdelegate.managedObjectContext
        let entity = NSEntityDescription.entityForName("Service", inManagedObjectContext: managedContext)
        
        super.init(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
//        mapping(map)
        
    }
    
    func mapping(map: Map) {
        
        var serviceProviderServicesArray : [ServiceProviderServices]?
        var trackingTypesArray : [TrackingType]?
        
        self.name <- map[""]
        self.serviceId <- map[""]
        serviceProviderServicesArray <- map[""]
        trackingTypesArray <- map[""]
        
        if serviceProviderServicesArray != nil
        {
            self.serviceProvderService = NSSet(array: serviceProviderServicesArray!)
        }
        else
        {
            self.serviceProvderService = nil
        }
        
        if trackingTypesArray != nil
        {
            self.trackingType = NSSet(array: trackingTypesArray!)
        }
        else
        {
            self.trackingType = nil
        }
    }
    
}
