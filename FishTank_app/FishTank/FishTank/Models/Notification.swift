//
//  Reminder.swift
//  FishTank
//
//  Created by Robert Cecil on 11/10/19.
//  Copyright © 2019 Robert Cecil. All rights reserved.
//

import Foundation
import SwiftUI
import EventKit
import UserNotifications


struct Notification {
    var id: String
    var title: String
    //var datetime: DateComponents
}

class LocalNotificationManager {
    var notifications = [Notification]()
    
    
    private func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in

            if granted == true && error == nil {
                self.scheduleNotifications()
            }
        }
    }
    
    func schedule()
    {
        UNUserNotificationCenter.current().getNotificationSettings { settings in

            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization()
            case .authorized, .provisional:
                self.scheduleNotifications()
            default:
                break // Do nothing
            }
        }
    }
    
    
    private func scheduleNotifications()
    {
        for notification in notifications
        {
            let content      = UNMutableNotificationContent()
            content.title    = notification.title
            content.sound    = .default

           // let trigger = UNCalendarNotificationTrigger(dateMatching: notification.datetime, repeats: false)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 20 , repeats: false)

            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in

                guard error == nil else { return }

                print("Notification scheduled! --- ID = \(notification.id)")
            }
        }
    }
    
    func addNotification(title: String) -> Void {
        notifications.append(Notification(id: UUID().uuidString, title: title))
    }
    
    

} //LocalNotificationManager


func listScheduledNotifications() {
    UNUserNotificationCenter.current().getPendingNotificationRequests { notifications in

        for notification in notifications {
            print(notification)
        }
    }
}


