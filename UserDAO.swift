//
//  UserDAO.swift
//  ZOBA
//
//  Created by ZOBA on 5/31/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import Foundation
import CoreData

class UserDAO {
    var managedObjectContext : NSManagedObjectContext!
    
    init(managedObjectContext : NSManagedObjectContext){
        self.managedObjectContext = managedObjectContext
    }
    
    func save(managedObjectContext : NSManagedObjectContext ,userId _id: Int, Email email : String, UserName userName :String , firstName first : String, LastName last : String , Phone phone : String , ImageUrl image :String , password : String) -> MyUser!{
        
        let user = NSEntityDescription.insertNewObjectForEntityForName("MyUser", inManagedObjectContext: self.managedObjectContext!) as! MyUser
        
        //   m = select()
        user.firstName = first
        user.email = email
        user.userId = _id
        //user.image = image
        user.lastName = last
        user.userName = userName
        user.phone = phone
        user.password = password
        do {
            try managedObjectContext.save()
            print("saved")
        }
        catch let error {
            print(error)
        }
        return user;
        
    }
    
    
    func selectAll(managedObjectContext : NSManagedObjectContext) -> [MyUser]{
        let fetched = NSFetchRequest(entityName : "MyUser")
        var res : [MyUser]!
        do{
            res = try managedObjectContext.executeFetchRequest(fetched) as! [MyUser]
        }catch let error {
            
            print(error)
        }
        return res
    }
    
    func selectBy(managedObjectContext : NSManagedObjectContext,attribute : String , value :String) -> [MyUser]{
        let fetchRequest = NSFetchRequest(entityName: "MyUser")
        let sortDescriptor = NSSortDescriptor(key: attribute, ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Create a new predicate that filters out any object that
        // doesn't have a title of "Best Language" exactly.
        let predicate = NSPredicate(format: attribute + " = %@",value)
        //        (format: "title == %@", "Best Language")
        
        // Set the predicate on the fetch request
        fetchRequest.predicate = predicate
        var res : [MyUser]!
        do{
            res = try managedObjectContext.executeFetchRequest(fetchRequest) as! [MyUser]
        } catch let error {
            print(error)
        }
        return res
    }
    func selectById(managedObjectContext : NSManagedObjectContext,Id _id :Int) -> MyUser{
        
        
        let users =     selectBy(managedObjectContext, attribute: "userId", value: String(_id))
        var user :MyUser!
        
        if users.count > 0 {
            user = users[0]
        }
        return user
    }
    
    func delete(managedObjectContext : NSManagedObjectContext,Id _id :Int){
        let user = selectById(managedObjectContext, Id: _id)
        do{
            managedObjectContext.deleteObject(user)
            try managedObjectContext.save()
        }
        catch let error {
            print(error)
        }
    }
    
    
}