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
        
        List{
            
            ForEach(self.tankData.notifyMan.notifications, id: \.id) { notification in
                
              //  if (self.fish == nil || self.fish.id == notification.fishID) {
                    Text(notification.title)
             //   }
                

            }.padding(.top, 6)
            
            
            Button(action: addNotifications) {
                    Text("Add Reminder")

            }.padding()
        }
    .navigationBarTitle("Reminders")
            
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

struct RemindersView_Previews: PreviewProvider {
    static var previews: some View {
        RemindersView()
        .environmentObject(TankProfile())
    }
}
