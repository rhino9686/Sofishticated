//
//  RemindersView.swift
//  FishTank
//
//  Created by Robert Cecil on 10/21/19.
//  Copyright © 2019 Robert Cecil. All rights reserved.
//

import SwiftUI

struct RemindersView: View {
    var body: some View {
        List {
            Text("Hi")
                .font(.title)
            Spacer()
        }
    .navigationBarTitle("Reminders")
            
    }
}

struct RemindersView_Previews: PreviewProvider {
    static var previews: some View {
        RemindersView()
    }
}
