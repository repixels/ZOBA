//
//  ContectionToWebService.swift
//  ZOBA
//
//  Created by ZOBA on 6/1/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

class WebServiceConnection {
    
    var userobj: MyUser!
    
    init( userobj : MyUser)
    {
        self.userobj = userobj
    }
    

    func LoginWithUserName(url: String , user : MyUser , result: (returnedUser : MyUser?)->Void) {
      
        Alamofire.request(.GET, url ,parameters: ["pass" : user.password! , "user": user.userName!])
            .validate().responseObject {  (response: Response<MyUser, NSError>) in
         
            let json = response.result.value

                user.userName = json?.userName
                user.password = json?.password
                user.email=json?.email
                user.firstName=json?.firstName
                user.lastName=json?.lastName
                
                result(returnedUser: user)
                
        }
    }
    
    
    func LoginWithEmail(url: String , user : MyUser , result: (returnedUser : MyUser?)->Void) {
        
        Alamofire.request(.GET, url ,parameters: ["pass" : user.password! , "email": user.email!])
            .validate().responseObject {  (response: Response<MyUser, NSError>) in
                
                let json = response.result.value
                
                user.userName = json?.userName
                user.password = json?.password
                user.email=json?.email
                user.firstName=json?.firstName
                user.lastName=json?.lastName
                
                result(returnedUser: user)
                
        }
    }
    
      func registration(url: String , user : MyUser ,result: (returnedUser : MyUser?)->Void) {
        Alamofire.request(.GET, url, parameters: ["username": user.userName! , "email" : user.email! , "password" : user.password! , "firstName" : user.firstName! , "lastName" : user.lastName! ])
            .validate().responseObject {  (response: Response<MyUser, NSError>) in
                
                let json = response.result.value
                
                user.userName = json?.userName
                user.password = json?.password
                user.email=json?.email
                user.firstName=json?.firstName
                user.lastName=json?.lastName
                
                result(returnedUser: user)
        }
        
    }
    
    
}