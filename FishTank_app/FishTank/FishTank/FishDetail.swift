//
//  FishDetail.swift
//  FishTank
//
//  Created by Robert Cecil on 10/21/19.
//  Copyright © 2019 Robert Cecil. All rights reserved.
//

import SwiftUI

struct FishDetail: View {
    var fish: FishProfile
    
    var body: some View {
        VStack {
            CircleImage(fish: fish)
            Text(fish.name)
                .font(.title)
            Text("Goldfish")
                .font(.caption)
            Spacer()
        }.frame(height:600)
    }
}

struct FishDetail_Previews: PreviewProvider {
    static var previews: some View {
        FishDetail(fish: fishData[1])
    }
}
