//
//  Make+CoreDataProperties.swift
//  ZOBA
//
//  Created by ZOBA on 6/7/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Make {

    @NSManaged var image: NSData?
    @NSManaged var makeId: Int32
    @NSManaged var name: String?
    @NSManaged var niceName: String?
    @NSManaged var model: NSSet?
    @NSManaged var serviceProvider: NSSet?

}