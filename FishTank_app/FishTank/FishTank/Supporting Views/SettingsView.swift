//
//  SettingsView.swift
//  FishTank
//
//  Created by Robert Cecil on 11/3/19.
//  Copyright © 2019 Robert Cecil. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    @Binding var resetModal: Bool
    @EnvironmentObject var tankData: TankProfile
    
    //Controls exiting the view
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
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
                
                Button(action: resetTank) {
                        Text("Reset Tank")
                       .fontWeight(.semibold)

                }
                
                
            }
            .navigationBarTitle(Text("Settings"))
        
    }
    
    func resetTank() {
        self.resetModal = true
        self.presentationMode.wrappedValue.dismiss()
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
                                  .font(.footnote)
                        }
                        else {
                            Text("Celcius")
                                  .font(.footnote)
                        }
  
                    }.padding(.trailing)

                }
                
            }.padding(.trailing, 5)
            

        }
    }
}


struct SettingsView_Previews: PreviewProvider {
    @State static var modalDisplayed: Bool = true
    
    static var previews: some View {
        SettingsView(resetModal: $modalDisplayed)
        .environmentObject(TankProfile())
    }
}
