//
//  ReminderDetailView.swift
//  FishTank
//
//  Created by Robert Cecil on 11/25/19.
//  Copyright © 2019 Robert Cecil. All rights reserved.
//

import SwiftUI

struct ReminderDetailView: View {
    @EnvironmentObject var noteCenter: LocalNotificationManager
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var reminder: Notification
    var fish: FishProfile?
    
    var body: some View {
        VStack {
            Text(reminder.title)
                .font(.largeTitle)
            
           Spacer()
            
           Button(action:{ self.removeNote()
                            
            }) {
                    Text("Delete Reminder")

            }.padding()
            
        }
    }
    
    func removeNote() {
        self.noteCenter.removeNotification(id_in: reminder.id)
        self.presentationMode.wrappedValue.dismiss()
        return
    }
    
}

struct ReminderDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ReminderDetailView(reminder:
            Notification(id: "37636", title: "Clean Tank", fishID: nil, repeats: false),
                           fish: nil)
        .environmentObject(LocalNotificationManager())
    }
}
