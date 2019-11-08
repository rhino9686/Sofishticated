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
    
    let messenger: Messenger
    
    var inFahrenheight = true;
    
    //Placeholder array of fish
    var placeHolderFish = fishData
    //array to use later, store in persistent memory
    var currentResidents: [FishProfile]
    
    //Current Temperature of the tank (in degrees Fahrenheit)
    @Published var currentTempF: Double = 80
    
    //Current Temperature of the tank formatted in a string
    var currentTemp: String {
        if inFahrenheight {
            let tempInt = Int(self.currentTempF)
            return String(tempInt)
        }
        else {
            let currentTempC = Int((currentTempF - 32) * 5.0 / 9.0)
            return String(currentTempC)
        }
        
    }
    
    //Current pH level of the tank
    @Published var currentPh: Double = 7.0
    
    //Current pH formatted to 2 decimal places in a string
    var currentpHStr: String {
        let pH = currentPh
        return String(format: " %.2f", pH)
    }
    
    // time since tank was checked last (in minutes)
    @Published var lastCheckedTimeInMins = 3
    
    var lastTimeChecked: String {
        if self.lastCheckedTimeInMins < 60 {
            return " \(self.lastCheckedTimeInMins) minutes ago"
        }
        else {
            let lastCheckedTimeInHours = Int(self.lastCheckedTimeInMins) / 60
            //Intentionally doing integer division truncating here
            return " \(lastCheckedTimeInHours) hours ago"
        }

    }
    
    var category: Health {
        //Will need more robust logic
        if self.currentTempF > 0 {
            return Health.good
        }
        else {
            return Health.ok
        }
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
        messenger = Messenger(ipAddress: "0.0.0.1")
        
    }
    
    // Extra constructor for variable IP address
    init( ipAddressInput: String ) {
        currentResidents = [FishProfile]()
        messenger = Messenger(ipAddress: ipAddressInput)
        
    }
    
    
    //Adds a new fish to the tank
    func addFish(fishEntry fish: FishProfile){
        return
    }
    
    //Removes a fish from the tank by id
    func removeFish(id: Int) {
        return
    }
    
    func calculateTimeDelta() {
        return
    }
    
    
    func updateParams() {
        return
    }
    
}


