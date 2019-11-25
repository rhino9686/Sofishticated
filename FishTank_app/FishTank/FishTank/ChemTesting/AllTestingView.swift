//
//  TestingView.swift
//  FishTank
//
//  Created by Robert Cecil on 11/24/19.
//  Copyright © 2019 Robert Cecil. All rights reserved.
//

import SwiftUI

struct AllTestingView: View {
    @EnvironmentObject var tankData : TankProfile
    @State var index: Int = 0
    let phases = [0, 1, 2, 3, 4, 5]
    let phaseNames = ["Step 1", "Step 2", "Step 3", "Step 4", "Step 5", "Step 6"]
    
    var body: some View {
        ZStack {
            
            Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)).edgesIgnoringSafeArea(.top)
            
            VStack {
                Text("Testing Everything")
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
                            Text("Ammonia Testing")
                            
                            Button(action:{ self.initAmmonia()
                                            self.nextStep()
                            }) {
                                    Text("Start Ammonia Test")
    
                            }.padding()
                        }
                        
                        
                        
                    }
                    else if self.index == 1 {
                        VStack {
                            Text("Insert Test Strip into Tank")
                            FittedImage(image: Image("placeholder"), width: 220, height: 280)
                            
                            Button(action:{ self.initAmmonia()
                                            self.nextStep()
                            }) {
                                    Text("Get Value from tank")
    
                            }.padding()
                            
                            
                        }
                    }
                    else if self.index == 2 {
                        Text("Step 3")
                    }
                    
                    else if self.index == 3 {
                        Text("Step 4")
                    }
                    
                    else if self.index == 4 {
                        Text("Step 5")
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
        
                    }.buttonStyle(PlainButtonStyle()).padding()
                
            }
        }
    }
    
    func initAmmonia() {
        self.index = self.index + 0
    }
    
    
    
    func nextStep() {
        self.index = (self.index + 1) % self.phases.count
    }
    
    
    
    
    
}

struct AllTestingView_Previews: PreviewProvider {
    static var previews: some View {
        AllTestingView()
        .environmentObject(TankProfile())
    }
}
