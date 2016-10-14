//
//  ServiceProviderAddress.swift
//  ZOBA
//
//  Created by ZOBA on 6/7/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import Foundation
import CoreData
import ObjectMapper


class ServiceProviderAddress: NSManagedObject , Mappable{
    
    // Insert code here to add functionality to your managed object subclass
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    required init?( map: Map) {
        
        let managedContext = SessionObjects.currentManageContext
        let entity = NSEntityDescription.entity(forEntityName: "ServiceProviderAddress", in: managedContext!)
        
        super.init(entity: entity!, insertInto: managedContext)
        
    }
    
    func mapping( map: Map) {
        
        var longtitudeStr = ""
        longtitudeStr <- map["longitude"]
        var latitudeStr = ""
        latitudeStr <- map["latitude"]
        
        
        
        self.addressId <- map["id"]
        self.city <- map["city"]
        self.country <- map["country"]
        self.landMark <- map["landmark"]
        self.latitude = NSDecimalNumber(string: latitudeStr)
        self.longtiude = NSDecimalNumber(string: longtitudeStr)
        self.others <- map["others"]
        self.postalCode <- map["postalCode"]
        self.street <- map["street"]
        self.serviceProvider <- map["serviceProvider"]
    }
}
