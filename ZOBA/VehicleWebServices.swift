//
//  VehicleWebServices.swift
//  ZOBA
//
//  Created by Angel mas on 6/19/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import SwiftyUserDefaults

class VehicleWebServices {
    
    func buildUrl(url :String)->String{
        
        return StringConstants.servicesDomain + url
    }
    
    
    func getMakes(result : @escaping ((_ makes : [Make]? ,_ code :String)->())){
        let makeUrl = buildUrl(url: "vehicle/makes")
        print(makeUrl)
        Alamofire.request( makeUrl ,method : .get).responseJSON { (response) in
            
            switch response.result {
                
            case .success(_):
                if let data = response.result.value as? [String : AnyObject]
                    {
                        print(data)
                        let connectionStatus = data["status"] as! String
                        switch connectionStatus
                        {
                        case "success":
                            let makeJson = data["result"] as! [[String : AnyObject]]
                            
                            let makesArray = Mapper<Make>().mapArray(JSONArray: makeJson)
                            result(makesArray, "success")
                        case "error" :
                            result(nil, "error")
                            break
                        default :
                            result(nil, "error")
                            break
                        }
                }
            case .failure(let error) :
                print(error)
                result(nil, "error")
                break
            }
            
        }
        
        
    }
    
    func getModels(makeName : String , result : @escaping ((_ models : [Model]? ,_ code :String)->())){
        let makeUrl = buildUrl(url: "vehicle/models")
        Alamofire.request(makeUrl, method : .get ,parameters: ["make":makeName]).responseJSON { (response) in
            
            switch response.result {
                
            case .success(_):
                if let data = response.result.value as? [String : AnyObject]
                {
                    let connectionStatus = data["status"] as! String
                    switch connectionStatus
                    {
                    case "success":
                        let json = data["result"] as? [[String : AnyObject]]
                        let modelsArray = Mapper<Model>().mapArray(JSONArray: json!)
                        
                        result(modelsArray!, connectionStatus)
                    case "error" :
                        result(nil, "error")
                        break
                    default :
                        result(nil, "error")
                        break
                }
            }
                break
            case .failure(let error):
                print(error)
                result(nil, "We're having a tiny problem. try again later")
                break
            }
            
        }
        
        
    }
    
    func getYears(modelName : String , result : @escaping ((_ years : [Year]? ,_ code :String)->())){
        let makeUrl = buildUrl(url: "vehicle/year")
        Alamofire.request(makeUrl, method : .get ,parameters: ["model":modelName]).responseJSON { (response) in
            
            switch response.result {
                
            case .success(_):
                if let data = response.result.value as? [String : AnyObject]
                {
                print(data["status"])
                let connectionStatus = data["status"] as! String
                switch connectionStatus
                {
                case "success":
                    let json = data["result"] as? [[String : AnyObject]]
                    let yearArray = Mapper<Year>().mapArray(JSONArray:json!)
                    result(yearArray!, connectionStatus)
                case "error" :
                    result(nil, "no years")
                    break
                default :
                    break
                }
            }
            case .failure(_):
                result(nil, "We're having a tiny problem. try again later")
                break
            }
            
        }
        
        
    }
    
    func getTrims(modelName : String , year : String , result : @escaping ((_ trims : [Trim]? ,_ code :String)->())){
        
        let makeUrl = buildUrl(url: "vehicle/trim")
        
        Alamofire.request(makeUrl,method : .get,parameters: ["model":modelName,"year":year]).responseJSON { (response) in
            
            switch response.result
            {
            case .success(_):
                if let data = response.result.value as? [String : AnyObject]
                {
                let connectionStatus = data["status"] as! String
                switch connectionStatus
                {
                case "success":
                    let json = data["result"] as? [[String : AnyObject]]
                    let trimsArray = Mapper<Trim>().mapArray(JSONArray :json!)
                    result(trimsArray!, connectionStatus)
                case "error" :
                    result(nil, "error")
                    break
                default :
                    break
                }
                 }
            case .failure(let error):
                print(error)
                result(nil, "We're having a tiny problem. try again later")
                break
            }
        }
    }
    
    
    
    func saveVehicle(vehicle:Vehicle , result :@escaping ((_ returnedVehicle : Vehicle?,_ code :String)->())){
        
        let vehicleUrl = buildUrl(url: "vehicle/add")
        
        
        let params :[String : AnyObject]? = [ "model" : vehicle.vehicleModel!.model!.name! as AnyObject,
                                              "year" : vehicle.vehicleModel!.year!.name!,
                                              "trim" : vehicle.vehicleModel!.trim!.name! as AnyObject,
                                              "userId": vehicle.user!.userId!,
                                              "carName":vehicle.name! as AnyObject,
                                              "initialOdemeter":vehicle.initialOdemeter!,
                                              "licencePlate":vehicle.licensePlate! as AnyObject]
        Alamofire.request(vehicleUrl, method: .get, parameters: params).responseJSON { (response) in
            
            switch response.result
            {
                
            case .success(_):
                if let data = response.result.value as? [String : AnyObject]
                {
                
                let connectionStatus = data["status"] as! String
                switch connectionStatus
                {
                case "success":
                    let vehicleJson = data["result"]
                    
                    
                    let vehicle = Mapper<Vehicle>().map(JSON : vehicleJson as! [String : Any])
                    result(vehicle!, "success")
                    
                    
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
