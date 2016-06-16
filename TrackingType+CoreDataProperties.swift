//
//  TrackingType+CoreDataProperties.swift
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

extension TrackingType {

    @NSManaged var name: String?
    @NSManaged var typeId: NSNumber?
    @NSManaged var measuringUnit: MeasuringUnit?
    @NSManaged var service: Service?
    @NSManaged var trackingData: NSSet?

}
