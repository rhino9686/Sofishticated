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
    
    @EnvironmentObject var tankData: TankProfile
    @State var currentTempStr = "70"
    @State var currentpHStr = "6.03"
    @State var lastTimeChecked = "3 hours ago"
    
    //Timer to get the "last time checked" to update by itself
    let timer = Timer.publish(every: 20, on: .main, in: .common).autoconnect()
    
    
    func update() {
        print("updating")
        self.tankData.updateParams()
        self.currentTempStr = self.tankData.currentTemp
        self.currentpHStr = self.tankData.currentpHStr
        self.lastTimeChecked = self.tankData.lastTimeChecked
    }
    
    var body: some View {
        
        VStack {
            HStack {
                Text("Health: ")
                    .font(.title)
                    .fontWeight(.medium)
                Text("Good")
                    .font(.title)
                    .foregroundColor(Color.green)
                    .padding(.top)
                    .padding(.bottom)
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

                Group {
                    Button(action: {
                       
                    }, label: {
                        Image(systemName: "arrow.clockwise")
                    })
                        .foregroundColor(Color.white)
                        .padding(10)
                    .background(myGrey)
                    .onTapGesture {  self.update() } //This updates all params
                    .cornerRadius(5)
                }.padding(.trailing)

            }
       
            HStack {
                Text("Temperature: ")
             //   let format = String(format: " %.2f ", self.tankData.currentTempF)
                Text("\(self.currentTempStr)")
                    .foregroundColor(Color.blue)

                Spacer()
            }
            .padding(.top)
     
            
            //pH label
            HStack {
                Text("pH balance: ")
                Text("\(self.tankData.currentpHStr)")
                    .foregroundColor(Color.blue)
                Spacer()
            }
           
            .padding(.top)
            
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
