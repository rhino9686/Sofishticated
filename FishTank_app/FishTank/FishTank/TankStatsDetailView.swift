//
//  TankStatsDetailView.swift
//  FishTank
//
//  Created by Robert Cecil on 11/27/19.
//  Copyright © 2019 Robert Cecil. All rights reserved.
//

import SwiftUI

struct TankStatsDetailView: View {
    @EnvironmentObject var tankData : TankProfile
    
    var body: some View {
        List {
            
        HStack {
            Text("My temp range: \(tankData.minTempStr_F)- \(tankData.maxTempStr_F) °F")
            Spacer()
        }

            
        Section(header: Text("Temperature History")) {
                         
            FittedImage(image: Image("placeholder"), width: 150, height: 250)
        }
            
            
        Section(header: Text("pH History")) {
            FittedImage(image: Image("placeholder"), width: 150, height: 250)
             
        }
            
        }
       .navigationBarTitle("Tank Details")
        
        
        
        

    }
}


struct TankStatsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TankStatsDetailView()
        .environmentObject(TankProfile())
    }
}
