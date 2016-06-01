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
    
    static  func connctionLogin(url: String , userName : String , password : String) -> String {
        
        Alamofire.request(.GET, url, parameters: [userName: password])
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
        
             return url
    }
    
    static  func connctionPassword(url: String , userName : String , email : String,password : String, firstName :String ,lastName : String ,phone : String ) -> String {
        
        Alamofire.request(.GET, url, parameters: [userName: password])
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
        
        return url
    }

}