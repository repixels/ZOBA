//
//  DummyDataBaseOperation.swift
//  ZOBA
//
//  Created by Angel mas on 6/11/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import Foundation
import CoreData

class DummyDataBaseOperation {
    
    static func saveUser( managedObjectContext moc : NSManagedObjectContext){
        
        
        let user = MyUser(managedObjectContext: moc, entityName: "MyUser")
        user.email = "email"
        user.userName = "mas"
        user.email = "email@mail.com"
        user.firstName = "first"
        user.password = "password"
        user.save()
    }
    
    
    static func saveVehicle(managedObjectContext moc : NSManagedObjectContext , name: String?){
        let vehicle = Vehicle(managedObjectContext: moc, entityName: "Vehicle")
        vehicle.name = name!
        vehicle.currentOdemeter = 30000
        vehicle.initialOdemeter = 20000
        
        vehicle.save()
        
        
    }

    static func saveTrackingType(managedObjectContext moc : NSManagedObjectContext , name: String?)
    {
        let trackingType = TrackingType(managedObjectContext: moc, entityName: "TrackingType")
        
        trackingType.name = name!
        
        trackingType.save()
        
        let measuringUnitObj = MeasuringUnit(managedObjectContext: moc, entityName: "MeasuringUnit")
        
        measuringUnitObj.name = "liters"
        measuringUnitObj.suffix = "L"
        
        measuringUnitObj.mutableSetValueForKey("trackingType").addObject(trackingType)
        
        measuringUnitObj.save()
        
        let serobj = Service(managedObjectContext:moc , entityName: "Service")
        
        serobj.name = name!
        serobj.save()
        serobj.mutableSetValueForKey("trackingType").addObject(trackingType)
                
    }
    
    static func saveServiceProvider(managedObjectContext moc : NSManagedObjectContext , name: String?)
    {
        let serviceProvider = ServiceProvider(managedObjectContext: moc, entityName: "ServiceProvider")
      
        serviceProvider.name = name!
        
        serviceProvider.save()
        
       }
}