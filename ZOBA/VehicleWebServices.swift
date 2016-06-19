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
    
    
    
    //    let makeUrl = "http://10.118.48.143:8080/WebServiceProject/rest/vehicle/makes"
    //    let modelUrl = "http://10.118.48.143:8080/WebServiceProject/rest/vehicle/models?make=m1"
    //    let yearUrl = "http://10.118.48.143:8080/WebServiceProject/rest/vehicle/year?model=bte5a"
    //    let trimUrl = "http://10.118.48.143:8080/WebServiceProject/rest/vehicle/trim?model=bte5a&year=2014"
    //
    
    let makeUrl = "http://10.118.48.143:8080/WebServiceProject/rest/vehicle/makes"
    let modelUrl = "http://10.118.48.143:8080/WebServiceProject/rest/vehicle/models"
    let yearUrl = "http://10.118.48.143:8080/WebServiceProject/rest/vehicle/year"
    let trimUrl = "http://10.118.48.143:8080/WebServiceProject/rest/vehicle/trim"
    //    
    //    
    //    func getAllMakes(){
    //        Alamofire.request(.GET,makeUrl).responseJSON { (json) in
    //            print(json.result.value)
    //            self.makes = Mapper<Make>().mapArray(json.result.value)
    //            self.makes![0].save()
    //            self.makePicker.reloadAllComponents()
    //        }
    //        
    //    }
    //    
    //    
    //    func getAllModels(makeName : String){
    //        
    //        
    //        Alamofire.request(.GET,modelUrl,parameters: ["make":makeName]).responseJSON { (json) in
    //            print(json.result.value)
    //            print("===========================")
    //            self.models = Mapper<Model>().mapArray(json.result.value)
    //            self.models![0].save()
    //            self.modelPicker.reloadAllComponents()
    //        }
    //        
    //    }
    //    
    //    
    //    func getAllYears(modelName :String){
    //        Alamofire.request(.GET,yearUrl,parameters: ["model":modelName]).responseJSON { (json) in
    //            print(json.result.value)
    //            print("===========================")
    //            self.years = Mapper<Year>().mapArray(json.result.value)
    //            self.years![0].save()
    //            self.years!.forEach({ (y) in
    //                print("name : \(y.yearId)")
    //                print("name : \(y.name)")
    //                
    //            })
    //            self.modelPicker.reloadAllComponents()
    //        }
    //        
    //    }
    //    
    //    
    //    func getAllTrims(modelName : String , year : Int){
    //        Alamofire.request(.GET,trimUrl,parameters: ["model":modelName,"year":year]).responseJSON { (json) in
    //            print(json.result.value)
    //            print("===========================")
    //            self.trims = Mapper<Trim>().mapArray(json.result.value)
    //            self.trims![0].save()
    //            self.modelPicker.reloadAllComponents()
    //        }
    //        
    //    }
    //    
}