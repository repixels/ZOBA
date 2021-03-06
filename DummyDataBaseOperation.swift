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
    
    
    static func submit(){
        
        
        let image = UIImage(named: "add-trip")
        
        let data = UIImagePNGRepresentation(image!)
        
        let url = "http://10.118.48.143:8080/WebServiceProject/rest/img/mas"
        
        
        _ = NSBundle.mainBundle().URLForResource("add-trip", withExtension: "png")
        
        
        let base64String = data!.base64EncodedStringWithOptions([])
        
        Alamofire.request(.POST, url , parameters: ["image":base64String,"userId":1,"fileExt":"png"]).response { (req, res, data, error) in
            print(res)
        }
        
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
        
        for i in 2000...2015
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
        
        
        
        let sunday = Days(managedObjectContext: SessionObjects.currentManageContext , entityName: "Days")
        sunday.name = "Sunday"
        sunday.dayId = 1
        sunday.save()
        
        let monday = Days(managedObjectContext: SessionObjects.currentManageContext , entityName: "Days")
        monday.name = "Monday"
        monday.dayId = 2
        monday.save()
        
        let tuesday = Days(managedObjectContext: SessionObjects.currentManageContext , entityName: "Days")
        tuesday.name = "Tuesday"
        tuesday.dayId = 3
        tuesday.save()
        
        let wednesday = Days(managedObjectContext: SessionObjects.currentManageContext , entityName: "Days")
        wednesday.name = "Wednesday"
        wednesday.dayId = 4
        wednesday.save()
        
        let thursday = Days(managedObjectContext: SessionObjects.currentManageContext , entityName: "Days")
        thursday.name = "Thursday"
        thursday.dayId = 5
        thursday.save()
        
        let friday = Days(managedObjectContext: SessionObjects.currentManageContext , entityName: "Days")
        friday.name = "Friday"
        friday.dayId = 6
        friday.save()
        
        let saturday = Days(managedObjectContext: SessionObjects.currentManageContext , entityName: "Days")
        saturday.name = "Saturday"
        saturday.dayId = 7
        saturday.save()
        
        
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
        
        let typeMeasuringUnit = (dao.selectByString(entityName: "MeasuringUnit", AttributeName: "suffix", value: "L") as! [MeasuringUnit])[0]
        
        let fuelService = Service(managedObjectContext: SessionObjects.currentManageContext , entityName: "Service")
        fuelService.name = "Fuel Service"
        fuelService.serviceId = 1
        
        
        let oilService = Service(managedObjectContext: SessionObjects.currentManageContext , entityName: "Service")
        oilService.name = "Oil Service"
        oilService.serviceId = 2
        
        let fuelServiceTypes = TrackingType(managedObjectContext: SessionObjects.currentManageContext , entityName: "TrackingType")
        fuelServiceTypes.name = "Vehicle Refuelling"
        fuelServiceTypes.typeId = 1
        fuelServiceTypes.service = fuelService
        fuelServiceTypes.measuringUnit = typeMeasuringUnit
        
        let oilServiceTypes = TrackingType(managedObjectContext: SessionObjects.currentManageContext , entityName: "TrackingType")
        oilServiceTypes.name = "Oil Change"
        oilServiceTypes.typeId = 2
        oilServiceTypes.service = oilService
        oilServiceTypes.measuringUnit = typeMeasuringUnit
        
        let serviceProviderServices = ServiceProviderServices(managedObjectContext: SessionObjects.currentManageContext , entityName: "ServiceProviderServices")
        serviceProviderServices.startingHour = 28800
        serviceProviderServices.endingHour = 64800
        serviceProviderServices.service = oilService
        
        let serviceProvider = ServiceProvider(managedObjectContext: SessionObjects.currentManageContext, entityName: "ServiceProvider")
        serviceProvider.address = serviceProviderAddress
        serviceProvider.calender?.mutableSetValueForKey("calender").addObject(serviceProviderCalendar)
        serviceProvider.email = "info@total.eg"
        serviceProvider.webSite = "total.eg"
        serviceProvider.name = "Total Egypt"
        serviceProvider.phone?.mutableSetValueForKey("phone").addObject(serviceProviderPhone)
        serviceProvider.save()
        
        
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
        model.modelId = 4
        
        let year = Year(managedObjectContext: SessionObjects.currentManageContext, entityName: "Year")
        year.name = 2016
        year.yearId  = 2016
        
        
        let trim = Trim(managedObjectContext: SessionObjects.currentManageContext, entityName: "Trim")
        trim.name = "LX"
        trim.trimId=4
        
        let vehicleModel = VehicleModel(managedObjectContext: SessionObjects.currentManageContext, entityName: "VehicleModel")
        vehicleModel.model = model
        vehicleModel.year = year
        vehicleModel.trim = trim
        
        vehicleModel.save()
        
    }
    
    static func saveVehicleModel2()
    {
        
        let dao = AbstractDao(managedObjectContext: SessionObjects.currentManageContext)
        
        let make = dao.selectByString(entityName: "Make", AttributeName: "name", value: "Mitsubishi") as! [Make]
        
        
        let model = Model(managedObjectContext: SessionObjects.currentManageContext, entityName: "Model")
        model.make =  make[0]
        model.name = "Mirage"
        model.niceName = "mirage"
        model.modelId = 5
        
        let year = Year(managedObjectContext: SessionObjects.currentManageContext, entityName: "Year")
        year.name = 2017
        year.yearId  = 2017
        
        
        let trim = Trim(managedObjectContext: SessionObjects.currentManageContext, entityName: "Trim")
        trim.name = "GX"
        trim.trimId=5
        
        let vehicleModel = VehicleModel(managedObjectContext: SessionObjects.currentManageContext, entityName: "VehicleModel")
        vehicleModel.model = model
        vehicleModel.year = year
        vehicleModel.trim = trim
        
        vehicleModel.save()
        
    }
    
    static func populateMeasuringUnit()
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
    
    static func populateOnlyOnce()
    {
        DummyDataBaseOperation.populateMeasuringUnit()
        DummyDataBaseOperation.populateDays()
        DummyDataBaseOperation.populateServiceProvider()
    }
    
    static func populateData()
    {
        DummyDataBaseOperation.populateServiceProvider()
    }
}