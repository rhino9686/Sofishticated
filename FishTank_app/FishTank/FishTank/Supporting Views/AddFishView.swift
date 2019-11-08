//
//  AddFishView.swift
//  FishTank
//
//  Created by Robert Cecil on 10/21/19.
//  Copyright © 2019 Robert Cecil. All rights reserved.
//

import SwiftUI

struct AddFishView: View {
    
    @EnvironmentObject private var tankData: TankProfile
    
    @State private var name: String = ""
    @State private var type: FishBreedData = FishBreedData("gold", 3.0, 4.0, 3.0, 5.0)
    @State private var password: String = ""
    
    let listOfBreeds = ["Goldfish", "Betta", "Sea snail", "other"]
    
    
    var body: some View {
            Form {
                Section(header: Text("Your Fish's Name")) {
                    TextField("Enter name", text: $name)
                }
                
                Section(header: Text("Type of Fish")) {
                    Picker(selection: $type, label: Text("Types"), content: {
                        ForEach(tankData.breeds, id: \.self){ breed in
                            Text(breed.breedName)
                        }
                        
                    })
                }

                Section {
                    Button(action: {
                                print("register account")
                            }) {
                                Text("Add to Tank")
                            }
                }
            }
            .navigationBarTitle(Text("Add New Fish"))
        
    }
}

struct AddFishView_Previews: PreviewProvider {
    static var previews: some View {
        AddFishView()
         .environmentObject(TankProfile())
    }
}
