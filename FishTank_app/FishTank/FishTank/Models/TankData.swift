//
//  TankData.swift
//  FishTank
//
//  Created by Robert Cecil on 10/20/19.
//  Copyright © 2019 Robert Cecil. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

/*
Abstract:
The model for a fishtank.
*/

final class TankProfile: ObservableObject {
    
    //Name of the person using the App, changed in settings and Reset View
    @Published var userName: String
    
    
    //Our HTTPClient
    let messenger: Messenger
    
    var sendingTempRange: Bool = true
    
    //Boolean to show whether we are showing tank temp in F or C
    @Published var inFahrenheight = true;
    
    //Placeholder array of fish
    var placeHolderFish = fishData
    
    //Array of Temperature history over time - in FarenHeit
    @Published var tempHistory: [Double]
    
    //Array of pH history over time
    @Published var pHHistory: [Double]
    
    
    //Array of FishBreeds
    var breeds = fishBreedData
    
    //Array to use later, store in persistent memory
    @Published var currentResidents: [FishProfile]
    
    //Running Max/Min Temps accounting for all fish
    var maxTemp: Double = 80
    var minTemp: Double = 50
    
    
    //Running Max/Min pH vals accounting for all fish
    var maxpH: Double = 14
    var minpH: Double = 0
    
    
    //Counter variable to give each fish a unique ID
    var idCounter: Int
    
    //Current Temperature of the tank formatted in a string
    var currentTemp: String {
        var tempDouble: Double = 8
        
        tempDouble  = self.messenger.currentTempF
           
        if inFahrenheight {
            let tempInt = Int(tempDouble)
            return String(tempInt) + " °F"
        }
        else {
            let currentTempC = Int((tempDouble - 32) * 5.0 / 9.0)
            return String(currentTempC) + " °C"
        }
    }
    
    //Current pH formatted to 2 decimal places in a string
    var currentpHStr: String {
        let pH = self.messenger.currentPh
        return String(format: " %.2f", pH)
    }
    
    var ammonColor: Color = .green
    var nitrateColor: Color = .green
    var nitriteColor: Color = .green
    
    
    var ammoniaStat: String {
        let ammonia = self.messenger.ammoniaVal
        
        if ammonia == 0 {
            ammonColor = .green
            return "Good"
        }
        else {
            ammonColor = .yellow
            return "Light levels detected"
        }
    }
    
    var nitrateStat: String {
        let nitrate = self.messenger.nitrateVal
        
        if nitrate == 0 {
            nitrateColor = .green
            return "Good"
        }
        else {
            nitrateColor = .green
            return "Good"
        }
    }
    
    var nitriteStat: String {
        let nitrite = self.messenger.nitriteVal
        
        if nitrite == 0 {
            nitriteColor = .green
            return "Good"
        }
        else {
            nitriteColor = .red
            return "heavy levels detected"
        }
    }
    
    
    
    var ammoniaNum: String {
        let ammonia = self.messenger.ammoniaVal
        return String(format: " %.0f", ammonia)
    }
    
    var nitrateNum: String {
        let nitrate = self.messenger.nitrateVal
        return String(format: " %.0f", nitrate)
    }
    
    var nitriteNum: String {
        let nitrite = self.messenger.nitriteVal
        return String(format: " %.0f", nitrite)
    }
    
    
    //All these string formatter values are required to truncate the decimal place
    var maxTempStr_F: String {
        let maxT = self.maxTemp
        return String(format: "%.0f", maxT)
    }
      
    var minTempStr_F: String {
        let minT = self.minTemp
        return String(format: " %.0f",minT)
    }
      
    var maxTempStr_C: String {
      let maxTempC = Double((self.maxTemp - 32) * 5.0 / 9.0)
      return String(format: " %.0f", maxTempC)
    }
      
    var minTempStr_C: String {
          let minTempC = Double((self.minTemp - 32) * 5.0 / 9.0)
          return String(format: " %.0f", minTempC)
    }
      
    var maxpHStr: String {
         let maxP = self.maxpH
         return String(format: " %.2f", maxP)
    }
      
      var minpHStr: String {
         let minP = self.minpH
          return String(format: " %.2f", minP)
      }
    
    
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /// Functions to update and fetch values using the HTTP Messenger
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func updateParams() {
        self.messenger.refreshParams()
        
        //Test that this works
        self.tempHistory.append(messenger.currentTempF)
        self.pHHistory.append(messenger.currentPh)
        
        //Add a shadow Celcius temp history
        
        self.lastTime = self.getNow()
    }
    

    func promptAmmoniaTest() {
       let _ = self.messenger.promptAmmonia()
    }
    
    func getAmmoniaVal() {
        let _ = self.messenger.requestAmmonia()
    }
    
    
    func promptNitrateTest() {
        let _ = self.messenger.promptNitrate()
    }
    
    func getNitrateVal() {
        let _ = self.messenger.requestNitrate()
    }
    
    
    func promptNitriteTest() {
        let _ = self.messenger.promptNitrite()
    }
    
    func getNitriteVal() {
        let _ = self.messenger.requestNitrite()
    }
    
    func getChems() {
        let _ = self.messenger.requestAmmonia()
        let _ = self.messenger.requestNitrate()
        let _ = self.messenger.requestNitrite()
    
    }
    
    
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    /// Functions to manage the "Last time checked" displayed
    /////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    // time since tank was checked last (in minutes)
    var lastCheckedTimeInMins = 3
    
    // Deltas for calculating last time
    var lastTime = 0;
    
    //Calculates how long it has been since we've checked the Tank stats
    func getNow() -> Int {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        return (hour * 60) + minutes
    }
    
    func updateDelta() {
        self.lastCheckedTimeInMins = self.getNow() - self.lastTime;
        return
    }
    
