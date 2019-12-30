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
    @EnvironmentObject var tankData: TankProfile
    @EnvironmentObject var noteCenter: LocalNotificationManager
    @State var resetModalDisplayed = false
    
    var body: some View {
        NavigationView {
            List {
                
                Divider()
             //   Spacer()
 
                Section(header: Text("Conditions")) {
                    TankStatsView().environmentObject(self.tankData)
                    
                   // Divider()
                    NavigationLink(destination:
                        TestChemicalsView()
                                   .environmentObject(self.tankData)
                    ) {
                        Text("Check Chemicals")
                            .font(.footnote)
                            .fontWeight(.bold)
                    }.padding(5).padding(.top, 7).padding(.bottom, 7)
                    
                }
                
        
                Section(header: Text("Residents")) {
                    
                    ForEach(tankData.currentResidents, id: \.self) { fish in
                        
                       // Text(fish.name)
                            NavigationLink(
                                destination: FishDetail(fish: fish)
                                    .environmentObject(self.tankData)
                                    .environmentObject(self.noteCenter)
                            ){
                                FishRow(fishProfile: fish)
                        }
                        
                        
                        
                    }.padding(.top, 6)
                    
                }
                
                
                NavigationLink(destination: AddFishView()
                .environmentObject(self.tankData)
                ) {
                    Text("+ Add New fish")
                        .font(.footnote)
                        .fontWeight(.light)
                }.padding(.top)
                
                Divider()

                NavigationLink(destination: RemindersView()
                 .environmentObject(self.noteCenter)
                ) {
                    Text("Reminders")
                    .fontWeight(.semibold)
                }
                
                NavigationLink(destination: SettingsView(resetModal: $resetModalDisplayed)
                    .environmentObject(self.tankData)
                ) {
                    Text("Settings")
                    .fontWeight(.semibold)
                }
                .padding(.top)

                
            }
            .navigationBarTitle(Text(" \(self.tankData.userName)'s Tank"))
        
            .sheet(isPresented: $resetModalDisplayed) {
                SetupView(onDismiss: {
                    self.resetModalDisplayed = false
                })
                    .environmentObject(self.tankData)
            }
            
    }
        

    }
}

struct TankHome_Previews: PreviewProvider {
    @State static var tank = TankProfile()
    static var previews: some View {
        TankHome()
         .environmentObject(TankProfile())
         .environmentObject(LocalNotificationManager())
    }
}



