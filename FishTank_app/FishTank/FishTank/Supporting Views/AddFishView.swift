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
