//
//  SessionObjects.swift
//  ZOBA
//
//  Created by RE Pixels on 6/11/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import Foundation
import CoreData

class SessionObjects
{
    static var currentManageContext : NSManagedObjectContext!
    static var currentUser : MyUser!
    static var currentVehicle: Vehicle!
    static var motionMonitor : LocationMonitor!
}