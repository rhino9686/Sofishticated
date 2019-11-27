//
//  AddReminderView.swift
//  FishTank
//
//  Created by Robert Cecil on 11/27/19.
//  Copyright © 2019 Robert Cecil. All rights reserved.
//

import SwiftUI

struct AddReminderView: View {
    
    @EnvironmentObject var tankData: TankProfile
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var title: String = ""
    @State private var type: String = "Feed"
    @State private var errorMsg: String = ""
    
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

                Section(header: Text(errorMsg)
                    .foregroundColor(Color.red)) {
                    Button(action: {
                        
                        if self.checkValidity() {

                            print("created new reminder")
                            self.addReminder()
                            //This goes back to the home view
                            self.presentationMode.wrappedValue.dismiss()
                            
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
            self.tankData.notifyMan.addNotification(title: self.title)
            self.tankData.notifyMan.schedule()
            
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
    static var previews: some View {
        AddReminderView()
    }
}
