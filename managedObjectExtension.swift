//
//  managedObjectExtension.swift
//  ZOBA
//
//  Created by me on 6/4/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import Foundation
import CoreData
import UIKit

extension NSManagedObject{
    
    static private var privateContext : NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
    
    func release (managedObjectContext : NSManagedObjectContext){
        managedObjectContext.reset()
    }
    
    static func getPrivateContext() -> NSManagedObjectContext
    {
        privateContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        privateContext.persistentStoreCoordinator = delegate.persistentStoreCoordinator
        
        return privateContext
    }
    convenience init( backGroundEntity :String) {
        
        let privateContext =  NSManagedObject.getPrivateContext()
        //        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        //        privateContext.persistentStoreCoordinator = delegate.persistentStoreCoordinator
        let desc = NSEntityDescription.entityForName(backGroundEntity, inManagedObjectContext: privateContext)
        
        self.init(entity: desc!,insertIntoManagedObjectContext:privateContext)
    }
    
    convenience init(unmanagedEntity : String){
        //        let privateContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        //        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        //        privateContext.persistentStoreCoordinator = delegate.persistentStoreCoordinator
        let privateContext =  NSManagedObject.getPrivateContext()
        let desc = NSEntityDescription.entityForName(unmanagedEntity, inManagedObjectContext: privateContext)
        self.init(entity: desc!,insertIntoManagedObjectContext:nil)
    }
    
    
    func save(managedObjectContext moc : NSManagedObjectContext) -> (Bool){
        var saved = false
        do {
            try moc.save()
            saved = true
            
        }
        catch let error {
            print(error)
        }
        
        return saved
    }
    
}

