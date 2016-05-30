//
//  MyUser.swift
//  
//
//  Created by me on 5/28/16.
//
//

import Foundation
import CoreData
import ObjectMapper

class MyUser: NSManagedObject , Mappable {
    
    // Insert code here to add functionality to your managed object subclass
    
    //    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
    //        super.init(entity: entity, insertIntoManagedObjectContext: context)
    //    }
    //
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    required init?(_ map: Map) {
        let ctx = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        var entity = NSEntityDescription.entityForName("MyUser", inManagedObjectContext: ctx)
        super.init(entity: entity!, insertIntoManagedObjectContext: ctx)
        
        mapping(map)
    }
    
    
    
    // Mappable
    func mapping(map: Map) {
    }
    
}
