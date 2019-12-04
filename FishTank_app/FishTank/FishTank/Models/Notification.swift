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
import Combine
import UserNotifications


struct Notification: Hashable {
    var id: String
    var title: String
    var fishID: Int?
    var repeats: Bool
    var datetime: DateComponents?
}

class LocalNotificationManager: ObservableObject {
    
    @Published var notifications: [Notification]
    
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
        for notification in notifications {
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
        self.notifications.append(Notification(id: UUID().uuidString, title: title, repeats: false))
    }
    
    func addNotification(note: Notification) -> Void {
        self.notifications.append(note)
    }
    
    func clearNotifications() {
        self.notifications.removeAll(keepingCapacity: true)
    }
    
    func removeNotification(id_in: String) {
        
        if self.notifications.isEmpty {
            return
        }
        
        var index = -1
        
        for i in 0...self.notifications.count - 1 {
            if (self.notifications[i].id == id_in) {
                index = i
            }
        }
        if ( index < 0) {
            return
        }
        self.notifications.remove(at: index)
        
    }
    
    
    init() {
        self.notifications = [Notification]()
    }

} //LocalNotificationManager


func listScheduledNotifications() {
    UNUserNotificationCenter.current().getPendingNotificationRequests { notifications in

        for notification in notifications {
            print(notification)
        }
    }
}


