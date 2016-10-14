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
    
    func saveTrip(trip : Trip,result : @escaping ((_ returnedTrip : Trip? , _ code : String)->())){
        let tripUrl = buildUrl(url: "trip/addTrip")
        Alamofire.request(tripUrl , method :.get ,parameters: ["vehicleId": Int(trip.vehicle!.vehicleId!), "initialOdemeter": Int(trip.initialOdemeter!) , "coveredMilage" :Int(trip.coveredKm!)] ).responseJSON { response in
            switch response.result
            {
            case .success(_):
                if let data = response.result.value as? [String : AnyObject]
                {
                    let connectionStatus = data["status"] as! String
                    switch connectionStatus
                    {
                    case "success":
                        let tripJson = data["result"] as? [String : AnyObject]
                        let trip = Mapper<Trip>().map(JSON: tripJson!)
                        result(trip!, "success")
                        break;
                    case "error":
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
    
    func saveCoordinate(vehicleId :Int , coordinate :TripCoordinate,tripId : Int,result : @escaping ((_ returnedCoordinate : TripCoordinate? , _ code : String)->())){
        
        let tripUrl = buildUrl(url: "trip/addCoordinates")
        Alamofire.request(tripUrl,method: .get ,parameters: ["vehicleId": vehicleId  , "longitude": Double(coordinate.longtitude!) , "latitude" :Double(coordinate.latitude!),"tripId" : tripId] ).responseJSON {response in
            
            switch response.result
            {
            case .success(_):
                if let data = response.result.value as? [String : AnyObject]
                {
                    let connectionStatus = data["status"] as! String
                    switch connectionStatus
                    {
                        case "success":
                            let coordinateJson = data["result"] as? [String : AnyObject]
                    
                        let coordinate = Mapper<TripCoordinate>().map(JSON :coordinateJson!)
                        result(coordinate!, "success")
                        break;
                    case "error":
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
