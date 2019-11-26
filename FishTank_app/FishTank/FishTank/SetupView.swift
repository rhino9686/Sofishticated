//
//  SetupView.swift
//  FishTank
//
//  Created by Robert Cecil on 11/26/19.
//  Copyright © 2019 Robert Cecil. All rights reserved.
//

import SwiftUI

struct SetupView: View {
    @EnvironmentObject var tankData : TankProfile
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var userName: String = ""
    
    @State private var wifiName: String = ""
    @State private var wifiPassword: String = ""
    
    @State var index: Int = 0
    let phases = [0, 1, 2, 3, 4, 5]
    let phaseNames = ["Step 1", "Step 2", "Step 3", "Step 4", "Step 5", "Step 6"]
    
    var body: some View {
        ZStack {
            //Find same color as form and enter it as background color
            VStack {
                Text("Set up your Fish Tank" )
                    .fontWeight(.heavy)
                
                Picker(selection: $index, label: Text("")) {
                    ForEach(self.phases, id: \.self){
                        Text(self.phaseNames[$0])
                            .font(.caption)
                  }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                Spacer()
                
                Group {
                    //First Step
                    if self.index == 0 {
                       VStack {
                            Text("Name")
                            Form {
                                Section(header: Text("Your Name")) {
                                       TextField("Enter name", text: $userName)
                                }
                                
                                Button(action:{
                                                self.nextStep()
                                }) {
                                        Text("Set")
        
                                }//.padding()
                            }.padding(.bottom, 10)

                        }
                    }
                    else if self.index == 1 {
                           VStack {
                            Text("Connect to the tank WiFi")
                            Text("open up Settings and connect to FishTank")
                                .font(.caption)
                         
                            FittedImage(image: Image("placeholder"), width: 220, height: 280)
                            
                            Button(action:{ self.sendAmmoniaTestCmd()
                                            self.nextStep()
                            }) {
                                    Text("Next Step")

                            }.padding()
                        }
                    }
                    else if self.index == 2 {
                          VStack {
                               Text("Enter your home's wifi and password")
                               Form {
                                    Section(header: Text("Network Name")) {
                                          TextField("Enter name", text: $wifiName)
                                    }
                                    Section(header: Text("Network Password")) {
                                           TextField("Enter name", text: $wifiPassword)
                                    }
                                   
                                   Button(action:{
                                                   self.nextStep()
                                   }) {
                                           Text("Check")
           
                                   }//.padding()
                               }.padding(.bottom, 10)

                           }
                    }
                    
                    else if self.index == 3 {
                        Text("All good! Switch back to your home network now")
                    }
                    
                    else if self.index == 4 {
                        VStack {
                            Text("Done!")
                            Button(action:{ self.sendAmmoniaTestCmd()
                                            self.nextStep()
                            }) {
                                Text("Launch FishTank")

                            }.padding()

                        }
                    }
                    
                }
                
                Spacer()
            
                Button(action: nextStep) {
                    if self.index == self.phases.count - 1 {
                        Text("Finish")
                    }
                    else {
                        Text("Next Step")
                    }
        
                }.buttonStyle(PlainButtonStyle()).padding(.bottom)
                
            }
        }
    }
    
    
    func nextStep() {
        if self.index == self.phases.count - 1 {
            self.presentationMode.wrappedValue.dismiss()
            return
        }
        self.index = (self.index + 1) % self.phases.count
    }
    
    // Tells the chip to initiate a color sensor test for Ammonia
    func sendAmmoniaTestCmd() {
        return
    }
    
    //
    func getAmmoniaVal() {
        return
    }
    
}

struct SetupView_Previews: PreviewProvider {
    static var previews: some View {
        SetupView()
    }
}
