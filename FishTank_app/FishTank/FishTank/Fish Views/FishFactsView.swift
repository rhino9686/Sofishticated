//
//  FishFactsView.swift
//  FishTank
//
//  Created by Robert Cecil on 11/25/19.
//  Copyright © 2019 Robert Cecil. All rights reserved.
//

import SwiftUI

struct FishFactsView: View {
    @State var fish: FishProfile
    
    let Fact1 = "Fish Eat food"
    
    
    var body: some View {
        Text(Fact1)
    }
}

struct FishFactsView_Previews: PreviewProvider {
    static var previews: some View {
        FishFactsView(fish: fishData[1])
    }
}
