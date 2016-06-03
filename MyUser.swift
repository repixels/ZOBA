//
//  MyUser.swift
//  ZOBA
//
//  Created by ZOBA on 5/31/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import Foundation
import CoreData


class MyUser: NSManagedObject {

// Insert code here to add functionality to your managed object subclass


    var mangedObje : NSManagedObject!
    
    init(managedObjectContext : NSManagedObjectContext){
       
        let desc = NSEntityDescription.entityForName("MyUser", inManagedObjectContext: managedObjectContext)

        super.init(entity: desc!,insertIntoManagedObjectContext:nil)
    }
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
}

    

