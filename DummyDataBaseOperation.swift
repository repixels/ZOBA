//
//  DummyDataBaseOperation.swift
//  ZOBA
//
//  Created by Angel mas on 6/11/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import Alamofire
import AlamofireImage

class DummyDataBaseOperation {
    
    static var dao =  AbstractDao.init(managedObjectContext: SessionObjects.currentManageContext)
    
    static func saveUser( managedObjectContext moc : NSManagedObjectContext){
        
        
        let user = MyUser(managedObjectContext: moc, entityName: "MyUser")
        user.email = "email"
        user.userName = "mas"
        user.email = "email@mail.com"
        user.firstName = "first"
        user.password = "password"
        user.save()
    }
    
    
    static func saveVehicle(managedObjectContext moc : NSManagedObjectContext , name: String?) -> Vehicle{
        let vehicle = Vehicle(managedObjectContext: moc, entityName: "Vehicle")
        vehicle.name = name!
        vehicle.currentOdemeter = 30000
        vehicle.initialOdemeter = 20000
        
        vehicle.save()
        
        return vehicle
    }
    
    
    func submit(){
        
        
        let image = UIImage(named: "add-trip")
        
        let data = UIImagePNGRepresentation(image!)
        // print(data)
        //
        
        let url = "http://10.118.48.143:8080/WebServiceProject/rest/img/mas"
        
        
        _ = NSBundle.mainBundle().URLForResource("add-trip", withExtension: "png")
        
        
        let base64String = data!.base64EncodedStringWithOptions([])
        
        Alamofire.request(.POST, url , parameters: ["image":base64String,"userId":1,"fileExt":"png"]).response { (req, res, data, error) in
            print(res)
        }
        
    }
    
    static func populateFirstTime()
    {
        self.populateYear()
    }

    static func saveTrackingType(managedObjectContext moc : NSManagedObjectContext , name: String?)
    {
        let trackingType = TrackingType(managedObjectContext: moc, entityName: "TrackingType")
        
        trackingType.name = name!
        
        trackingType.save()
        
        let measuringUnitObj = MeasuringUnit(managedObjectContext: moc, entityName: "MeasuringUnit")
        
        measuringUnitObj.name = "liters"
        measuringUnitObj.suffix = "L"
        
        measuringUnitObj.mutableSetValueForKey("trackingType").addObject(trackingType)
        
        measuringUnitObj.save()
        
        let serobj = Service(managedObjectContext:moc , entityName: "Service")
        
        serobj.name = name!
        serobj.save()
        serobj.mutableSetValueForKey("trackingType").addObject(trackingType)
                
    }
    
    static func saveServiceProvider(managedObjectContext moc : NSManagedObjectContext , name: String?)
    {
        let serviceProvider = ServiceProvider(managedObjectContext: moc, entityName: "ServiceProvider")
      
        serviceProvider.name = name!
        
        serviceProvider.save()
        
    }
    
    static func populateMake()
    {
        let make = Make(managedObjectContext: SessionObjects.currentManageContext,entityName: "Make")
        
        
        
        make.name = "Huyndai"
        make.niceName = "huyandai"
        make.makeId = 1
        
        
        make.save()
    }
    
    static func populateYear()
    {
        
        for i in 2000...2017
        {
            let year = Year(managedObjectContext: SessionObjects.currentManageContext, entityName: "Year")
            year.name = i
            year.yearId = i
            year.save()
            
        }
        
    }
    
    static func populateModel()
    {
        let model = Model(managedObjectContext: SessionObjects.currentManageContext, entityName: "Model")
        
        
        model.name = "Elantra"
        model.niceName = "elantra"
        model.make = (self.dao.selectByString(entityName: "Make", AttributeName: "name", value: "Huyndai") as! [Make])[0]
        model.modelId = 1
        
        model.save()
    }
    
    
    static func populateDays()
    {
        var days : [Days]?
        
        days![0] = Days(managedObjectContext: SessionObjects.currentManageContext , entityName: "Days")
        days![0].name = "Sunday"
        days![0].dayId = 1
        days![0].save()
        
        days![1] = Days(managedObjectContext: SessionObjects.currentManageContext , entityName: "Days")
        days![1].name = "Monday"
        days![1].dayId = 2
        days![1].save()
        
        days![2] = Days(managedObjectContext: SessionObjects.currentManageContext , entityName: "Days")
        days![2].name = "Tuesday"
        days![2].dayId = 3
        days![2].save()
        
        days![3] = Days(managedObjectContext: SessionObjects.currentManageContext , entityName: "Days")
        days![3].name = "Wednesday"
        days![3].dayId = 4
        days![3].save()
        
        days![4] = Days(managedObjectContext: SessionObjects.currentManageContext , entityName: "Days")
        days![4].name = "Thursday"
        days![4].dayId = 5
        days![4].save()
        
        days![5] = Days(managedObjectContext: SessionObjects.currentManageContext , entityName: "Days")
        days![5].name = "Friday"
        days![5].dayId = 6
        days![5].save()
        
        days![6] = Days(managedObjectContext: SessionObjects.currentManageContext , entityName: "Days")
        days![6].name = "Saturday"
        days![6].dayId = 7
        days![6].save()
        
        
    }
    
