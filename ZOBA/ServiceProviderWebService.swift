//
//  ServiceProviderWebService.swift
//  ZOBA
//
//  Created by RE Pixels on 6/22/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import SwiftyUserDefaults

class ServiceProviderWebService {
    
    func buildUrl(url :String)->String{
        
        return StringConstants.servicesDomain + url
    }
    
    //    /serviceProvider/getServiceProviders
    func getServiceProvider( result :((serviceProvider : [ServiceProvider]!,code :String)->())){
        
        let url = buildUrl("serviceProvider/getServiceProviders")
        
        
        
        
        
        Alamofire.request(.GET,url ).responseJSON { response in
            print(response.request)
            
            switch response.result
            {
                
            case .Success(let _data):
                
                let connectionStatus = _data["status"] as! String
                switch connectionStatus
                {
                case "success":
                    let serviceProvidersJson = _data["result"]
                    print(serviceProvidersJson)
                    
                    let serviceProviders = Mapper<ServiceProvider>().mapArray(serviceProvidersJson)
                    result(serviceProvider: serviceProviders!, code: "success")
                    
                    
                    break;
                case "error":
                    
                    print(_data)
                    result(serviceProvider: nil, code: "error")
                    
                    break;
                default:
                    
                    break;
                    
                }
                
                break
            case .Failure( _):
                
                
                result(serviceProvider: nil, code: "error")
                break
            }
            
            
            
        }
        
        
    }
    
    
    
}