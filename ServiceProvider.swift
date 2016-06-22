//
//  ServiceProvider.swift
//  ZOBA
//
//  Created by ZOBA on 6/7/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import Foundation
import CoreData
import ObjectMapper


class ServiceProvider: NSManagedObject , Mappable {
    
    // Insert code here to add functionality to your managed object subclass
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    required init?(_ map: Map) {
        
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appdelegate.managedObjectContext
        let entity = NSEntityDescription.entityForName("ServiceProvider", inManagedObjectContext: managedContext)
        
        super.init(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        
        
    }
    
    func mapping(map: Map) {
        
        var branchesArray : [ServiceProvider]?
        var phonesArray : [ServiceProviderPhone]?
        var calendarsArray : [ServiceProviderCalender]?
        var makesArray : [Make]?
        
        var serviceProviderServicesArray : [ServiceProviderServices]?
        
        
        self.email <- map["email"]
        self.name <- map["name"]
        self.serviceProviderId <- map["id"]
        self.webSite <- map["website"]
        self.address <- map["address"]
        self.headQuarter <- map[""]
        branchesArray <- map[""]
        phonesArray <- map["serviceProviderPhones"]
        calendarsArray <- map["serviceProviderCalendars"]
        makesArray <- map["makes"]
        serviceProviderServicesArray <- map["serviceProviderServices"]
        
        if branchesArray != nil
        {
            self.branch = NSSet(array: branchesArray!)
        }
        else
        {
            self.branch = nil
        }
        
        if phonesArray != nil
        {
            self.phone = NSSet(array: phonesArray!)
        }
        else
        {
            self.phone = nil
        }
        
        if calendarsArray != nil
        {
            self.calender = NSSet(array: calendarsArray!)
        }
        else
        {
            self.calender = nil
        }
        
        if makesArray != nil
        {
            self.make = NSSet(array: makesArray!)
        }
        else
        {
            self.make = nil
        }
        
        
        
        if serviceProviderServicesArray != nil
        {
            self.serviceProviderServices = NSSet(array: serviceProviderServicesArray!)
        }
        else
        {
            self.serviceProviderServices = nil
        }
        
        
        
    }
}
