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
    
    
//    func getServiceProvider( result :((serviceProvider : ServiceProvider!,code :String)->())){
//        
//        let vehicleUrl = buildUrl("vehicle/add")
//        
//        
//        let params :[String : AnyObject]? = [ ]
//        
//        print(params)
//        Alamofire.request(.GET,vehicleUrl ,parameters: params).responseJSON { response in
//            print(response.request)
//            
//            switch response.result
//            {
//                
//            case .Success(let _data):
//                
//                let connectionStatus = _data["status"] as! String
//                switch connectionStatus
//                {
//                case "success":
//                    let vehicleJson = _data["result"]
//                    
//                    
//                    let vehicle = Mapper<Vehicle>().map(vehicleJson)
//                    result(returnedVehicle: vehicle!, code: "success")
//                    
//                    
//                    break;
//                case "error":
//                    
//                    print(_data)
//                    result(returnedVehicle: nil, code: "error")
//                    
//                    break;
//                default:
//                    
//                    break;
//                    
//                }
//                
//                break
//            case .Failure( _):
//                
//                
//                result(returnedVehicle: nil, code: "error")
//                break
//            }
//            
//            
//            
//        }
//        
//        
//    }
//    
//    
    
}