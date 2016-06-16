//
//  Service+CoreDataProperties.swift
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

extension Service {

    @NSManaged var name: String?
    @NSManaged var serviceId: NSNumber?
    @NSManaged var serviceProvderService: NSSet?
    @NSManaged var trackingType: NSSet?

}
