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
    
    @Published var userName: String
    
    
    //Our HTTPClient
    let messenger: Messenger
    
    //Boolean to show whether we are showing tank temp in F or C
    @Published var inFahrenheight = true;
    
    //Placeholder array of fish
    var placeHolderFish = fishData
    
    //Array of FishBreeds
    var breeds = fishBreedData
    
    //Array to use later, store in persistent memory
    @Published var currentResidents: [FishProfile]
    
    @Published var notifyMan = LocalNotificationManager()
    
    
    //Running Max/Min Temps accounting for all fish
    @State var maxTemp: Double = 80
    @State var minTemp: Double = 0
    
    
    //Running Max/Min pH vals accounting for all fish
    @State var maxpH: Double = 14
    @State var minpH: Double = 0
    
    
    //Counter variable to give each fish a unique ID
    var idCounter: Int
    
    //Current Temperature of the tank formatted in a string
    var currentTemp: String {
        var tempDouble: Double = 8
        
        tempDouble  = self.messenger.currentTempF
           
        if inFahrenheight {
            let tempInt = Int(tempDouble)
            return String(tempInt) + " ° F"
        }
        else {
            let currentTempC = Int((tempDouble - 32) * 5.0 / 9.0)
            return String(currentTempC) + " ° C"
        }
        
    }
    
    //Current pH formatted to 2 decimal places in a string
    var currentpHStr: String {
        let pH = self.messenger.currentPh
        return String(format: " %.2f", pH)
    }
    
    
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /// Functions to update and fetch values using the HTTP Messenger
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func updateParams() {
        self.messenger.refreshParams()
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
    
    var category: String {
        //Will need more robust logic
        if self.messenger.currentTempF > 0 {
            return String(Health.good.rawValue)
        }
        else {
            return String(Health.ok.rawValue)
        }
    }
    
    var warningMessage: String {
        return "Yikes"
    }
    
    
    enum Health: String, CaseIterable, Codable, Hashable {
        case good = "Good"
        case ok = "Ok"
        case bad = "Bad"
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
        
    }
    
    // Extra constructor for variable IP address
    init( ipAddressInput: String ) {
        currentResidents = [FishProfile]()
        self.idCounter = 0
        self.userName = "Robert"
        messenger = Messenger(ipAddress: ipAddressInput)
    }
    
    //This is for assigning unique ID's for fish
    func getNextID()-> Int {
        let nextId = self.idCounter
        self.idCounter += 1
        return nextId
    }
    
    
    //Adds a new fish to the tank
    func addFish(fishEntry fish: FishProfile){

        self.currentResidents.append(fish)
        
        // Update overall temp range accordingly
        self.maxTemp = min(self.maxTemp, fish.breedData!.maxTemp)
        self.minTemp = max(self.minTemp,  fish.breedData!.minTemp)
        
        
        // Update overall pH range accordingly
        self.maxpH = min(self.maxpH, fish.breedData!.maxPh)
        self.minpH = max(self.minpH,  fish.breedData!.minPh)
        
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
    }
    

    
    // Function to set the IP address for the messenger server
    func SetServer(ipAddress: String) {
        self.messenger.setIPAdress(ipAddress_in: ipAddress)
    }
    
    
    
    
}


