//
//  Vehicle+CoreDataProperties.swift
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

extension Vehicle {

    @NSManaged var currentOdemeter: NSNumber
    @NSManaged var initialOdemeter: NSNumber
    @NSManaged var isOwnedByThisUser: Bool
    @NSManaged var licensePlate: String?
    @NSManaged var name: String?
    @NSManaged var vehicleId: NSNumber
    @NSManaged var traclingData: NSSet?
    @NSManaged var trip: NSSet?
    @NSManaged var user: NSSet?
    @NSManaged var vehicleModel: VehicleModel?

}
