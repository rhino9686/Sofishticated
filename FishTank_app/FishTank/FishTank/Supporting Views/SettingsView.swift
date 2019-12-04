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
                
                Button(action: addDenizens) {
                    Text("Add 473 Fish")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.blue)

                }
                
                
            }
            .navigationBarTitle(Text("Settings"))
        
    }
    
    func resetTank() {
        self.resetModal = true
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func addDenizens() {
        
        
        // Tetra #1
        var terry = FishProfile(name_in: "Terry", id_in: 74, img_in: "tetra")
        terry.breedData = self.tankData.breeds[2]
        tankData.addFish(fishEntry: terry)
        
        
        //Sea snail
        var kingKong = FishProfile(name_in: "King Kong", id_in: 73, img_in: "appleSnail")
        kingKong.breedData = self.tankData.breeds[9]
        tankData.addFish(fishEntry: kingKong)
        
        
        // Tetra #2
        var bubbles = FishProfile(name_in: "Bubbles", id_in: 75, img_in: "tetra")
        bubbles.breedData = self.tankData.breeds[2]
        tankData.addFish(fishEntry: bubbles)
        
        
        //Danio
        var daniel = FishProfile(name_in: "Daniel", id_in: 76, img_in: "danios")
        daniel.breedData = self.tankData.breeds[7]
        tankData.addFish(fishEntry: daniel)
        
        // Tetra #3
        var finn = FishProfile(name_in: "Finn", id_in: 75, img_in: "tetra")
        finn.breedData = self.tankData.breeds[2]
        tankData.addFish(fishEntry: finn)
        
        
        // Tetra #4
        var chet = FishProfile(name_in: "Chet", id_in: 75, img_in: "tetra")
        chet.breedData = self.tankData.breeds[2]
        tankData.addFish(fishEntry: chet)
        
        
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
