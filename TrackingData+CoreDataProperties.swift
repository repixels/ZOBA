//
//  TrackingData+CoreDataProperties.swift
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

extension TrackingData {

    @NSManaged var dateAdded: NSDate?
    @NSManaged var dateModified: NSDate?
    @NSManaged var initialOdemeter: NSNumber?
    @NSManaged var trackingId: NSNumber?
    @NSManaged var value: String?
    @NSManaged var serviceProviderName: String?
    @NSManaged var trackingType: TrackingType?
    @NSManaged var vehicle: Vehicle?

}
