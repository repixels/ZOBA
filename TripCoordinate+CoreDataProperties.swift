//
//  TripCoordinate+CoreDataProperties.swift
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

extension TripCoordinate {

    @NSManaged var coordinateId: NSNumber?
    @NSManaged var latitude: NSDecimalNumber?
    @NSManaged var longtitude: NSDecimalNumber?
    @NSManaged var trip: Trip?

}
