//
//  ServiceProviderAddress+CoreDataProperties.swift
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

extension ServiceProviderAddress {

    @NSManaged var addressId: NSNumber?
    @NSManaged var city: String?
    @NSManaged var country: String?
    @NSManaged var landMark: String?
    @NSManaged var latitude: NSDecimalNumber?
    @NSManaged var longtiude: NSDecimalNumber?
    @NSManaged var others: String?
    @NSManaged var postalCode: String?
    @NSManaged var street: String?
    @NSManaged var serviceProvider: ServiceProvider?

}
