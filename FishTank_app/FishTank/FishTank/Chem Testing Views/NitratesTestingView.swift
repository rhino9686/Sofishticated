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
                            Text("Dip the nitrate Test strip into your tank")
                                .font(.caption)
                        
                            Text("and hold it still, for 2 seconds")
                                .font(.caption)
                         
                            FittedImage(image: Image("placeholder"), width: 220, height: 280)
                            
                            Button(action:{ self.sendAmmoniaTestCmd()
                                            self.nextStep()
                            }) {
                                    Text("Next Step")
    
                            }.padding()
                        }
                    }//if
                        
                    else if self.index == 1 {
                        VStack {
                            Button(action:{ self.getAmmoniaVal()
                                            self.nextStep()
                                }) {
                                    Text("Read Value Nitrate Value")
        
                            }.padding()
                        }
                    }//if
                        
                    else if self.index == 2 {
                          VStack {
                            Text("Nitrate Test")
                            Text("Dip the nitrate Test strip into your tank")
                                .font(.caption)
                        
                            Text("and hold it still, for 2 seconds")
                                .font(.caption)
                         
                            FittedImage(image: Image("placeholder"), width: 220, height: 280)
                            
                            Button(action:{ self.sendAmmoniaTestCmd()
                                            self.nextStep()
                            }) {
                                    Text("Next Step")

                            }.padding()
                        }
                    }//if
                    
                    else if self.index == 3 {
                       VStack {
                            Button(action:{ self.getAmmoniaVal()
                                            self.nextStep()
                                }) {
                                    Text("Read Value Nitrate Value")
        
                            }.padding()
                        }
                    }//if
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

struct NitratesTestingView_Previews: PreviewProvider {
    static var previews: some View {
        NitratesTestingView()
    }
}
