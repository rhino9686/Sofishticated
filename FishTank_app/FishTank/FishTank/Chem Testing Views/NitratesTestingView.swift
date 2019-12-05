//
//  NitrateTestingView.swift
//  FishTank
//
//  Created by Robert Cecil on 11/24/19.
//  Copyright © 2019 Robert Cecil. All rights reserved.
//

import SwiftUI

struct NitratesTestingView: View {
    @EnvironmentObject var tankData : TankProfile
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var index: Int = 0
    
    let phases = [0, 1, 2, 3]
    let phaseNames = ["Step 1", "Step 2", "Step 3", "Step 4" ]
    
    var body: some View {
        ZStack {
            
            Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)).edgesIgnoringSafeArea(.top)
            
            VStack {
                Text("Testing Nitrates and Nitrites")
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
                            Text("Nitrate Test")
                            Text("Dip the nitrate Test strip into your tank and hold still for 2 seconds")
                                .font(.caption)
                        
                            Text("Remove and wait for 60 seconds")
                                .font(.caption)
                         
                            FittedImage(image: Image("Nitrates"), width: 220, height: 280)
                            
                            Button(action:{ self.sendNitrateTestCmd()
                                            self.nextStep()
                            }) {
                                    Text("Next Step")
    
                            }.padding()
                        }
                    }//if
                        
                    else if self.index == 1 {
                        VStack {
                            
                            Text("Insert test strip into sensor slot")
                                .font(.caption)
                            Text("with colored side facing down")
                                .font(.caption)
                            Text("until the LED turns green")
                                .font(.caption)
                            
                            FittedImage(image: Image("face_down"), width: 220, height: 280)
                            
                            Button(action:{ self.sendNitriteTestCmd()
                                            self.getNitrateVal()
                                            self.nextStep()
                                }) {
                                    Text("Read Nitrate Value")
        
                            }.padding()
                        }
                    }//if
                        
                    else if self.index == 2 {
                          VStack {
                            Text("Nitrite Test")
                            Text("Now push test strip in further")
                                .font(.caption)
                        
                            Text("until LED turns blue")
                                .font(.caption)
                         
                            FittedImage(image: Image("face_down"), width: 220, height: 280)
                            
                            Button(action:{ self.getNitriteVal()
                                            self.nextStep()
                            }) {
                                    Text("Read Nitrite Value")

                            }.padding()
                        }
                    }//if
                    
                    else if self.index == 3 {
                       VStack {
                            Text("All Done")
                        
                            Button(action:{
                                            self.nextStep()
                                }) {
                                    Text("Return to Testing screen")
        
                            }.padding()
                        }
                    }//if
                }
                
                Spacer()
            
                
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
    
    // Tells the chip to initiate a color sensor test for Nitrate
    func sendNitrateTestCmd() {
        self.tankData.promptNitrateTest()
        return
    }
    
    // Tells the chip to return the nitrate color sensor value
    func getNitrateVal() {
        self.tankData.getNitrateVal()
        return
    }
    
    // Tells the chip to initiate a color sensor test for Nitrate
    func sendNitriteTestCmd() {
        self.tankData.promptNitriteTest()
        return
    }
    
    // Tells the chip to return the nitrate color sensor value
    func getNitriteVal() {
        self.tankData.getNitriteVal()
        return
    }
    
    
}

struct NitratesTestingView_Previews: PreviewProvider {
    static var previews: some View {
        NitratesTestingView()
    }
}
