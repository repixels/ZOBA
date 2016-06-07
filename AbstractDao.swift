//
//  AbstractDao.swift
//  ZOBA
//
//  Created by Angel mas on 6/5/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import Foundation
import CoreData
class AbstractDao {
    
    let moc : NSManagedObjectContext
    init(managedObjectContext moc : NSManagedObjectContext){
    
        self.moc = moc
    }
    
    
    func selectAll(entityName entity : String  )-> [NSManagedObject]{
        
        
        let fetchRequest = NSFetchRequest(entityName: entity )
        
        
        var res : [NSManagedObject]!
        do{
            res = try moc.executeFetchRequest(fetchRequest) as! [NSManagedObject]
        } catch let error {
            print(error)
        }
        return res
        
        
    }
    
    func selectByString(entityName entity : String ,AttributeName attribute : String , value : String  )-> [NSManagedObject]{
      
        
        let fetchRequest = NSFetchRequest(entityName: entity )
        
        
        let predicate = NSPredicate(format:   "%K= %@",attribute,value)
        fetchRequest.predicate = predicate
        var res : [NSManagedObject]!
        do{
            res = try moc.executeFetchRequest(fetchRequest) as! [NSManagedObject]
        } catch let error {
            print(error)
        }
        return res
        
        
    }
    
    
    func selectByInt(entityName entity : String ,AttributeName attribute : String , value : Int  )-> [NSManagedObject]{
        
        
        let fetchRequest = NSFetchRequest(entityName: entity)
        
        
        let predicate = NSPredicate(format:   "%K= %d",attribute,value)
        fetchRequest.predicate = predicate
        var res : [NSManagedObject]!
        do{
            res = try moc.executeFetchRequest(fetchRequest) as! [NSManagedObject]
        } catch let error {
            print(error)
        }
        return res
        
        
    }

}