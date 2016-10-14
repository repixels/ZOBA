//
//  Device Webservices.swift
//  ZOBA
//
//  Created by RE Pixels on 6/14/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import SwiftyUserDefaults

class DeviceWebservice {
    
    var user:MyUser
    var deviceToken : String
    var registerDeviceURL : String
    
    init(deviceToken: String , currentUser: MyUser)
    {
        self.user = currentUser
        self.deviceToken = deviceToken
        registerDeviceURL = ""
    }
    
    private func buildRegisterDeviceURL()
    {
        registerDeviceURL = StringConstants.servicesDomain+"device/add?"
        registerDeviceURL += "userId="+(self.user.userId!.stringValue)
        registerDeviceURL += "&token="+(self.user.deviceToken)!
        print(registerDeviceURL)
    }
    
    func registerUserDevice()
    {
        self.buildRegisterDeviceURL()
        Alamofire.request( self.registerDeviceURL,method : .get )
            .responseJSON { response in
                switch response.result
                {
                case .success(_):
                    if  let data = response.result.value as? [String:AnyObject]
                    {
                        let connectionStatus = data["status"] as! String
                        switch connectionStatus
                        {
                        case "success":
                                print(data)
                                break;
                            case "error":
                                print(data)
                                break;
                            default:
                                print(data)
                                break;
                        
                    }
                }
                    break;
                case .failure(let error):
                    print(error)

                    break;
                }
                
        }

    }
    
    
}
