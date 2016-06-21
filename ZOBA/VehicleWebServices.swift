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
    
    
    func getMakes(result : ((makes : [Make]! ,code :String)->())){
        let makeUrl = buildUrl("vehicle/makes")
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
    
    func getModels(makeName : String , result : ((models : [Model]! ,code :String)->())){
        let makeUrl = buildUrl("vehicle/models")
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
    
    func getYears(modelName : String , result : ((years : [Year]! ,code :String)->())){
        let makeUrl = buildUrl("vehicle/year")
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
                    print("status error")
                    result(years: nil, code: "no years")
                    break
                default :
                    print("default")
                    break
                }
            case .Failure(let error):
                print(error)
                result(years: nil, code: "We're having a tiny problem. try again later")
                break
            }
            
        }
        
        
    }
    
    func getTrims(modelName : String , year : String , result : ((trims : [Trim]! ,code :String)->())){
        let makeUrl = buildUrl("vehicle/trim?model="+modelName+"&year="+String(year))
        print("Trim URL : \(makeUrl)")
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
                    print("status error")
                    result(trims: nil, code: "error")
                    break
                default :
                    print("default")
                    break
                }
            case .Failure(let error):
                print(error)
                result(trims: nil, code: "We're having a tiny problem. try again later")
                break
            }
        }
    }
    
    
    
    func saveVehicle(vehicle:Vehicle , result :((returnedVehicle : Vehicle!,code :String)->())){
        
        let vehicleUrl = buildUrl("vehicle/add")
        
        let params :[String : AnyObject]? = [ "model" : vehicle.vehicleModel!.model!.name!,
                                              "year" : vehicle.vehicleModel!.year!.name!,
                                              "trim" : vehicle.vehicleModel!.trim!.name!,
                                              "userId": vehicle.user!.userId!,
                                              "carName":vehicle.name!,
                                              "initialOdemeter":vehicle.initialOdemeter!,
                                              "licencePlate":vehicle.licensePlate!]
        
        print(params)
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
                    
                    print(_data)
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
    
    //    func populateAllVehicleModels(){
    //        
    //        // get all makes then all models for first make then all years for first model
    //        //then all trims for first model and first year then repeat
    //        // and insert all of trim and trim's year and (trim's year)'s model and ( (trim's year)'s model )'s make in dictionary and add this dictionary to array
    //        //then repeat
    //        getMakes({ (makes, code) in
    //            
    //            makes.forEach({ (make) in
    //                
    //                self.getModels(make.name!, result: { (models, code) in
    //                    models.forEach({ (model) in
    //                      
    //                        self.getYears(model.name!, result: { (years, code) in
    //                            
    //                            years.forEach({ (year) in
    //                                
    //                                self.getTrims(model.name!, year: year.name!.stringValue, result:{ (trims, code) in
    //                                    
    ////                                    yearTrims.addObject(trims)
    //                                   trims.forEach({ (trim) in
    //                                    
    //                                        let vehicleModel = VehicleModel(backGroundEntity: "VehicleModel")
    //                                        model.make = make
    //                                    vehicleModel.model = model
    //                                    vehicleModel.year = year
    //                                    vehicleModel.trim = trim
    //                                    vehicleModel.save()
    //                                   })
    //                                    
    //                                })
    //                                
    //                        
    //                            })
    //                        
    //                            
    //                        })
    //                        
    //                        
    //                    })
    //                })
    //                
    //            })
    //            let context = makes!.first!.managedObjectContext
    //            makes.first?.release(context!)
    //            
    //        })
    //        
    //        
    //    
    //    }
}