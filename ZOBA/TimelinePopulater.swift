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
    
    var tableCells : [TimeLineCell]
    
    var timelineDate : NSDate?
    
    init(tableView:UITableView)
    {
        selectedVehicle = SessionObjects.currentVehicle!
        
        trips = selectedVehicle?.trip?.allObjects as! [Trip]!
        
        vehicleTrackingData = selectedVehicle?.traclingData?.allObjects as! [TrackingData]!
        
        vehicleFuelTrackingData = [TrackingData]()
        vehicleOilTrackingData = [TrackingData]()
        
        self.tableCells = [TimeLineCell]()
        
        self.tableView = tableView
        
        
        
    }
    
    func populateTripsCells() -> [TripCell]?
    {
        
        var tripCells = [TripCell]()
        
        for trip in self.trips!
        {
            
            let tripCell = tableView.dequeueReusableCellWithIdentifier(TripCell.identifier) as! TripCell
            
            let date = NSDate(timeIntervalSince1970:  Double(trip.dateAdded!))
            tripCell.timeLineDate = date
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
            fuelCell.timeLineDate = fuel.dateAdded!
            fuelCell.fuelAmount!.text = fuel.value!
            fuelCell.fuelTitle?.text = (fuel.vehicle!.name)! + " Fuel"
            fuelCell.fuelDate?.text = String(fuelCell.timeLineDate)
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
            oilCell.timeLineDate = oil.dateAdded!
            oilCell.oilAmount!.text = oil.value!
            oilCell.oilTitle?.text = (oil.vehicle!.name)! + " Oil"
            oilCell.oilDate?.text = String(oilCell.timeLineDate)
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
    
    func populateTableData() -> [TimeLineCell]
    {
        self.reloadSelectedVehicle()
        self.seperateTrackingData()
        self.populateFuelCells()
        self.populateOilCells()
        self.populateTripsCells()
        
        //sort table cell
        tableCells.sortInPlace { (firstCell, secondCell) -> Bool in
            
            return firstCell.timeLineDate.compare(secondCell.timeLineDate) == NSComparisonResult.OrderedDescending
        }
        
        
        //insert day summery cell at the begining of each day
        var sortedCells = [TimeLineCell]()
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier(DaySummaryCell.identifier) as! DaySummaryCell
        cell.currentOdemeter?.text = SessionObjects.currentVehicle.currentOdemeter?.stringValue != nil ? SessionObjects.currentVehicle.currentOdemeter!.stringValue : "Not Available"
        cell.salutation?.text = contextAwareTitle()
        cell.monthLabel?.text = "Hello"
        timelineDate = NSDate()
        if timelineDate != nil
        {
            let formatter = NSDateFormatter()
            
            formatter.dateFormat = "MMM"
            
            cell.monthLabel?.text = formatter.stringFromDate(timelineDate!).uppercaseString
            print(formatter.stringFromDate(timelineDate!).uppercaseString)
            
            formatter.dateFormat = "dd"
            cell.dayLabel!.text = formatter.stringFromDate(timelineDate!).uppercaseString
            
            

        }
        
        sortedCells.append(cell)
        
        if tableCells.count > 1
        {
            for i in 0 ..< tableCells.count - 1
            {
                let cal = NSCalendar.currentCalendar()
                cal.timeZone = NSTimeZone(name: "UTC")!
                var firstComps = cal.component(NSCalendarUnit.Day, fromDate: tableCells[i].timeLineDate)
                var secondComps = cal.component(NSCalendarUnit.Day, fromDate: tableCells[i+1].timeLineDate)
                firstComps -= 1
                secondComps -= 1
                
                let firstMonthComps = cal.component(NSCalendarUnit.Month, fromDate: tableCells[i].timeLineDate)
                let secondMonthComps = cal.component(NSCalendarUnit.Month, fromDate: tableCells[i+1].timeLineDate)
                
                let firstYearComps = cal.component(NSCalendarUnit.Year, fromDate: tableCells[i].timeLineDate)
                let secondYearComps = cal.component(NSCalendarUnit.Year, fromDate: tableCells[i+1].timeLineDate)
                
                if firstComps > secondComps || firstMonthComps > secondMonthComps || firstYearComps > secondYearComps
                {
                    timelineDate = tableCells[i].timeLineDate
                    timelineDate = timelineDate?.dateByAddingTimeInterval(60*60*24 * -1)
                    
                    
                    let cell = tableView.dequeueReusableCellWithIdentifier(DaySummaryCell.identifier) as! DaySummaryCell
                    cell.currentOdemeter?.text = SessionObjects.currentVehicle.currentOdemeter?.stringValue != nil ? SessionObjects.currentVehicle.currentOdemeter!.stringValue : "Not Available"
                    cell.currentOdemeter?.hidden = true
                    cell.dayImage?.image = nil
                    cell.dayImage?.hidden = true
                    cell.salutation?.text = contextAwareTitle()
                    
                    if timelineDate != nil
                    {
                        let formatter = NSDateFormatter()
                        
                        formatter.dateFormat = "MMM"
                        
                        cell.monthLabel!.text = formatter.stringFromDate(timelineDate!).uppercaseString
                        
                        formatter.dateFormat = "dd"
                        cell.dayLabel!.text = formatter.stringFromDate(timelineDate!).uppercaseString
                        
                        formatter.dateFormat = "EEEE"
                        cell.salutation?.text = formatter.stringFromDate(timelineDate!).uppercaseString
                    }
                    
                    sortedCells.append(cell)
                }
                
                sortedCells.append(tableCells[i])
            }
        }
        
        if tableCells.count > 0
        {
        
                timelineDate = tableCells.last!.timeLineDate
//                timelineDate = timelineDate?.dateByAddingTimeInterval(60*60*24 * -1)
            
                
                let cell = tableView.dequeueReusableCellWithIdentifier(DaySummaryCell.identifier) as! DaySummaryCell
                cell.currentOdemeter?.text = SessionObjects.currentVehicle.currentOdemeter?.stringValue != nil ? SessionObjects.currentVehicle.currentOdemeter!.stringValue : "Not Available"
                cell.currentOdemeter?.hidden = true
                cell.dayImage?.image = nil
                cell.dayImage?.hidden = true
                cell.salutation?.text = contextAwareTitle()
                
                if timelineDate != nil
                {
                    let formatter = NSDateFormatter()
                    
                    formatter.dateFormat = "MMM"
                    
                    cell.monthLabel!.text = formatter.stringFromDate(timelineDate!).uppercaseString
                    
                    formatter.dateFormat = "dd"
                    cell.dayLabel!.text = formatter.stringFromDate(timelineDate!).uppercaseString
                    
                    formatter.dateFormat = "EEEE"
                    cell.salutation?.text = formatter.stringFromDate(timelineDate!).uppercaseString
                }
                
                sortedCells.append(cell)
            

            sortedCells.append(tableCells.last!)
        }
        
        return sortedCells
        
    }
    
    func reloadSelectedVehicle()
    {
        selectedVehicle = SessionObjects.currentVehicle!
        
        trips = selectedVehicle?.trip?.allObjects as! [Trip]!
        
        vehicleTrackingData = selectedVehicle?.traclingData?.allObjects as! [TrackingData]!
        self.tableCells.removeAll()
        seperateTrackingData()
    }
    
    func contextAwareTitle() -> String?
    {
        let now = NSDate()
        let cal = NSCalendar.currentCalendar()
        let comps = cal.component(NSCalendarUnit.Hour, fromDate: now)
        
        switch comps {
        case 0 ... 12:
            return "Good Morning"
        case 13 ... 17:
            return "Good Afternoon"
        case 18 ... 23:
            return "Good Evening"
        default:
            return "Welcome Back"
        }
    }
    
}