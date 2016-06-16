//
//  Make+CoreDataProperties.swift
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

extension Make {

    @NSManaged var image: NSData?
    @NSManaged var makeId: NSNumber?
    @NSManaged var name: String?
    @NSManaged var niceName: String?
    @NSManaged var model: NSSet?
    @NSManaged var serviceProvider: NSSet?

}
