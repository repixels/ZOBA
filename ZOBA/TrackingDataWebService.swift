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
    
    func buildUrl(_ url :String)->String{
        
        return StringConstants.servicesDomain + url
    }
    
    
    func saveTrackingData(_ trackingData : TrackingData ,result  : @escaping ((_ trackingData : TrackingData? ,_ code :String)->()))
    {
        let url = buildUrl("trackingData/add")
        let params :[String : AnyObject]? =
            [ "intialOdemeter" : trackingData.initialOdemeter!,
              "dataAdded" : String(describing: trackingData.dateAdded!)  as AnyObject ,
              "dataModified" : String(describing: trackingData.dateAdded!) as AnyObject,
              "typeId" : trackingData.trackingType!.typeId! ,
              "value" : trackingData.value! as AnyObject,
              "vehicleId" : trackingData.vehicle!.vehicleId!
            ]
        
        Alamofire.request(url,method : .get,parameters: params).responseJSON { (response) in
            switch response.result
            {
                
            case .success(_):
                
                if let data = response.result.value as? [String : AnyObject]
                {
                    let connectionStatus = data["status"] as! String
                    switch connectionStatus
                    {
                    case "success":
                    
                        let trackingDataJson = data["result"] as?  [String :AnyObject]
                    
                    
                        let returnedTrackingData = Mapper<TrackingData>().map(JSON :trackingDataJson!)
                        result(returnedTrackingData!, "success")
                    
                    
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
