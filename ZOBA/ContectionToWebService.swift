//
//  ContectionToWebService.swift
//  ZOBA
//
//  Created by ZOBA on 6/1/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import Foundation
import Alamofire

class ContectionToWebService {
    
       func connctionLogin(url: String , user : MyUser) -> MyUser {
    
        Alamofire.request(.GET, url, parameters:["pass" : user.password! , "user": user.userName!] )
            .validate()
            .responseJSON { response in
                switch response.result {
                case .Success:
                    print("Validation Successful")
                     print("Response String: \(response.result.value)")
                case .Failure(let error):
                    print(error)
                }
        }
             return user
    }
    
      func connctionPassword(url: String , user : MyUser) -> MyUser {
        Alamofire.request(.GET, url, parameters: ["username": user.userName! , "email" : user.email! , "password" : user.password! , "firstName" : user.firstName! , "lastName" : user.lastName! , "phone" : user.phone!])
            .validate()
            .responseJSON { response in
                switch response.result {
                case .Success:
                    print("Validation Successful")
                    print("Response String: \(response.result.value)")
                case .Failure(let error):
                    print(error)
                }
        }
        
        return user
    }

}