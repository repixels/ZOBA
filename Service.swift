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
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    
    required init?( map: Map) {
        
        let managedContext = SessionObjects.currentManageContext
        let entity = NSEntityDescription.entity(forEntityName: "Service", in: managedContext!)
        
        super.init(entity: entity!, insertInto: managedContext)

    }
    
    func mapping(map: Map) {
        
        var serviceProviderServicesArray : [ServiceProviderServices]?
        var trackingTypesArray : [TrackingType]?
        
        self.name <- map["name"]
        self.serviceId <- map["id"]
        serviceProviderServicesArray <- map["serviceProviderServices"]
        trackingTypesArray <- map["trackingType"]
        
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
