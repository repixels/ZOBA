//
//  MyUser+CoreDataProperties.swift
//  ZOBA
//
//  Created by ZOBA on 5/31/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension MyUser {

    @NSManaged var email: String?
    @NSManaged var firstName: String?
    @NSManaged var userId: NSNumber?
    @NSManaged var image: NSData?
    @NSManaged var lastName: String?
    @NSManaged var phone: String?
    @NSManaged var userName: String?
    @NSManaged var password: String?

}
