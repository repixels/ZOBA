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
    func getServiceProvider( result :@escaping ((_ serviceProvider : [ServiceProvider]?,_ code :String)->())){
        
        let url = buildUrl(url: "serviceProvider/getServiceProviders")
        
        
        
        print(url)
        
        Alamofire.request(url,method :.get ).responseJSON { response in
            print(response.request)
            
            switch response.result
            {
                
            case .success(_):
                if let data = response.result.value as? [String: AnyObject]
                {
                    print(data)
                    let connectionStatus = data["status"] as! String
                    switch connectionStatus
                    {
                    case "success":
                        let serviceProvidersJson = data["result"] as? [[String : AnyObject]]
                         print(serviceProvidersJson)
                    
                        let serviceProviders = Mapper<ServiceProvider>().mapArray(JSONArray :serviceProvidersJson!)
                        result(serviceProviders!, "success")

                        break;
                    case "error":
                        print(data)
                        result(nil, "error")
                    
                        break;
                    default:
                    
                        break;
                    
                    }
                }
                break
            case .failure(_):
                result(nil, "error")
                break
            }
            
            
            
        }
        
        
    }
    
    
    
}
