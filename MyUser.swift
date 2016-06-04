//
//  MyUser.swift
//  ZOBA
//
//  Created by ZOBA on 5/31/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import Foundation
import CoreData
import ObjectMapper
import AlamofireObjectMapper


class MyUser : NSManagedObject , Mappable {

// Insert code here to add functionality to your managed object subclass

    
    var mangedObje : NSManagedObject!
    
    init(managedObjectContext : NSManagedObjectContext){
       
        let desc = NSEntityDescription.entityForName("MyUser", inManagedObjectContext: managedObjectContext)

        super.init(entity: desc!,insertIntoManagedObjectContext:nil)
    }
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    required init?(_ map: Map) {
        
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appdelegate.managedObjectContext
        let entity = NSEntityDescription.entityForName("MyUser", inManagedObjectContext: managedContext)

        super.init(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        mapping(map)
    }
    
    func mapping(map: Map) {
         userName   <- map["username"]
         password   <- map["password"]
        firstName   <- map["username"]
        lastName   <- map["username"]
        email   <- map["email"]
    }
}

    

