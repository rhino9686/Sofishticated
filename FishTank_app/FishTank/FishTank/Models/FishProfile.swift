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

struct FishProfile: Hashable, Codable {
    var name: String
    var id: Int
    fileprivate var imageName: String

}

extension FishProfile {
    var image: Image {
        ImageStore.shared.image(name: imageName)
    }
}


