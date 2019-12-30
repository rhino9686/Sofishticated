//
//  ParamHistoryView.swift
//  FishTank
//
//  Created by Robert Cecil on 11/30/19.
//  Copyright © 2019 Robert Cecil. All rights reserved.
//

import SwiftUI
import SwiftUICharts

struct ParamHistoryView: View {
    var title: String
    var tankData: TankProfile
    var myData: [Double]
    var body: some View {
        VStack{
            LineView(data: myData, title: "")
            //Spacer()
        }
    .navigationBarTitle(title)
    }
    
    init(tankData: TankProfile,  param: String) {
        self.tankData = tankData
        self.title = param + " History"
        if param == "Temperature" {
            myData = self.tankData.tempHistory
        }
        else {
            myData = self.tankData.pHHistory
        }
    }
}

struct ParamHistoryView_Previews: PreviewProvider {
    static var tankData = TankProfile()
    static var previews: some View {
        ParamHistoryView(tankData: tankData, param: "Temperature" )
    }
}
