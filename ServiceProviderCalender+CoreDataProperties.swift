//
//  ServiceProviderCalender+CoreDataProperties.swift
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

extension ServiceProviderCalender {

    @NSManaged var calenderId: NSNumber?
    @NSManaged var endingHour: NSNumber?
    @NSManaged var startingHour: NSNumber?
    @NSManaged var day: Days?
    @NSManaged var serviceProvider: ServiceProvider?

}
