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
    
    @State var i = 1
    @State var modalDisplayed: Bool =  false
    
    @EnvironmentObject var noteCenter: LocalNotificationManager
    
    var body: some View {
        
        Group {
            if fish != nil {
               PersonalRemindersView(noteCenter: noteCenter)
                .navigationBarTitle("Reminders for \(fish!.name)")
            }
            else {
                   List{
                       ForEach(self.noteCenter.notifications, id: \.self) { notification in
                           
                           NavigationLink(destination: ReminderDetailView(reminder: notification)
                               .environmentObject(self.noteCenter)
                           ) {
                               Text(notification.title)
                               .fontWeight(.semibold)
                           }

                       }.padding(.top, 6)
                       
//                       NavigationLink(destination: AddReminderView(onDismiss: incr)
//                           .environmentObject(self.noteCenter)
//                       ) {

//                       }
//                       .padding(.top)
                    
                        Button(action: {
                            self.modalDisplayed = true
                        }){
                            Text("+ Add Reminder")
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .foregroundColor(Color.blue)
                        }
                
                   }
                .navigationBarTitle("Reminders")

            }
            
        }
            .sheet(isPresented: $modalDisplayed) {
                AddReminderView(onDismiss: {
                    self.modalDisplayed = false
                })
                .environmentObject(self.noteCenter)
            }
            
    }
    
    func incr() {
        i = i + 1
    }
    

    func addNotifications() {
        
        
    //    let gh = Notification(id: "reminder-1", title: "Remember the milk!" )
        
//        manager.notifications = [
//            Notification(id: "reminder-1", title: "Remember the milk!", datetime: DateComponents(calendar: Calendar.current, year: 2019, month: 4, day: 22, hour: 17, minute: 0)),
//            Notification(id: "reminder-2", title: "Ask Bob from accounting", datetime: DateComponents(calendar: Calendar.current, year: 2019, month: 4, day: 22, hour: 17, minute: 1)),
//            Notification(id: "reminder-3", title: "Send postcard to mom", datetime: DateComponents(calendar: Calendar.current, year: 2019, month: 4, day: 22, hour: 17, minute: 2))
//        ]
        self.noteCenter.addNotification(title: "Feed fish!")
        self.noteCenter.schedule()
        
    }
    
    
}


struct PersonalRemindersView: View {
    @State var noteCenter: LocalNotificationManager
    
    @State var i = 1
    
    var body: some View {
         List{
         ForEach(self.noteCenter.notifications, id: \.self) { notification in
             
             NavigationLink(destination: ReminderDetailView(reminder: notification)
                 .environmentObject(self.noteCenter)
             ) {
                 Text(notification.title)
                 .fontWeight(.semibold)
             }

         }.padding(.top, 6)
         
         NavigationLink(destination: AddReminderView(onDismiss: incr)
             .environmentObject(self.noteCenter)
         ) {
             Text("Add Reminder")
             .fontWeight(.semibold)
         }
         .padding(.top)
         
         
     }
        
    }
    
    func incr() {
        self.i = self.i + 1
    }
    
    
}


struct RemindersView_Previews: PreviewProvider {
    
   
    
    static var previews: some View {
        RemindersView()
        .environmentObject(LocalNotificationManager())
    }
}
