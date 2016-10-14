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
        Alamofire.request(.GET,makeUrl).responseJSON { (response) in
            
            switch response.result {
                
            case .Success(let data):
                print(data["status"])
                let connectionStatus = data["status"] as! String
                switch connectionStatus
                {
                case "success":
                    let makeJson = data["result"] as! NSArray
                    let makesArray = Mapper<Make>().mapArray(makeJson)
                    result(makes: makesArray, code: "success")
                case "error" :
                    result(makes: nil, code: "error")
                    break
                default :
                    result(makes: nil, code: "error")
                    break
                }
            case .Failure(let error):
                print(error)
                result(makes: nil, code: "error")
                break
            }
            
        }
        
        
    }
    
    func getModels(makeName : String , result : @escaping ((_ models : [Model]? ,_ code :String)->())){
        let makeUrl = buildUrl(url: "vehicle/models")
        Alamofire.request(.GET,makeUrl,parameters: ["make":makeName]).responseJSON { (response) in
            
            switch response.result {
                
            case .Success(let data):
                let connectionStatus = data["status"] as! String
                switch connectionStatus
                {
                case "success":
                    let json = data["result"]
                    let modelsArray = Mapper<Model>().mapArray(json)
                    result(models: modelsArray!, code: connectionStatus)
                case "error" :
                    result(models: nil, code: "error")
                    break
                default :
                    result(models: nil, code: "error")
                    break
                }
            case .Failure(let error):
                print(error)
                result(models: nil, code: "We're having a tiny problem. try again later")
                break
            }
            
        }
        
        
    }
    
    func getYears(modelName : String , result : @escaping ((_ years : [Year]? ,_ code :String)->())){
        let makeUrl = buildUrl(url: "vehicle/year")
        Alamofire.request(.GET,makeUrl,parameters: ["model":modelName]).responseJSON { (response) in
            
            switch response.result {
                
            case .Success(let data):
                print(data["status"])
                let connectionStatus = data["status"] as! String
                switch connectionStatus
                {
                case "success":
                    let json = data["result"]
                    let yearArray = Mapper<Year>().mapArray(json)
                    result(years: yearArray!, code: connectionStatus)
                case "error" :
                    result(years: nil, code: "no years")
                    break
                default :
                    break
                }
            case .Failure(let error):
                result(years: nil, code: "We're having a tiny problem. try again later")
                break
            }
            
        }
        
        
    }
    
    func getTrims(modelName : String , year : String , result : @escaping ((_ trims : [Trim]? ,_ code :String)->())){
        
        let makeUrl = buildUrl(url: "vehicle/trim")
        
        Alamofire.request(.GET,makeUrl,parameters: ["model":modelName,"year":year]).responseJSON { (response) in
            
            switch response.result
            {
            case .Success(let data):
                let connectionStatus = data["status"] as! String
                switch connectionStatus
                {
                case "success":
                    let json = data["result"]
                    let trimsArray = Mapper<Trim>().mapArray(json)
                    result(trims: trimsArray!, code: connectionStatus)
                case "error" :
                    result(trims: nil, code: "error")
                    break
                default :
                    break
                }
            case .Failure(let error):
                print(error)
                result(trims: nil, code: "We're having a tiny problem. try again later")
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
                
            case .success(let _data as NSDictionary):
                
                let connectionStatus = _data["status"] as! String
                switch connectionStatus
                {
                case "success":
                    let vehicleJson = _data["result"]
                    
                    
                    let vehicle = Mapper<Vehicle>().map(JSON : vehicleJson as! [String : Any])
                    result(vehicle!, "success")
                    
                    
                    break;
                case "error":
                    
                    print(_data)
                    result(nil, "error")
                    
                    break;
                default:
                    
                    break;
                    
                }
                
                break
            case .failure( _):
                
                
                result(nil, "error")
                break
            }
            
            
            
        }
        
        
    }
}
