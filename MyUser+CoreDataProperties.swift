//
//  MyUser+CoreDataProperties.swift
//  
//
//  Created by ZOBA on 6/1/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension MyUser {

    @NSManaged var email: String?
    @NSManaged var firstName: String?
    @NSManaged var image: NSData?
    @NSManaged var lastName: String?
    @NSManaged var password: String?
    @NSManaged var phone: String?
    @NSManaged var userId: Int64
    @NSManaged var userName: String?
    
   

}
