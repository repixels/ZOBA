//
//  TripCoordinate+CoreDataProperties.swift
//  ZOBA
//
//  Created by RE Pixels on 6/18/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension TripCoordinate {

    @NSManaged var coordinateId: NSNumber?
    @NSManaged var latitude: NSDecimalNumber?
    @NSManaged var longtitude: NSDecimalNumber?
    @NSManaged var address: String?
    @NSManaged var trip: Trip?

}
