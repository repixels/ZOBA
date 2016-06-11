//
//  TrackingData+CoreDataProperties.swift
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

extension TrackingData {

    @NSManaged var dateAdded: NSTimeInterval
    @NSManaged var dateModified: NSTimeInterval
    @NSManaged var initialOdemeter: NSNumber
    @NSManaged var trackingId: NSNumber
    @NSManaged var value: String?
    @NSManaged var trackingType: TrackingType?
    @NSManaged var vehicle: Vehicle?

}
