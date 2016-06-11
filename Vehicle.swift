//
//  Vehicle.swift
//  ZOBA
//
//  Created by ZOBA on 6/7/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import Foundation
import CoreData
import ObjectMapper

class Vehicle: NSManagedObject , Mappable{

// Insert code here to add functionality to your managed object subclass
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    required init?(_ map: Map) {
        
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appdelegate.managedObjectContext
        let entity = NSEntityDescription.entityForName("Vehicle", inManagedObjectContext: managedContext)
        
        super.init(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        mapping(map)
        
    }
    
    func mapping(map: Map) {
        
        var trackingDataArray : [TrackingData]?
        var tripsArray : [Trip]?
        var userArray: [MyUser]?
        
        
        self.currentOdemeter <- map[""]
        self.initialOdemeter <- map[""]
        self.isOwnedByThisUser <- map[""]
        self.licensePlate <- map[""]
        self.name <- map[""]
        self.vehicleModel <- map[""]
        trackingDataArray <- map[""]
        tripsArray <- map[""]
        userArray <- map[""]
        
        if trackingDataArray != nil
        {
            self.traclingData = NSSet(array: trackingDataArray!)
        }
        else
        {
            self.traclingData = nil
        }
        
        if tripsArray != nil
        {
            self.trip = NSSet(array: tripsArray!)
        }
        else
        {
            self.trip = nil
        }
        
        if userArray != nil
        {
            self.user = NSSet(array: userArray!)
        }
        else
        {
            self.user = nil
        }
    }
}
