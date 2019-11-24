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
    
    var body: some View {
        
        VStack {
                Spacer()
                
                Button(action: {
                    
                }) {Text("Check Nitrates")}
                
                Spacer()
            
                Button(action: {
                    
                }) {Text("Check Nitrites")}
            
                Spacer()
            
                Button(action: {
                    
                }) {Text("Check Ammonia")}
            
                Spacer()
            
                
            }
        .navigationBarTitle(Text("Test Chemical Levels")
        .font(.headline))
        }

}

struct TestChemicalsView_Previews: PreviewProvider {
    static var previews: some View {
        TestChemicalsView()
         .environmentObject(TankProfile())
    }
}
