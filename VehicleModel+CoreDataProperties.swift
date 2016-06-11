//
//  VehicleModel+CoreDataProperties.swift
//  ZOBA
//
//  Created by ZOBA on 6/7/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension VehicleModel {

    @NSManaged var vehicleModelId: NSNumber
    @NSManaged var featuresValue: NSSet?
    @NSManaged var model: Model?
    @NSManaged var trim: Trim?
    @NSManaged var vehicle: Vehicle?
    @NSManaged var year: Year?

}
