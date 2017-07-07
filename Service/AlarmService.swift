//
//  AlarmService.swift
//  Alarm App
//
//  Created by Muneeba Khatoon on 7/5/17.
//  Copyright © 2017 Muneeba Khatoon. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class AlarmService: NSObject
{
    let notificationCenter = UNUserNotificationCenter.current()
    enum weekdays { case Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday }
    
    
    
    
    func setupNotificationsForAlarm (alarm: AlarmModel)
    {
        let alarmDate: Date = alarm.date
        
        let content = UNMutableNotificationContent()
        content.title = alarm.label
        content.body = "testing"
        content.sound = UNNotificationSound.default()
        content.categoryIdentifier = "alarm"
        
        let triggerDate = Calendar.current.dateComponents([.weekday,.hour,.minute,.second,], from: alarmDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
        let identifier = "alarm\(alarm.weekDay)"
        print(identifier)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            if let error = error
            {
                print("Error creating notification for alarm \(error.localizedDescription)")
            }
            else
            {
                //alarm created successfully
            }
        }
        
    }
    
    func setupAlarmNotificationCategory()
    {
        var actions: [UNNotificationAction] = []
        var intentIdentifiers: [String] = []
        let dismissAction = UNNotificationAction(identifier: "dismiss", title: "I'm Awakw", options: UNNotificationActionOptions.destructive)
        actions.append(dismissAction)
        intentIdentifiers.append(dismissAction.identifier)
        let alarmCategory: UNNotificationCategory = UNNotificationCategory(identifier: "alarm", actions: actions, intentIdentifiers: intentIdentifiers, options: [])
        notificationCenter.setNotificationCategories([alarmCategory])
    }
    
    func updateAlarmAndNotificationsTo(UpdatedAlarm alarm: AlarmModel)
    {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: ["alarm\(alarm.weekDay)"])
        setupNotificationsForAlarm(alarm: alarm)
    }
    
    func removeAllAlarms()
    {
        notificationCenter.removeAllPendingNotificationRequests()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

//    func setupNotificationSettings()
//    {
//        var snoozeEnabled: Bool = false
//        if let n = UIApplication.shared.scheduledLocalNotifications {
//            if let result = minFireDateWithIndex(notifications: n) {
//                let i = result.1
//                snoozeEnabled = alarms[i].snoozeEnabled
//            }
//        }
//        // Specify the notification types.
//        let notificationTypes: UIUserNotificationType = [UIUserNotificationType.alert, UIUserNotificationType.sound]
//        
//        // Specify the notification actions.
//        let stopAction = UIMutableUserNotificationAction()
//        stopAction.identifier = "stop"
//        stopAction.title = "OK"
//        stopAction.activationMode = UIUserNotificationActivationMode.background
//        stopAction.isDestructive = false
//        stopAction.isAuthenticationRequired = false
//        
//        let snoozeAction = UIMutableUserNotificationAction()
//        snoozeAction.identifier = "snooze"
//        snoozeAction.title = "Snooze"
//        snoozeAction.activationMode = UIUserNotificationActivationMode.background
//        snoozeAction.isDestructive = false
//        snoozeAction.isAuthenticationRequired = false
//        
//        let actionsArray = snoozeEnabled ? [UIUserNotificationAction](arrayLiteral: snoozeAction, stopAction) : [UIUserNotificationAction](arrayLiteral: stopAction)
//        let actionsArrayMinimal = snoozeEnabled ? [UIUserNotificationAction](arrayLiteral: snoozeAction, stopAction) : [UIUserNotificationAction](arrayLiteral: stopAction)
//        // Specify the category related to the above actions.
//        let alarmCategory = UIMutableUserNotificationCategory()
//        alarmCategory.identifier = "myAlarmCategory"
//        alarmCategory.setActions(actionsArray, for: .default)
//        alarmCategory.setActions(actionsArrayMinimal, for: .minimal)
//        
//        
//        let categoriesForSettings = Set(arrayLiteral: alarmCategory)
//        // Register the notification settings.
//        let newNotificationSettings = UIUserNotificationSettings(types: notificationTypes, categories: categoriesForSettings)
//        UIApplication.shared.registerUserNotificationSettings(newNotificationSettings)
//    }
//    
//    
//    private func minFireDateWithIndex(notifications: [UILocalNotification]) -> (Date, Int)? {
//        if notifications.isEmpty {
//            return nil
//        }
//        var minIndex = -1
//        var minDate: Date = notifications.first!.fireDate!
//        for n in notifications {
//            let index = n.userInfo!["index"] as! Int
//            if(n.fireDate! <= minDate) {
//                minDate = n.fireDate!
//                minIndex = index
//            }
//        }
//        return (minDate, minIndex)
//    }

    
}

extension AlarmService: UNUserNotificationCenterDelegate
{
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
    {
        print("RESPONSE \(response)")
    }
}


