//
//  AddFishView.swift
//  FishTank
//
//  Created by Robert Cecil on 10/21/19.
//  Copyright © 2019 Robert Cecil. All rights reserved.
//

import SwiftUI

struct AddFishView: View {
    
    @EnvironmentObject var tankData: TankProfile
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var name: String = ""
    @State private var type: FishBreedData = FishBreedData("no_breed", 3.0, 4.0, 3.0, 5.0)
    @State private var errorMsg: String = ""
    
  //  let listOfBreeds = ["Goldfish", "Betta", "Sea snail", "other"]
    @State private var showingAlert = false
    
    let incompatibleSpeciesMsg = "This fish is incompatible with other fish in your tank, due to a mismatch in living parameters!"
    
    var body: some View {
            Form {
                Section(header: Text("Your Fish's Name")) {
                    TextField("Enter name", text: $name)
                }
                
                Section(header: Text("Type of Fish")) {
                    
                   VStack {
                        Picker(selection: $type, label: Text("Types")) {
                            ForEach(tankData.breeds, id: \.self){ breed in
                                Text(breed.breedName)
                            }
                        }
                    }
                }

                Section(header: Text(errorMsg)
                    .foregroundColor(Color.red)) {
                    Button(action: {
                        
                        if self.checkValidity() {
                            print("registered new fish")
                            self.addFish()
                            //This goes back to the home view
                            self.presentationMode.wrappedValue.dismiss()
                        }

                              
                    }) {
                        Text("Add to Tank")
                        }
                }
                
            }
            .navigationBarTitle(Text("Add New Fish"))
            .alert(isPresented: $showingAlert) {
                  Alert(title: Text("Warning!"),
                        message: Text(self.incompatibleSpeciesMsg),
                        dismissButton: .default(Text("Oops")))
              }
        
    }
    
    func checkCompatibility() {
        var compatible = true
        let res = self.tankData.currentResidents
        
        res.forEach {
            let fish = $0
            
            if type.minPh > fish.breedData!.maxPh {
                compatible = false
                return
            }
            if type.maxPh < fish.breedData!.minPh {
                compatible = false
                return
            }
            if type.minTemp > fish.breedData!.maxTemp {
                compatible = false
                return
            }
            if type.maxTemp < fish.breedData!.minTemp {
                compatible = false
                return
            }
            
        }
        if !compatible {
            showingAlert = true
        }
 
    }
    
    
    func checkValidity() -> Bool{
        if self.name == "" {
            self.errorMsg = "Please enter a valid name for your fish"
            return false
        }
        
        if self.type.breedName == "no_breed" {
            self.errorMsg = "Please select a type of fish"
            return false
        }
        self.checkCompatibility()
        return true
    }
    
    
    func addFish() {
        
        let newID = self.tankData.getNextID()
        var myFish = FishProfile(name_in: self.name, id_in: newID, img_in: type.imageName)
        myFish.breedData = self.type
        
        self.tankData.addFish(fishEntry: myFish)
        
    }
    
    
}

struct ContentView: View {
   var colors = ["Red", "Green", "Blue", "Tartan"]
   @State private var selectedColor = 0

   var body: some View {
      VStack {
         Picker(selection: $selectedColor, label: Text("Please choose a color")) {
            ForEach(0 ..< colors.count) {
               Text(self.colors[$0])
            }
         }
         Text("You selected: \(colors[selectedColor])")
      }
   }
}



struct AddFishView_Previews: PreviewProvider {
    @State static var myTank = TankProfile()
    static var previews: some View {
        AddFishView(/**tankData: $myTank*/)
        .environmentObject(self.myTank)
    }
}
