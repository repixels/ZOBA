//
//  MeasuringUnit+CoreDataProperties.swift
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

extension MeasuringUnit {

    @NSManaged var name: String?
    @NSManaged var suffix: String?
    @NSManaged var unitId: NSNumber?
    @NSManaged var trackingType: NSSet?

}
