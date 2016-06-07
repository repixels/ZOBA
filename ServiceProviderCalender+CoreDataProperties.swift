//
//  ServiceProviderCalender+CoreDataProperties.swift
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

extension ServiceProviderCalender {

    @NSManaged var calenderId: Int32
    @NSManaged var endingHour: Double
    @NSManaged var startingHour: Double
    @NSManaged var day: Days?
    @NSManaged var serviceProvider: ServiceProvider?

}
