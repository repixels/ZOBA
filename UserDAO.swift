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
    
    func save(managedObjectContext : NSManagedObjectContext ,unmanagedUser user : MyUser) -> MyUser!{
        
        let managedUser = NSEntityDescription.insertNewObjectForEntityForName("MyUser", inManagedObjectContext: self.managedObjectContext!) as! MyUser
        
        //   m = select()
        managedUser.firstName = user.firstName
        managedUser.email = user.email
        managedUser.userId = user.userId
        managedUser.image = user.image
        managedUser.lastName = user.lastName
        managedUser.userName = user.userName
        managedUser.phone = user.phone
        managedUser.password = user.password
        
        if(user.vehicle?.count > 0)
        {
            managedUser.vehicle = user.vehicle
        }
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
        
        let predicate = NSPredicate(format: attribute + " = %@",value)
        
        
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
    func selectById(managedObjectContext : NSManagedObjectContext,Id _id :Int64) -> MyUser{
        
        
        let users = selectBy(managedObjectContext, attribute: "userId", value: String(_id))
        var user :MyUser!
        
        if users.count > 0 {
            user = users[0]
        }
        return user
    }
    
    func delete(managedObjectContext : NSManagedObjectContext,Id _id :Int64){
        let user = selectById(managedObjectContext, Id: _id)
        do{
            managedObjectContext.deleteObject(user)
            try managedObjectContext.save()
        }
        catch let error {
            print(error)
        }
    }
    
    func addVehicle(managedObjectContext moc : NSManagedObjectContext , userId _id :Int64 , managedVehicle vehicle : Vehicle){
        
        let user = selectById(moc, Id: _id)
        let vehicles = NSMutableSet(set: user.vehicle!)
        
        
        vehicles.addObject(vehicle)
        user.vehicle = vehicles
        
        user.save(managedObjectContext: moc)
        
        
        
    }
    
    
}