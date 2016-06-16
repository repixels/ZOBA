//
//  VehicleModel+CoreDataProperties.swift
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

extension VehicleModel {

    @NSManaged var vehicleModelId: NSNumber?
    @NSManaged var featuresValue: NSSet?
    @NSManaged var model: Model?
    @NSManaged var trim: Trim?
    @NSManaged var vehicle: Vehicle?
    @NSManaged var year: Year?

}
