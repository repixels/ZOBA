//
//  Vehicle+CoreDataProperties.swift
//  
//
//  Created by me on 6/4/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//
import Foundation
import CoreData

extension Vehicle {
    
    @NSManaged var currentOdemeter: Int64
    @NSManaged var initialOdemeter: Int64
    @NSManaged var isOwnedByThisUser: Bool
    @NSManaged var licensePlate: String?
    @NSManaged var name: String?
    @NSManaged var vehicleId: Int16
    @NSManaged var user: MyUser?
    
}
