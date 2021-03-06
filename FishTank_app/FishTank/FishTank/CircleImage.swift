//
//  CircleImage.swift
//  FishTank
//
//  Created by Robert Cecil on 10/14/19.
//  Copyright © 2019 Robert Cecil. All rights reserved.
//

import SwiftUI

struct CircleImage: View {
    
    var fish: FishProfile
    
    var body: some View {
        fish.image
            .resizable()
            .clipShape(Circle())
            .overlay(
                Circle().stroke(Color.white, lineWidth: 4))
            .shadow(radius: 10)
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage(fish: fishData[1])
    }
}
