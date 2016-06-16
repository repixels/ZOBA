//
//  ServiceProvider+CoreDataProperties.swift
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

extension ServiceProvider {

    @NSManaged var email: String?
    @NSManaged var name: String?
    @NSManaged var serviceProviderId: NSNumber?
    @NSManaged var webSite: String?
    @NSManaged var address: ServiceProviderAddress?
    @NSManaged var branch: NSSet?
    @NSManaged var calender: NSSet?
    @NSManaged var headQuarter: ServiceProvider?
    @NSManaged var make: NSSet?
    @NSManaged var phone: NSSet?
    @NSManaged var serviceProviderServices: NSSet?

}
