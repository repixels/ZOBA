//
//  FireBaseDataBaseOperations.swift
//  ZOBA
//
//  Created by Angel mas on 7/4/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import Foundation
import Firebase
import ObjectMapper

class FireBaseDataBaseOperations {
    
    
    let ref = FIRDatabase.database().reference()
    
    func saveUserData(user : MyUser){
        
        self.ref.child("users").child(user.userName!).setValue(user.toJSON())
        
    }
    
    func loadUserData(userName : String,result : (user : MyUser! ,code : String)-> ()){
        //        firebase doesn't accept those chars and save only email and password as user data
        //        reason: '(child:) Must be a non-empty string and not contain '.' '#' '$' '[' or ']''
        
        ref.child("users").child(userName).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if snapshot.value != nil {
                let user = Mapper<MyUser>().map(snapshot.value!)
                result(user : user , code : "success")
            }
            else{
                result(user : nil , code : "error")
            }
            
            
        }) { (error) in
            result(user : nil , code : "error")
            //            print(error.localizedDescription)
        }
    }
    
    func updateVehicleData(){
        let vehicles = self.ref.child("users").child(SessionObjects.currentUser.userName!).child("vehicles/1").updateChildValues(["adminFlag": true,"currentOdemeter" : 3000])
        
        //        print(vehicles)
        
    }
    
    
    
}