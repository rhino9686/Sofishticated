//
//  SettingsView.swift
//  FishTank
//
//  Created by Robert Cecil on 11/3/19.
//  Copyright © 2019 Robert Cecil. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var tankData: TankProfile
    
    var body: some View {
            List {
                
            Section(header: Text("Your Name")) {
                    TextField("Enter name", text: $tankData.userName)
            }
                
            ToggleTempView(inFar: $tankData.inFahrenheight)
                
            NavigationLink(destination: TestConnectionView()) {
                     Text("Test Wifi Connection")
                     .fontWeight(.semibold)
                 }
                
                NavigationLink(destination: ResetTankView(ipAddress_in: "000")) {
                     Text("Reset Tank")
                     .fontWeight(.semibold)
                 }
                
            }
            .navigationBarTitle(Text("Settings"))
        
    
    }
}

struct ToggleTempView: View {
    @Binding var inFar: Bool

    var body: some View {
        VStack {
            Toggle(isOn: $inFar) {
                HStack {
                    
                    Text("Temperature")
                    .fontWeight(.semibold)
                    
                    Spacer()
                    Group {
                        Text("Celcius / Fahrenheit")
                            .font(.footnote)
   
                    }.padding(.trailing)

                }
                
            }.padding(.trailing, 5)
            

        }
    }
}


struct SettingsView_Previews: PreviewProvider {
    @State static var tank = TankProfile()
    
    static var previews: some View {
        SettingsView()
        .environmentObject(tank)
    }
}
