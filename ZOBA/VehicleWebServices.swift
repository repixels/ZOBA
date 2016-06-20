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
    
    //10.118.49.154
    
    func buildUrl(url :String)->String{
        
        return StringConstants.servicesDomain + url
    }
    
    
    func getMakes(result : ((makes : [Make]! ,code :String)->())){
        let makeUrl = buildUrl("vehicle/makes")
        Alamofire.request(.GET,makeUrl).responseJSON { (response) in
            
            switch response.result {
                
            case .Success(let data):
                print(data["status"])
                let connectionStatus = data["status"] as! String
                switch connectionStatus
                {
                case "success":
                    let makeJson = data["result"]
                    let makesArray = Mapper<Make>().mapArray(makeJson)
                    print(makesArray![0] )
                    result(makes: makesArray!, code: connectionStatus)
                case "error" :
                    print("status error")
                    result(makes: nil, code: "no makes")
                    break
                default :
                    print("default")
                    break
                }
            case .Failure(let error):
                print(error)
                result(makes: nil, code: "We're having a tiny problem. try again later")
                break
            }
            
        }
        
        
    }
    
    func getModels(makeName : String , result : ((models : [Model]! ,code :String)->())){
        let makeUrl = buildUrl("vehicle/models")
        Alamofire.request(.GET,makeUrl,parameters: ["make":makeName]).responseJSON { (response) in
            
            switch response.result {
                
            case .Success(let data):
                print(data["status"])
                let connectionStatus = data["status"] as! String
                switch connectionStatus
                {
                case "success":
                    let json = data["result"]
                    let modelsArray = Mapper<Model>().mapArray(json)
                    print(modelsArray![0] )
                    result(models: modelsArray!, code: connectionStatus)
                case "error" :
                    print("status error")
                    result(models: nil, code: "no models")
                    break
                default :
                    print("default")
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
                    print(yearArray![0] )
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
    
    func getTrims(modelName : String , year : Int , result : ((trims : [Trim]! ,code :String)->())){
        let makeUrl = buildUrl("vehicle/year")
        Alamofire.request(.GET,makeUrl,parameters: ["model":modelName,"year":year]).responseJSON { (response) in
            
            switch response.result {
                
            case .Success(let data):
                print(data["status"])
                let connectionStatus = data["status"] as! String
                switch connectionStatus
                {
                case "success":
                    let json = data["result"]
                    let trimsArray = Mapper<Trim>().mapArray(json)
                    print(trimsArray![0] )
                    result(trims: trimsArray!, code: connectionStatus)
                case "error" :
                    print("status error")
                    result(trims: nil, code: "no years")
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
    
    func populateAllVehicleModels(){
        
        // get all makes then all models for first make then all years for first model
        //then all trims for first model and first year then repeat
        // and insert all of trim and trim's year and (trim's year)'s model and ( (trim's year)'s model )'s make in dictionary and add this dictionary to array
        //then repeat
        getMakes({ (makes, code) in
            
            makes.forEach({ (make) in
                
                self.getModels(make.name!, result: { (models, code) in
                    models.forEach({ (model) in
                      
                        self.getYears(model.name!, result: { (years, code) in
                            
                            years.forEach({ (year) in
                                
                                self.getTrims(model.name!, year: Int(year.name!), result:{ (trims, code) in
                                    
//                                    yearTrims.addObject(trims)
                                   trims.forEach({ (trim) in
                                    
                                        let vehicleModel = VehicleModel(backGroundEntity: "VehicleModel")
                                        model.make = make
                                    vehicleModel.model = model
                                    vehicleModel.year = year
                                    vehicleModel.trim = trim
                                    vehicleModel.save()
                                   })
                                    
                                })
                                
                        
                            })
                        
                            
                        })
                        
                        
                    })
                })
                
            })
            let context = makes!.first!.managedObjectContext
            makes.first?.release(context)
            
        })
        
        
    
    }
}