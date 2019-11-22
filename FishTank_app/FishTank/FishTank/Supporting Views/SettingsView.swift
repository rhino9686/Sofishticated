//
//  SettingsView.swift
//  FishTank
//
//  Created by Robert Cecil on 11/3/19.
//  Copyright © 2019 Robert Cecil. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    @Binding var tankData: TankProfile
    
    var body: some View {
            List {

                ToggleTempView(inFar: $tankData.inFahrenheight)
                
                NavigationLink(destination: TestConnectionView()) {
                     Text("Test Wifi Connection")
                     .fontWeight(.semibold)
                 }
                
                NavigationLink(destination: TestConnectionView()) { //CHANGE
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
                        if inFar {
                            Text("Fahrenheit")
                        }
                        else {
                            Text("Celcius")
                        }
                    }.padding(.trailing)

                }
                
            }.padding(.trailing, 5)

            Toggle(isOn: $inFar, label: {
                HStack {
                    Text("Temperature")
                    .fontWeight(.semibold)
                    
                    Spacer()
                    Group {
                        if inFar {
                            Text("Fahrenheit")
                        }
                        else {
                            Text("Celcius")
                        }
                    }.padding(.trailing)

                }
            }).padding(.trailing, 5)
            

        }
    }
}


struct SettingsView_Previews: PreviewProvider {
    @State static var tank = TankProfile()
    
    static var previews: some View {
        SettingsView(tankData: $tank)
    }
}
