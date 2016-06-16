//
//  Vehicle+CoreDataProperties.swift
//  
//
//  Created by RE Pixels on 6/16/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Vehicle {

    @NSManaged var currentOdemeter: NSNumber?
    @NSManaged var initialOdemeter: NSNumber?
    @NSManaged var licensePlate: String?
    @NSManaged var name: String?
    @NSManaged var vehicleId: NSNumber?
    @NSManaged var isAdmin: NSNumber?
    @NSManaged var traclingData: NSSet?
    @NSManaged var trip: NSSet?
    @NSManaged var user: MyUser?
    @NSManaged var vehicleModel: VehicleModel?

}
