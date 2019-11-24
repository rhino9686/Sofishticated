//
//  ResetTankView.swift
//  FishTank
//
//  Created by Robert Cecil on 11/23/19.
//  Copyright © 2019 Robert Cecil. All rights reserved.
//

import SwiftUI

struct ResetTankView: View {
    
    @EnvironmentObject var tankData: TankProfile
    
    //These are the network name for when we 
    @State var ssid = ""
    @State var password = ""
    
    let resetMessenger: Messenger
    
    var body: some View {
        Text("Time to Reset Tank!")
    }
    
    init(ipAddress_in: String) {
        self.resetMessenger = Messenger(ipAddress: ipAddress_in)
    }
    
}

struct ResetTankView_Previews: PreviewProvider {
    static var previews: some View {
        ResetTankView(ipAddress_in: "0.0.0.0")
        .environmentObject(TankProfile())
    }
}

