//
//  Home.swift
//  FishTank
//
//  Created by Robert Cecil on 10/28/19.
//  Copyright © 2019 Robert Cecil. All rights reserved.
//

import SwiftUI

let lightGrey = Color(red: (220/255), green: (220/255), blue: (220/255), opacity: 1.0)

struct TankHome: View {
    @EnvironmentObject private var tankData: TankProfile
    @State var incr = 1;
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: FishDetail(fish: fishData[0])) {
                     FishRow(fishProfile: fishData[0])
                }
            
                NavigationLink(destination: FishDetail(fish: fishData[1])) {
                     FishRow(fishProfile: fishData[1])
                }
                
                NavigationLink(destination: AddFishView()) {
                     AddFishButton(incr: self.$incr)
                        .padding(.top)
                }
                

                    
                
                
                Divider()
                TankStatsView()
                    .environmentObject(self.tankData)
                    .edgesIgnoringSafeArea(.leading)
                    .edgesIgnoringSafeArea(.trailing)
                    .overlay(
                        RoundedRectangle(cornerRadius: 7)
                            .stroke(Color.black, lineWidth: 1)
                    )
                
                Divider()
                NavigationLink(destination: RemindersView()) {
                    Text("Reminders")
                    .fontWeight(.semibold)
                }
                NavigationLink(destination: RemindersView()) {
                    Text("Settings")
                    .fontWeight(.semibold)
                }
                .padding(.top)

                
            }
        .navigationBarTitle(Text("Robert's Tank"))
        }

    }
}

struct TankHome_Previews: PreviewProvider {
    static var previews: some View {
        TankHome()
         .environmentObject(TankProfile())
    }
}


struct AddFishButton: View {
    @Binding var incr: Int
    var body: some View {
        HStack {
            
            Button(action: {self.incr = self.incr + 1}) {
                Text("+ Add new fish")
                    .fontWeight(.medium)
                    .font(.footnote)
                .padding(8)
                .cornerRadius(10)
                .padding(2)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 2)
                )
            }
            Spacer()
            

            
        }

    }
}
