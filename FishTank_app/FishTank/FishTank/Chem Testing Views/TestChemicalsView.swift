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
    
    let testEverythingStr = "Regularly check chemical buildup in your tank"
    
    let ammoniaStr = "Ammonia naturally builds up from your fishes' uneaten food and solid waste. It's good to test for it occasionally."
    
    let nitrateStr = "Nitrates and Nitrites naturally occur from the Ammonia breaking down, you should test for them too."
    
    @State var ammoniaVal: String = "Not tested"
    @State var nitrateVal: String = "Not tested"
    @State var nitriteVal: String = "Not tested"
    
    
    func update() {
        self.tankData.getChems()
        
        self.ammoniaVal  =  "\(self.tankData.ammoniaStat)"
        self.nitrateVal  =  "\(self.tankData.nitrateStat)"
        self.nitriteVal  =  "\(self.tankData.nitriteStat)"
    }
    
    
    var body: some View {
        
        List {
   
                Text(self.testEverythingStr)
                  .font(.subheadline)
                    .padding().foregroundColor(.gray)
            
                Spacer()
            
                Text(self.ammoniaStr)
                    .font(.footnote).foregroundColor(.gray)
            
                NavigationLink(destination: AmmoniaTestingView()) {
                    Text("Check Ammonia")
                        .fontWeight(.heavy)
                   }
                
                HStack {
                    Text("Ammonia Levels:")
                        .font(.footnote)
                    Text(self.ammoniaVal).font(.footnote)
                        .foregroundColor(tankData.ammonColor)
                }
            
    
                Text(self.nitrateStr)
                    .font(.footnote).foregroundColor(.gray)
            
             
                NavigationLink(destination: NitratesTestingView()) {
                    Text("Check Nitrates")
                        .fontWeight(.heavy)
                   }
            
                HStack {
                    Text("Nitrate Levels:")
                        .font(.footnote)
                    Text(self.nitrateVal).font(.footnote)
                    .foregroundColor(tankData.nitrateColor)
                }
                HStack {
                    Text("Nitrite Levels:")
                        .font(.footnote)
                    Text(self.nitriteVal).font(.footnote)
                    .foregroundColor(tankData.nitriteColor)
                }
            
            
                HStack {
                    Text("Refresh ")
                        .font(.footnote)
                    
                    Spacer()

                    Button(action: {
                       
                    }, label: {
                        Image(systemName: "arrow.clockwise")
                    })
                        .foregroundColor(Color.white)
                        .padding(10)
                    .background(myGrey)
                    .onTapGesture {  self.update() } //This updates stuff
                    .cornerRadius(5)
                    .padding(.trailing)
                    
                }
            
                
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
