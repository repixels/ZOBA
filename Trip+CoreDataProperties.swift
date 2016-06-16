//
//  Trip+CoreDataProperties.swift
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

extension Trip {

    @NSManaged var coveredKm: NSNumber?
    @NSManaged var image: NSData?
    @NSManaged var initialOdemeter: NSNumber?
    @NSManaged var tripId: NSNumber?
    @NSManaged var dateAdded: NSNumber?
    @NSManaged var averageSpeed: NSNumber?
    @NSManaged var coordinates: NSSet?
    @NSManaged var vehicle: Vehicle?

}
