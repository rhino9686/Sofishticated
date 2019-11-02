//
//  AddFishView.swift
//  FishTank
//
//  Created by Robert Cecil on 10/21/19.
//  Copyright © 2019 Robert Cecil. All rights reserved.
//

import SwiftUI

struct AddFishView: View {
    
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Your Fish's Name")) {
                    TextField("Enter your name", text: $name)
                }
                
                Section(header: Text("Type of Fish")) {
                    TextField("Enter your fish's breed", text: $name)
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
}

struct AddFishView_Previews: PreviewProvider {
    static var previews: some View {
        AddFishView()
    }
}
