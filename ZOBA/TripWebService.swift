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
    
    func saveTrip(trip : Trip){
        let tripUrl = buildUrl("trip/addTrip")
        Alamofire.request(.GET,tripUrl ,parameters: ["vehicleId": Int(trip.vehicle!.vehicleId!)  , "initialOdemeter": Int(trip.initialOdemeter!) , "coveredMilage" :Int(trip.coveredKm!)] ).response { (req, res, data, error) in
            print("saving trip")
            print(res)
            print(error)
            print("======================")
        }
        
    }
    
    func saveCoordinate(vehicleId :Int , coordinate :TripCoordinate){
        
        let tripUrl = buildUrl("trip/addCoordinates")
        Alamofire.request(.GET,tripUrl ,parameters: ["vehicleId": vehicleId  , "longitude": Double(coordinate.longtitude!) , "latitude" :Double(coordinate.latitude!)] ).response { (req, res, data, error) in
            print("saving coordinate")
            print(res)
            print(error)
            print("======================")
        }
    }
    
    func save(trip :Trip){
        
        saveTrip(trip)
        saveCoordinate(Int(trip.vehicle!.vehicleId!), coordinate: trip.coordinates!.allObjects.first! as! TripCoordinate)
        
        
        saveCoordinate(Int(trip.vehicle!.vehicleId!), coordinate: trip.coordinates!.allObjects.last! as! TripCoordinate)
    }
    
}