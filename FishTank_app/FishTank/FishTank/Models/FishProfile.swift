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
