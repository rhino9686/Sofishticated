//
//  SettingsView.swift
//  FishTank
//
//  Created by Robert Cecil on 11/3/19.
//  Copyright © 2019 Robert Cecil. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject private var tankData: TankProfile
    
    var body: some View {
        
        
        
            List {

            
                ToggleTempView()
                
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
    @State private var showGreeting = true

    var body: some View {
        VStack {
            Toggle(isOn: $showGreeting) {
                HStack {
                    Text("Temperature")
                    .fontWeight(.semibold)
                    
                    Spacer()
                    Group {
                        if showGreeting {
                            Text("Fahrenheit")
                        }
                        else {
                            Text("Celcius")
                        }
                    }.padding(.trailing)

                }
                
            }.padding(.trailing, 5)


        }
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
          .environmentObject(TankProfile())
    }
}
