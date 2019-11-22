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
    @State var tankData: TankProfile
    
    var body: some View {
        NavigationView {
            List {
                
                Divider()
 
                Section(header: Text("Conditions")) {
                    TankStatsView(tankData: $tankData)
                    
                   // Divider()
                    NavigationLink(destination:
                            AddFishView()
                                    .environmentObject(self.tankData)
                    ) {
                        Text("Check Chemicals")
                            .font(.footnote)
                            .fontWeight(.bold)
                    }.padding(5).padding(.top, 7).padding(.bottom, 7)
                    
                }
                
        
                
                Section(header: Text("Residents")) {
                    ForEach(tankData.placeHolderFish, id: \.self) { fish in
                            NavigationLink(
                                destination: FishDetail(fish: fish)
                                    .environmentObject(self.tankData)
                            ){
                                FishRow(fishProfile: fish)
                        }
                    }.padding(.top, 6)
                    
                    ForEach(tankData.currentResidents, id: \.self) { fish in
                        
                       // Text(fish.name)
                            NavigationLink(
                                destination: FishDetail(fish: fish)
                                    .environmentObject(self.tankData)
                            ){
                                FishRow(fishProfile: fish)
                        }
                    }.padding(.top, 6)
                    
                }
                
                
                NavigationLink(destination:
                        AddFishView()
                                .environmentObject(self.tankData)
                ) {
                    Text("+ Add New fish")
                        .font(.footnote)
                        .fontWeight(.light)
                }.padding(.top)
                
                Divider()

                NavigationLink(destination: RemindersView()) {
                    Text("Reminders")
                    .fontWeight(.semibold)
                }
                
                NavigationLink(destination: SettingsView(tankData: $tankData)
                ) {
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
    @State static var tank = TankProfile()
    static var previews: some View {
        TankHome(tankData: tank)
         .environmentObject(TankProfile())
    }
}



