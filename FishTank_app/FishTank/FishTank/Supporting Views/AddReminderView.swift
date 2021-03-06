//
//  AddReminderView.swift
//  FishTank
//
//  Created by Robert Cecil on 11/27/19.
//  Copyright © 2019 Robert Cecil. All rights reserved.
//

import SwiftUI

struct AddReminderView: View {
    
    @EnvironmentObject var noteCenter: LocalNotificationManager
    
    var onDismiss: () -> ()
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var title: String = ""
    @State private var type: String = "Feed"
    @State private var errorMsg: String = ""
    @State private var repeats: Bool = false
    @State private var date: Date = Date()
    
    let reminderTypes = ["Feed", "Cleaning", "Checking Tank Chemicals"]

    @State private var showingAlert = false
    
    var body: some View {
            Form {
                Section(header: Text("Reminder title")) {
                    TextField("Enter text", text: $title)
                }
                
                Section(header: Text("Type of Reminder")) {
                    
                   VStack {
                        Picker(selection: $type, label: Text("")) {
                            ForEach(reminderTypes, id: \.self){ type in
                                Text(type)
                            }
                    }.pickerStyle(WheelPickerStyle())
                    }
                }

                Section(header: Text("Date")) {
                        
                    DatePicker("What date?", selection: $date)
                }
                    
                Section(header: Text("")) {
                    
                    Toggle("Repeats Daily?", isOn: $repeats)
                }
                
            
                Section(header: Text(errorMsg)
                    .foregroundColor(Color.red)) {
                    Button(action: {
                        
                        if self.checkValidity() {

                            print("created new reminder")
                            self.addReminder()
                            //This goes back to the home view
                          //  self.presentationMode.wrappedValue.dismiss()
                            self.onDismiss()
                        }

                    }) {
                        Text("Add Reminder")
                        }
                }
                
            }
            .navigationBarTitle(Text("Add New Reminder"))

        
    }
    
 
    

        func addReminder() {
            
            
        //    let gh = Notification(id: "reminder-1", title: "Remember the milk!" )
            
    //        manager.notifications = [
    //            Notification(id: "reminder-1", title: "Remember the milk!",
    //               datetime: DateComponents(calendar: Calendar.current, year: 2019, month: 4, day: 22, hour: 17, minute: 0)),
    //            Notification(id: "reminder-2", title: "Ask Bob from accounting",
    //            datetime: DateComponents(calendar: Calendar.current, year: 2019, month: 4, day: 22, hour: 17, minute: 1)),
    //            Notification(id: "reminder-3", title: "Send postcard to mom", datetime: DateComponents(calendar: Calendar.current, year: 2019, month: 4, day: 22, hour: 17, minute: 2))
    //        ]
            noteCenter.addNotification(title: self.title)
            noteCenter.schedule()
            
        }
    
    
    func checkValidity() -> Bool{
        if self.title == "" {
            self.errorMsg = "Please enter a valid name for your reminder"
            return false
        }
        
        return true
    }
    
    
}

struct AddReminderView_Previews: PreviewProvider {
    
    static var i = 1
    
    static var previews: some View {
        AddReminderView(onDismiss: {
            self.i += 1
        })
        .environmentObject(LocalNotificationManager())
    }
}
