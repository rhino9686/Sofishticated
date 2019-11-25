//
//  TestingView.swift
//  FishTank
//
//  Created by Robert Cecil on 11/24/19.
//  Copyright © 2019 Robert Cecil. All rights reserved.
//

import SwiftUI

struct AllTestingView: View {
    
   @State var index: Int = 0
    let phases = [0, 1, 2, 3, 4]
    let phaseNames = ["Step 1", "Step 2", "Step 3", "Step 4", "Step 5"]
    
    var body: some View {
        ZStack {
            
            Color(#colorLiteral(red: 0, green: 0.831172049, blue: 0.4382669926, alpha: 1)).edgesIgnoringSafeArea(.top)
            
            VStack {
                Text("Testing Everything")
                    .fontWeight(.heavy)
                
                Picker(selection: $index, label: Text("")) {
                    ForEach(self.phases, id: \.self){
                        Text(self.phaseNames[$0])
                  }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                
                Divider()
                
                Group {
                    if self.index == 0 {
                       Text("Step 1")
                    }
                    else if self.index == 1 {
                        Text("Step 2")
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
                
                Divider()
                

                
                Button(action: {
                    self.index = (self.index + 1) % 5
                }){
                    if self.index == 4 {
                        Text("Finish")
                        
                    }
                    else {
                        Text("Next Step")
                    }
        
                }.buttonStyle(PlainButtonStyle())
                
            }
        }
    }
}

struct AllTestingView_Previews: PreviewProvider {
    static var previews: some View {
        AllTestingView()
    }
}
