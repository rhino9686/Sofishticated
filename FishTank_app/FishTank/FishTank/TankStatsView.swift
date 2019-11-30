//
//  TankStatsView.swift
//  FishTank
//
//  Created by Robert Cecil on 10/20/19.
//  Copyright © 2019 Robert Cecil. All rights reserved.
//

import SwiftUI

let myGrey = Color(red: (30/255), green: (30/255), blue: (30/255), opacity: 1.0)

struct TankStatsView: View {
    //Our tank Data packet
    @EnvironmentObject var tankData: TankProfile
    
    //String vars to display things easier
    @State var currentTempStr = "70"
    @State var currentpHStr = "6.03"
    @State var lastTimeChecked = "3 hours ago"
    @State var overallHealth = "Good"
    
    //Colors to dislpay things, to show health of system
    @State var healthColor: Color = .green
    @State var tempColor: Color = .blue
    @State var pHColor: Color = .blue
    
    //Timer to get the "last time checked" to update by itself
    let timer = Timer.publish(every: 20, on: .main, in: .common).autoconnect()
    
    
    func update() {
        print("updating")
        self.tankData.updateParams()
        self.currentTempStr = self.tankData.currentTemp
        self.currentpHStr = self.tankData.currentpHStr
        self.lastTimeChecked = self.tankData.lastTimeChecked
        self.overallHealth = self.tankData.category
    }
    
    var body: some View {
        
        VStack {
            HStack {
                Text("Health: ")
                    .font(.title)
                    .fontWeight(.medium)
                Text("Good")
                    .font(.title)
                    .foregroundColor(healthColor)
                Spacer()
            }
            .padding(.top)
    
            
            HStack {
                Text("Last checked: \(self.lastTimeChecked)")
                    .onReceive(timer) { input in
                    self.lastTimeChecked = self.tankData.lastTimeChecked
                }
                    .font(.footnote)
                
                Spacer()

                Button(action: {
                   
                }, label: {
                    Image(systemName: "arrow.clockwise")
                })
                    .foregroundColor(Color.white)
                    .padding(10)
                .background(myGrey)
                .onTapGesture {  self.update() } //This updates Temp, pH, time
                .cornerRadius(5)
                .padding(.trailing)
                
            }
       
            HStack {
                Text("Temperature: ")
                Text("\(self.currentTempStr)")
                    .foregroundColor(tempColor)

                Spacer()
            }
            .padding(.top, 5)
     
            
            //pH label
            HStack {
                Text("pH balance: ")
                Text("\(self.tankData.currentpHStr)")
                    .foregroundColor(pHColor)
                Spacer()
            }
            .padding(.top).padding(.bottom)
            
        }
        .padding(.leading, 6)
    }
}

struct TankStatsView_Previews: PreviewProvider {
   @State static var tank = TankProfile()
    static var previews: some View {
        
        TankStatsView()
        .environmentObject(TankProfile())
        .previewLayout(.fixed(width: 350, height: 250))
    }
}
