//
//  TimelinePopulater.swift
//  ZOBA
//
//  Created by RE Pixels on 6/18/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import UIKit
import Foundation

class TimelinePopulater
{
    
    var trips : [Trip]?
    var vehicleTrackingData : [TrackingData]?
    var selectedVehicle : Vehicle?
    
    var vehicleFuelTrackingData : [TrackingData]?
    var vehicleOilTrackingData : [TrackingData]?
    
    let tableView : UITableView
    
    var tableCells : [AnyObject]
    
    init(tableView:UITableView)
    {
        selectedVehicle = SessionObjects.currentVehicle!
        
        trips = selectedVehicle?.trip?.allObjects as! [Trip]!
        
        vehicleTrackingData = selectedVehicle?.traclingData?.allObjects as! [TrackingData]!
        
        vehicleFuelTrackingData = [TrackingData]()
        vehicleOilTrackingData = [TrackingData]()
        
        self.tableCells = [AnyObject]()
        
        self.tableView = tableView
        
    }
    
    func populateTripsCells() -> [TripCell]?
    {
        
        var tripCells = [TripCell]()
        
        for trip in self.trips!
        {
            
            let tripCell = tableView.dequeueReusableCellWithIdentifier(TripCell.identifier) as! TripCell
            
             let date = NSDate(timeIntervalSince1970:  Double(trip.dateAdded!))
            tripCell.tripDate!.text = String(date)
            tripCell.tripTitle!.text = (trip.vehicle!.name)!+" Trip"
            tripCell.initialOdemeter!.text = trip.initialOdemeter!.stringValue
            tripCell.distanceCovered!.text = trip.coveredKm!.stringValue
            tripCell.tripSummary!.text = String(trip.initialOdemeter!.doubleValue + trip.coveredKm!.doubleValue) + " KM"
            
            
            tripCells.append(tripCell)
            self.tableCells.append(tripCell)
        }
        
        return tripCells
    }
    
    func populateFuelCells() -> [FuelCell]{
        
        var fuelCells = [FuelCell]()
        
        for fuel in vehicleFuelTrackingData!{
        
            let fuelCell = tableView.dequeueReusableCellWithIdentifier(FuelCell.identifier) as! FuelCell
            fuelCell.fuelAmount!.text = fuel.value!
            fuelCell.fuelTitle?.text = (fuel.vehicle!.name)! + " Fuel"
            fuelCell.fuelDate?.text = String(fuel.dateAdded!)
            fuelCell.initialOdemeter!.text = String(fuel.initialOdemeter!)
            fuelCell.serviceProvider!.text = fuel.serviceProviderName
            
            fuelCells.append(fuelCell)
            self.tableCells.append(fuelCell)
        
        }
        return fuelCells
    }
    
    func populateOilCells() -> [OilCell]{
        
        var oilCells = [OilCell]()
        
        for oil in vehicleOilTrackingData!{
            
            let oilCell = tableView.dequeueReusableCellWithIdentifier(OilCell.identifier) as! OilCell
            oilCell.oilAmount!.text = oil.value!
            oilCell.oilTitle?.text = (oil.vehicle!.name)! + " Oil"
            oilCell.oilDate?.text = String(oil.dateAdded!)
            oilCell.initialOdemeter!.text = String(oil.initialOdemeter!)
            oilCell.serviceProvider!.text = oil.serviceProviderName
            
            oilCells.append(oilCell)
            self.tableCells.append(oilCell)
            
        }
        return oilCells
    }
    
    
    func seperateTrackingData(){
        
        vehicleFuelTrackingData = [TrackingData]()
        vehicleOilTrackingData = [TrackingData]()
        
        vehicleTrackingData?.forEach({ (trackingData) in
            
            if trackingData.trackingType?.name! == StringConstants.fuelTrackingType {
                
                vehicleFuelTrackingData?.append(trackingData)
                print("Fuel")
            }
            else if trackingData.trackingType?.name! == StringConstants.oilTrackingType {
                
                vehicleOilTrackingData?.append(trackingData)
                print("Oil")
            }
        })
    }
    
    func populateTableData() -> [AnyObject]
    {
        self.reloadSelectedVehicle()
        self.seperateTrackingData()
        self.populateFuelCells()
        self.populateOilCells()
        self.populateTripsCells()
        
        
        
        
        
        return self.tableCells
        
    }
    
    func reloadSelectedVehicle()
    {
        selectedVehicle = SessionObjects.currentVehicle!
        
        trips = selectedVehicle?.trip?.allObjects as! [Trip]!
        
        vehicleTrackingData = selectedVehicle?.traclingData?.allObjects as! [TrackingData]!
        self.tableCells.removeAll()
        seperateTrackingData()
    }
    
}