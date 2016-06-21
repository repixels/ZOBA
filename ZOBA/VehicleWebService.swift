//
//  VehicleWebService.swift
//  ZOBA
//
//  Created by Angel mas on 6/20/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

//vehicle/add?model="modelName"&year="yearName"&trim="trimName"&userId=&carName=&initialOdemeter=&licensePlate=""
class VehicleWebService {
    
    func buildUrl(url :String)->String{
        
        return StringConstants.servicesDomain + url
    }
    
    func saveVehicle(vehicle:Vehicle , result :((returnedVehicle : Vehicle!,code :String)->())){
        
        let vehicleUrl = buildUrl("vehicle/add")
        
        let params :[String : AnyObject]? = [ "model" : vehicle.vehicleModel!.model!.name!,
                                              "year" : vehicle.vehicleModel!.year!.name!,
                                              "trim" : vehicle.vehicleModel!.trim!.name!,
                                              "userId": vehicle.user!.userId!,
                                              "carName":vehicle.name!,
                                              "initialOdemeter":vehicle.initialOdemeter!,
                                              "licensePlate":vehicle.licensePlate!]
        
        Alamofire.request(.GET,vehicleUrl ,parameters: params).responseJSON { response in
            
            
            switch response.result
            {
            case .Success(let _data):
                let connectionStatus = _data["status"] as! String
                switch connectionStatus
                {
                case "success":
                    let vehicleJson = _data["result"]
                    
                    
                    let vehicle = Mapper<Vehicle>().map(vehicleJson)
                    result(returnedVehicle: vehicle!, code: "success")
                    
                    
                    break;
                case "error":
                    
                    
                    result(returnedVehicle: nil, code: "error")
                    
                    break;
                default:
                    
                    break;
                    
                }
                
                break
            case .Failure( _):
                
                
                result(returnedVehicle: nil, code: "error")
                break
            }
            
            
            
        }
        
        
    }
    
    
}