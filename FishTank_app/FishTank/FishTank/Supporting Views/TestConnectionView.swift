//
//  TestConnectionView.swift
//  FishTank
//
//  Created by Robert Cecil on 11/4/19.
//  Copyright © 2019 Robert Cecil. All rights reserved.
//

import SwiftUI

let piServerAdress = "192.168.1.166"

let laptopServerAddress = "192.168.1.162"

let wifiServerAddress = "192.168.1.107"


struct TestConnectionView: View {
    @State var testString = "not yeeted "
    let myMessenger = Messenger(ipAddress: laptopServerAddress)
    
    func updateTest() {
        testString = "yeet"
        
        let string = myMessenger.requestRando()
        testString = string
    }
    
    
    var body: some View {
        VStack {
            Text(testString)
            
            Button(action: { self.updateTest() }) {
                           Text("Get random value")
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
        .padding()
            
        }
    }
}

struct TestConnectionView_Previews: PreviewProvider {
    static var previews: some View {
        TestConnectionView()
    }
}
