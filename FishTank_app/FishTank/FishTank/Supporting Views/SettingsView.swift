//
//  SettingsView.swift
//  FishTank
//
//  Created by Robert Cecil on 11/3/19.
//  Copyright © 2019 Robert Cecil. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        
            List {
                
                NavigationLink(destination: TestConnectionView()) {
                     Text("Test Wifi Connection")
                     .fontWeight(.semibold)
                 }
                Spacer()
                
                
            }
            .navigationBarTitle(Text("Settings"))
       

    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
