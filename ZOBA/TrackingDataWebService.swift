//
//  TrackingDataWebService.swift
//  ZOBA
//
//  Created by RE Pixels on 6/22/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import SwiftyUserDefaults

class TrackingDataWebService {
    
    func buildUrl(url :String)->String{
        
        return StringConstants.servicesDomain + url
    }
    
    
    func saveTrackingData(trackingData : TrackingData ,result  : ((trackingData : TrackingData! ,code :String)->()))
    {
        let url = buildUrl("trackingData/add")
        let params :[String : AnyObject]? =
            [ "intialOdemeter" : trackingData.initialOdemeter!,
              "dataAdded" : String(trackingData.dateAdded!),
              "dataModified" : String(trackingData.dateAdded!),
              "typeId" : trackingData.trackingType!.typeId! ,
              "value" : trackingData.value!,
              "vehicleId" : trackingData.vehicle!.vehicleId!
            ]
        
        Alamofire.request(.GET,url,parameters: params).responseJSON { (response) in
            switch response.result
            {
                
            case .Success(let _data):
                
                let connectionStatus = _data["status"] as! String
                switch connectionStatus
                {
                case "success":
                    
                    let trackingDataJson = _data["result"]
                    
                    
                    let returnedTrackingData = Mapper<TrackingData>().map(trackingDataJson)
                    result(trackingData: returnedTrackingData!, code: "success")
                    
                    
                    break;
                case "error":
                    result(trackingData: nil, code: "error")
                    
                    break;
                default:
                    
                    break;
                    
                }
                
                break
            case .Failure( _):
                result(trackingData: nil, code: "error")
                break
            }
            
        
        
        }
    
    }

}