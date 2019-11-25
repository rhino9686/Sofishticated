//
//  ReminderDetailView.swift
//  FishTank
//
//  Created by Robert Cecil on 11/25/19.
//  Copyright © 2019 Robert Cecil. All rights reserved.
//

import SwiftUI

struct ReminderDetailView: View {
    var reminder: Notification
    var fish: FishProfile?
    
    var body: some View {
        Text("Hello, World!")
    }
}

struct ReminderDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ReminderDetailView(reminder:
            Notification(id: "fefefef", title: "Clean Tank", fishID: nil, repeats: false),
                           fish: nil)
    }
}
