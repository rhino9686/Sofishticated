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
            
            
        Section(header: Text("Snapshot")) {
                        
                         
            // Divider()
             NavigationLink(destination:
                 TestChemicalsView()
                            .environmentObject(self.tankData)
             ) {
                 Text("Check Chemicals")
                     .font(.footnote)
                     .fontWeight(.bold)
             }.padding(5).padding(.top, 7).padding(.bottom, 7)
             
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