    static func populateServiceProvider()
    {
        
        
        let serviceProviderAddress = ServiceProviderAddress(managedObjectContext: SessionObjects.currentManageContext, entityName: "ServiceProviderAddress")
        serviceProviderAddress.city = "Cairo"
        serviceProviderAddress.country = "Egypt"
        serviceProviderAddress.landMark = "Nile Kornish"
        serviceProviderAddress.longtiude = 29.967599
        serviceProviderAddress.latitude = 31.2471413
        serviceProviderAddress.postalCode = "110511"
        serviceProviderAddress.street = "161 Masr / Helwan Road - Maadi, 161 Misr Helwan Agriculture Rd"
        serviceProviderAddress.addressId = 1
        
        let serviceProviderCalendar = ServiceProviderCalender(managedObjectContext: SessionObjects.currentManageContext, entityName: "ServiceProviderCalender")
        serviceProviderCalendar.day = (self.dao.selectByString(entityName: "Days", AttributeName: "name", value: "Sunday") as! [Days])[0]
        serviceProviderCalendar.startingHour = 28800
        serviceProviderCalendar.endingHour = 64800
        serviceProviderCalendar.calenderId = 1
        
        let serviceProviderPhone = ServiceProviderPhone(managedObjectContext: SessionObjects.currentManageContext , entityName: "ServiceProviderPhone")
        serviceProviderPhone.phone = "19623"
        serviceProviderPhone.phoneId = 1
        
        
        let serviceTypes = TrackingType(managedObjectContext: SessionObjects.currentManageContext , entityName: "TrackingType")
        serviceTypes.name = "Vehicle Refuelling"
        serviceTypes.typeId = 1
        
        let service = Service(managedObjectContext: SessionObjects.currentManageContext , entityName: "Service")
        service.name = "Fuel Service"
        service.serviceId = 1
        
        let serviceProviderServices = ServiceProviderServices(managedObjectContext: SessionObjects.currentManageContext , entityName: "ServiceProviderServices")
        serviceProviderServices.startingHour = 28800
        serviceProviderServices.endingHour = 64800
        serviceProviderServices.service = service
        
        
        
        let serviceProvider = ServiceProvider(managedObjectContext: SessionObjects.currentManageContext, entityName: "ServicePro")
        serviceProvider.address = serviceProviderAddress
        serviceProvider.calender?.mutableSetValueForKey("calender").addObject(serviceProviderCalendar)
        serviceProvider.email = "info@total.eg"
        serviceProvider.webSite = "total.eg"
        
        
        
    }
    
    static func saveVehicleModel()
    {
        let make = Make(managedObjectContext: SessionObjects.currentManageContext,entityName: "Make")
        make.name = "Mitsubishi"
        make.niceName = "mitsubishi"
        
        let model = Model(managedObjectContext: SessionObjects.currentManageContext, entityName: "Model")
        model.make =  make
        model.name = "Lancer"
        model.niceName = "lancer"
        
        let year = Year(managedObjectContext: SessionObjects.currentManageContext, entityName: "Year")
        year.name = 2014
        
        let trim = Trim(managedObjectContext: SessionObjects.currentManageContext, entityName: "Trim")
        trim.name = "LX"
        
        let vehicleModel = VehicleModel(managedObjectContext: SessionObjects.currentManageContext, entityName: "VehicleModel")
        vehicleModel.model = model
        vehicleModel.year = year
        vehicleModel.trim = trim
        
        vehicleModel.save()
        
    }
    
    
    static func populateData()
    {
        DummyDataBaseOperation.saveVehicle(managedObjectContext: SessionObjects.currentManageContext,name: "Swift")
        
        DummyDataBaseOperation.saveVehicle(managedObjectContext: SessionObjects.currentManageContext,name: "Huyndai")
        
        DummyDataBaseOperation.saveVehicle(managedObjectContext: SessionObjects.currentManageContext,name: "Ferarri")
        
        DummyDataBaseOperation.saveTrackingType(managedObjectContext: SessionObjects.currentManageContext, name: "oil")
        DummyDataBaseOperation.saveTrackingType(managedObjectContext: SessionObjects.currentManageContext, name: "fuel")
        DummyDataBaseOperation.saveServiceProvider(managedObjectContext: SessionObjects.currentManageContext, name: "Lancer Ser")
        
        DummyDataBaseOperation.saveServiceProvider(managedObjectContext: SessionObjects.currentManageContext, name: "Swift Ser")
        
        DummyDataBaseOperation.saveServiceProvider(managedObjectContext: SessionObjects.currentManageContext, name: "Huyndai Ser")
    }
    
    func populateMeasuringUnit()
    {
        let kilometer =  MeasuringUnit(managedObjectContext: SessionObjects.currentManageContext , entityName: "MeasuringUnit")
        kilometer.name = "Kilometer"
        kilometer.suffix = "KM"
        kilometer.save()
        
        let speed =  MeasuringUnit(managedObjectContext: SessionObjects.currentManageContext , entityName: "MeasuringUnit")
        speed.name = "Kilometer per Hour"
        speed.suffix = "KM/H"
        speed.save()
        
        let liters =  MeasuringUnit(managedObjectContext: SessionObjects.currentManageContext , entityName: "MeasuringUnit")
        liters.name = "Liters"
        liters.suffix = "L"
        liters.save()
    }
}