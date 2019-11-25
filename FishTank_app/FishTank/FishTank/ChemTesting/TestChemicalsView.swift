//
//  TestChemicalsView.swift
//  FishTank
//
//  Created by Robert Cecil on 11/24/19.
//  Copyright © 2019 Robert Cecil. All rights reserved.
//

import SwiftUI

struct TestChemicalsView: View {
    @EnvironmentObject var tankData: TankProfile
    
    let ammoniaStr = "Ammonia naturally builds up from your fishes' uneaten food and solid waste. It's good to test for it occasionally."
    
    
    let nitrateStr = "Nitrates and Nitrites naturally occur from the Ammonia breaking down, you should test for them too."
    
    
    
    var body: some View {
        
        List {
                Spacer()
                NavigationLink(destination: AllTestingView()) {
                      Text("Check Everything")
                          .fontWeight(.heavy)
                  }
            
                Spacer()
            
                Text(self.ammoniaStr)
                    .font(.footnote)
            
                NavigationLink(destination: AmmoniaTestingView()) {
                       Text("Check Ammonia")
                   }
            
                Spacer()
            
                Text(self.nitrateStr)
                    .font(.footnote)
            
                NavigationLink(destination: NitrateTestingView()) {
                       Text("Check Nitrates")
                   }
                
                NavigationLink(destination: NitriteTestingView()) {
                       Text("Check Nitrites")
                   }
            
                Spacer()
                
            }
        .navigationBarTitle(Text("Chemicals")
        .font(.headline))
        }

}

struct TestChemicalsView_Previews: PreviewProvider {
    static var previews: some View {
        TestChemicalsView()
         .environmentObject(TankProfile())
    }
}
