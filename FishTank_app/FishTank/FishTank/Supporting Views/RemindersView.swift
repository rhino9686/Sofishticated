//
//  RemindersView.swift
//  FishTank
//
//  Created by Robert Cecil on 10/21/19.
//  Copyright © 2019 Robert Cecil. All rights reserved.
//

import SwiftUI

struct RemindersView: View {
    var fish: FishProfile?
    @EnvironmentObject var tankData: TankProfile
    
    var body: some View {
        
        Group {
            if fish != nil {
               PersonalRemindersView()
                .navigationBarTitle("Reminders for \(fish!.name)")
            }
            else {
                   List{
                       ForEach(self.tankData.notifyMan.notifications, id: \.self) { notification in
                           
                           NavigationLink(destination: ReminderDetailView(reminder: notification)
                               .environmentObject(self.tankData)
                           ) {
                               Text(notification.title)
                               .fontWeight(.semibold)
                           }

                       }.padding(.top, 6)
                       
                       NavigationLink(destination: AddReminderView()
                           .environmentObject(self.tankData)
                       ) {
                           Text("Add Reminder")
                           .fontWeight(.semibold)
                       }
                       .padding(.top)
                       
                       
                       
                       Button(action: addNotifications) {
                             Text("Dummy Test")

                       }.padding()
                   }
                .navigationBarTitle("Reminders")
            }
            
        }
        
        
    }
    

    func addNotifications() {
        
        
    //    let gh = Notification(id: "reminder-1", title: "Remember the milk!" )
        
//        manager.notifications = [
//            Notification(id: "reminder-1", title: "Remember the milk!", datetime: DateComponents(calendar: Calendar.current, year: 2019, month: 4, day: 22, hour: 17, minute: 0)),
//            Notification(id: "reminder-2", title: "Ask Bob from accounting", datetime: DateComponents(calendar: Calendar.current, year: 2019, month: 4, day: 22, hour: 17, minute: 1)),
//            Notification(id: "reminder-3", title: "Send postcard to mom", datetime: DateComponents(calendar: Calendar.current, year: 2019, month: 4, day: 22, hour: 17, minute: 2))
//        ]
        self.tankData.notifyMan.addNotification(title: "Feed fish!")
        self.tankData.notifyMan.schedule()
        
    }
    
    
}


struct PersonalRemindersView: View {
    
    var body: some View {
        Text("Hello")
        
    }
    
    
}


struct RemindersView_Previews: PreviewProvider {
    static var previews: some View {
        RemindersView()
        .environmentObject(TankProfile())
    }
}
