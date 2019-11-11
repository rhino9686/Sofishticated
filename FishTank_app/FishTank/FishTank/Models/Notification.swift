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

//Our reminder class. Might just use EKEvent if it has all necessary stuff
class Reminder {
    var reminderTitle: String = ""
}


struct Notification {
    var id:String
    var title:String
    var datetime:DateComponents
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

            let trigger = UNCalendarNotificationTrigger(dateMatching: notification.datetime, repeats: false)

            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in

                guard error == nil else { return }

                print("Notification scheduled! --- ID = \(notification.id)")
            }
        }
    }

} //LocalNotificationManager


func listScheduledNotifications() {
    UNUserNotificationCenter.current().getPendingNotificationRequests { notifications in

        for notification in notifications {
            print(notification)
        }
    }
}


