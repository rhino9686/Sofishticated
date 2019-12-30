//
//  FishProfile.swift
//  FishTank
//
//  Created by Robert Cecil on 10/15/19.
//  Copyright © 2019 Robert Cecil. All rights reserved.
//
/*
Abstract:
The model for an individual fish.
*/


import SwiftUI
import Foundation


// Represents a fish in the tank
struct FishProfile: Hashable, Codable {
    var name: String
    var id: Int
    fileprivate var imageName: String
    
    var breedData: FishBreedData?
    
    mutating func setBreed(_ breed: String, _ maxTempIn: Double, _ minTempIn: Double, _ maxPhIn: Double, _ minPhIn: Double) {
        
        self.breedData = FishBreedData(breed,maxTempIn,minTempIn, maxPhIn, minPhIn)
    }
    
    init() {
        self.name =  "howie"
        self.id = 2
        imageName = "goldfish"
    }
    
    init(name_in: String, id_in: Int, img_in: String  ) {
        self.name =  name_in
        self.id = id_in
        imageName = img_in
    }
}

extension FishProfile {
    var image: Image {
        ImageStore.shared.image(name: imageName)
    }
}


// Represents a Breed of fish, may be shared by multiple fish profiles if user has two of the same breed
struct FishBreedData: Hashable, Codable {
    var breedName: String
    
    var maxTemp: Double
    var minTemp: Double
    
    var maxPh: Double
    var minPh: Double

    var imageName: String = "goldfish"
    
    var fishFact1: String?
    
    var fishFact2: String?
    
    var fishFact3: String?
    
    var fishFact4: String?
    
    
    //Computed property strings to get values with truncated decimals
    
    var maxTempStr_F: String {
        return String(format: " %.0f", self.maxTemp)
    }
    
    var minTempStr_F: String {
        return String(format: " %.0f", self.minTemp)
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
        return String(format: " %.2f", self.maxPh)
    }
    
    var minpHStr: String {
        return String(format: " %.2f", self.minPh)
    }
    
    //Constructor to easily create a breed packet
    init(_ breed: String, _ maxTempIn: Double, _ minTempIn: Double, _ maxPhIn: Double, _ minPhIn: Double ) {
        breedName = breed
        maxTemp = maxTempIn
        minTemp = minTempIn
        maxPh = maxPhIn
        minPh = minPhIn
        
    }

}

extension FishBreedData{
    var image: Image {
        ImageStore.shared.image(name: imageName)
    }
}
