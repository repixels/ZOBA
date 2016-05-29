//
//  MyUser+CoreDataProperties.swift
//  
//
//  Created by me on 5/28/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension MyUser {
    @NSManaged var id: NSNumber?
    @NSManaged var userName: String?
    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var phone: String?
    @NSManaged var email: String?
    @NSManaged var image: String?
    
    
    
}