    var lastTimeChecked: String {
        updateDelta()
        
        if self.lastCheckedTimeInMins == 0 {
            return " Just now "
        }
        
        if self.lastCheckedTimeInMins == 1 {
           return " \(self.lastCheckedTimeInMins) minute ago"
        }
        
        if self.lastCheckedTimeInMins < 60 {
            return " \(self.lastCheckedTimeInMins) minutes ago"
        }
        else {
            let lastCheckedTimeInHours = Int(self.lastCheckedTimeInMins) / 60
            //Intentionally doing integer division truncating here
            return " \(lastCheckedTimeInHours) hours ago"
        }

    }
    
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    /// Functions to manage the Overall health and temp, pH colors
    /////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    
    var currentWarning: String = ""
    var healthColor: Color = .green
    var tempColor: Color = .blue
    var pHColor: Color = .blue
    
    var category: String {
        
        //Temperature checking
        if (messenger.currentTempF > maxTemp ||
            messenger.currentTempF < minTemp ) {
            
            self.currentWarning = " Temperature is out of range!"
            self.healthColor = .red
            self.tempColor = .red
            return String(Health.bad.rawValue)
        }
            
        //pH checking
        if (messenger.currentPh > maxpH ||
            messenger.currentPh < minpH ) {
            
            self.currentWarning = " pH is out of range!"
            self.healthColor = .yellow
            self.pHColor = .red
            return String(Health.bad.rawValue)
        }
    
       //We won't consider Chemical readings in this case, just confine them to their page
        
        self.currentWarning = ""
        self.healthColor = .green
        return String(Health.good.rawValue)
        
    }
    
    enum Health: String, CaseIterable, Codable, Hashable {
        case good = "Good"
        case ok = "Ok"
        case bad = "Unhealthy"
        case terrible = "Terrible"
    }
    
    // Default constructor
    init() {
        currentResidents = [FishProfile]()
        self.idCounter = 0
        self.userName = "Robert"
        
       // let piServerAdress = "192.168.1.166"
        let laptopServerAddress = "35.6.134.190"
        let server = laptopServerAddress
        messenger = Messenger(ipAddress: server)
        //TODO: Remove placeholder data
        tempHistory = [70, 69 ,68, 75, 76, 80, 25, 34]
        pHHistory = [4.00, 7.6, 8.0, 7.8, 6.9, 5.7, 3.4, 6.5]
        
    }
    
    // Extra constructor for variable IP address - This one is used in main app
    init( ipAddressInput: String ) {
        currentResidents = [FishProfile]()
        self.idCounter = 0
        self.userName = "Robert"
        messenger = Messenger(ipAddress: ipAddressInput)
        
        tempHistory = [70, 69 ,68, 75, 76, 80, 85, 76]
        pHHistory = [4.00, 7.6, 8.0, 7.8, 6.9 ]
        
    }
    
    //This is for assigning unique ID's for fish
    func getNextID()-> Int {
        let nextId = self.idCounter
        self.idCounter += 1
        return nextId
    }
    
    
    //Adds a new fish to the tank, updates temperature range accordingly
    func addFish(fishEntry fish: FishProfile){

        self.currentResidents.append(fish)
        
        let newMaxT = fish.breedData!.maxTemp
        let newMinT = fish.breedData!.minTemp
        let newMaxP = fish.breedData!.maxPh
        let newMinP = fish.breedData!.minPh
        
        addRange(newMaxT, newMinT, newMaxP, newMinP)
        
        //Send data to tank
        if self.sendingTempRange {
            let _ = self.messenger.sendTempRangeAvg(max: maxTemp, min: minTemp)
        }
        
    }
    
    //
    func addRange(_ newMaxTempIn: Double, _ newMinTempIn: Double, _ newMaxpHIn: Double, _ newMinpHIn: Double) {
        
        // Update overall temp range accordingly
        let newMax = [self.maxTemp, newMaxTempIn].min()
        self.maxTemp = newMax!

        let newMin = [self.minTemp, newMinTempIn].max()
        self.minTemp = newMin!
        
        // Update overall pH range accordingly
        let newMaxpH = [self.maxpH, newMaxpHIn].min()
        self.maxpH = newMaxpH!
        
        let newMinpH = [self.minpH, newMinpHIn].max()
        self.minpH = newMinpH!
        
    }
    
    //Sets back to defaults and then narrows down fish by fish again
    func recalculateRanges() {
        self.maxTemp = 90
        self.minTemp = 50
        self.maxpH = 14.00
        self.minpH = 0
        
        for fish in self.currentResidents {
            
            let newMaxT = fish.breedData!.maxTemp
            let newMinT = fish.breedData!.minTemp
            let newMaxP = fish.breedData!.maxPh
            let newMinP = fish.breedData!.minPh
            
            addRange(newMaxT, newMinT, newMaxP, newMinP)
        }
        
        //Send data to tank
        let _ = self.messenger.sendTempRangeAvg(max: maxTemp, min: minTemp)
        
    }
    
    
    
    //Removes a fish from the tank by id
    func removeFish(id: Int) {
        
        var index = -1
        
        if self.currentResidents.isEmpty {
            return
        }
        
        for i in (0...self.currentResidents.count - 1) {
            if self.currentResidents[i].id == id {
                index = i
            }
        }
        if index < 0 {
            return
        }
        self.currentResidents.remove(at: index)
        
        recalculateRanges()
    }
    
    func clearFish() {
        self.currentResidents.removeAll()
        recalculateRanges()
    }

    
    // Function to set the IP address for the messenger server
    func SetServer(ipAddress: String) {
        self.messenger.setIPAdress(ipAddress_in: ipAddress)
    }
    
}


