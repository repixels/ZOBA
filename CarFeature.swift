//
//  CarFeature.swift
//  ZOBA
//
//  Created by ZOBA on 6/7/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import Foundation
import CoreData
import ObjectMapper


class CarFeature: NSManagedObject , Mappable {

// Insert code here to add functionality to your managed object subclass
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    required init?(map: Map) {
        
        let managedContext = SessionObjects.currentManageContext
        let entity = NSEntityDescription.entity(forEntityName: "CarFeature", in: managedContext!)
        
        super.init(entity: entity!, insertInto: managedContext)
        
    }
    
    func mapping(map: Map) {
        
        var featureValuesArray : [ModelFeatureValue]?
        
        self.carFeatureId <- map[""]
        self.name <- map[""]
        featureValuesArray <- map[""]

        if featureValuesArray != nil
        {
            self.featureValue = NSSet(array: featureValuesArray!)
        }
        else
        {
            self.featureValue = nil
        }
        
        
    }
}
