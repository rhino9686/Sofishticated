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
    
    @EnvironmentObject private var tankData: TankProfile
    
    func update() {
        print("updating")
        self.tankData.updateParams()
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
                Text("Last checked: \(self.tankData.lastTimeChecked)")
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
                Text("\(self.tankData.currentTemp)° F ")
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
     // .frame(width: 350, height: 200, alignment: .center )
    }
}

struct TankStatsView_Previews: PreviewProvider {
    static var previews: some View {
        TankStatsView()
        .environmentObject(TankProfile())
        .previewLayout(.fixed(width: 350, height: 250))
    }
}
