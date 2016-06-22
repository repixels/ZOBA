//
//  TripWebService.swift
//  ZOBA
//
//  Created by Angel mas on 6/20/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import SwiftyUserDefaults


class TripWebService {
    
    func buildUrl(url :String)->String{
        
        return StringConstants.servicesDomain + url
    }
    
    func saveTrip(trip : Trip,result : ((returnedTrip : Trip? , code : String)->())){
        let tripUrl = buildUrl("trip/addTrip")
        Alamofire.request(.GET,tripUrl ,parameters: ["vehicleId": Int(trip.vehicle!.vehicleId!), "initialOdemeter": Int(trip.initialOdemeter!) , "coveredMilage" :Int(trip.coveredKm!)] ).responseJSON { response in
            print(response.request)
            switch response.result
            {
            case .Success(let _data):
                let connectionStatus = _data["status"] as! String
                switch connectionStatus
                {
                case "success":
                    let tripJson = _data["result"]
                    
                    
                    let trip = Mapper<Trip>().map(tripJson)
                    result(returnedTrip: trip!, code: "success")
                    
                    
                    break;
                case "error":
                    
                    //       let returnedJSON = _data["result"] as? String
                    result(returnedTrip: nil, code: "error")
                    
                    break;
                default:
                    
                    break;
                    
                }
                
                break
            case .Failure( _):
                //   let errorMessage = "We're having a tiny problem. Try loging in later!"
                
                result(returnedTrip: nil, code: "error")
                break
            }
            
            
            
        }
        
        
    }
    
    func saveCoordinate(vehicleId :Int , coordinate :TripCoordinate,tripId : Int,result : ((returnedCoordinate : TripCoordinate? , code : String)->())){
        
        let tripUrl = buildUrl("trip/addCoordinates")
        Alamofire.request(.GET,tripUrl ,parameters: ["vehicleId": vehicleId  , "longitude": Double(coordinate.longtitude!) , "latitude" :Double(coordinate.latitude!),"tripId" : tripId] ).responseJSON {response in
            
            switch response.result
            {
            case .Success(let _data):
                let connectionStatus = _data["status"] as! String
                switch connectionStatus
                {
                case "success":
                    let coordinateJson = _data["result"]
                    
                    
                    let coordinate = Mapper<TripCoordinate>().map(coordinateJson)
                    result(returnedCoordinate: coordinate!, code: "success")
                    break;
                case "error":
                    
                    //  let returnedJSON = _data["result"] as? String
                    result(returnedCoordinate: nil, code: "error")
                    //
                    break;
                default:
                    
                    break;
                    
                }
                
                break
            case .Failure( _):
                //   let errorMessage = "We're having a tiny problem. Try loging in later!"
                
                result(returnedCoordinate:nil, code: "error")
                break
            }
            
        }
    }
    
    
}