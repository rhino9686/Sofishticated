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
    
    
    let myData: [Double] = [56.4, 54.7]
    
    var body: some View {
        List {
            
            HStack {
                Text("Health: ")
                    .font(.title)
                    .fontWeight(.medium)
                Text(self.tankData.category)
                    .font(.title)
                    .foregroundColor(self.tankData.healthColor)
                Spacer()
            }
            .padding(.top)
            
            HStack {
                Text(self.tankData.currentWarning)
                    .font(.footnote)
                    .foregroundColor(.yellow)
                Spacer()
            }.padding(.top,3)
            
            
        
            HStack {
                Text("Current Temp:" )
                    .font(.callout)
                Text("\(tankData.currentTemp) ")
                Spacer()
                Group {
                       if tankData.inFahrenheight {
                           Text("Ideal range: \(tankData.minTempStr_F) - \(tankData.maxTempStr_F) °F")
                               .font(.caption)
                       }
                       else {
                           Text("Ideal range: \(tankData.minTempStr_C) - \(tankData.maxTempStr_C) °C")
                               .font(.caption)
                       }
                }
            }
        
            
            
            HStack {
                Text("Current pH:" )
                    .font(.callout)
                Text("\(tankData.currentpHStr)")
                Spacer()
                Text("Ideal pH range: \(tankData.minpHStr) - \(tankData.maxpHStr)")
                    .font(.caption)
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
