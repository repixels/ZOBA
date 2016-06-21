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
        //let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        privateContext.persistentStoreCoordinator = SessionObjects.currentManageContext.persistentStoreCoordinator
        
        return privateContext
    }
    convenience init( backGroundEntity :String) {
        
        let privateContext =  NSManagedObject.getPrivateContext()
        self.init(managedObjectContext: privateContext , entityName: backGroundEntity)
    }
    
    convenience init(unmanagedEntity : String){
        
        let privateContext =  NSManagedObject.getPrivateContext()
        let desc = NSEntityDescription.entityForName(unmanagedEntity, inManagedObjectContext: privateContext)
        self.init(entity: desc!,insertIntoManagedObjectContext:nil)
    }
    
    convenience init(managedObjectContext moc: NSManagedObjectContext , entityName entity: String){
    
        let desc = NSEntityDescription.entityForName(entity, inManagedObjectContext: moc)
        self.init(entity: desc!,insertIntoManagedObjectContext:moc)
    }
    
    
    func save(){
        let moc = SessionObjects.currentManageContext
        
        do {
            try moc!.save()
            
            
        }
        catch let error {
            print("save error :  \(error)")
        }
        
        
    }
    
    
    func delete(){
    
        let moc = self.managedObjectContext
        moc?.deleteObject(self)
        save()
    
    }
}

