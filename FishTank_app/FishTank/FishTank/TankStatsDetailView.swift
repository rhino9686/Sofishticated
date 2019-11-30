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
    @State var index: Int = 1
    
    let phases = [0, 1]
    let phaseNames = ["Temperature History", "pH History"]
    
    let myData: [Double] = [56.4, 54.7]
    
    var body: some View {
        List {
            
            
            
        HStack {
            
            Group {
                if tankData.inFahrenheight {
                    Text("Temperature range: \(tankData.minTempStr_F)- \(tankData.maxTempStr_F) °F")
                }
                else {
                    Text("Temperature range: \(tankData.minTempStr_C)- \(tankData.maxTempStr_C) °C")
                }
            }

            Spacer()
        }
        
        HStack {
            
            Text("pH range: \(tankData.minpHStr)- \(tankData.maxpHStr)")

            Spacer()
        }
         
        Spacer()
    
        NavigationLink(destination: ParamHistoryView(tankData: tankData, param: "Temperature")
   
        ) {
            Text("Temperature History")
            .fontWeight(.semibold)
        }

         NavigationLink(destination: ParamHistoryView(tankData: tankData, param: "pH")
    
         ) {
             Text("pH History")
             .fontWeight(.semibold)
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
