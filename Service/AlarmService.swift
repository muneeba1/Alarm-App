//
//  AlarmService.swift
//  Alarm App
//
//  Created by Muneeba Khatoon on 7/5/17.
//  Copyright © 2017 Muneeba Khatoon. All rights reserved.
//

import Foundation
import UIKit

class AlarmService: NSObject {

var alarms = AlarmModel.alarms

func setupNotificationSettings() {
    var snoozeEnabled: Bool = false
    if let n = UIApplication.shared.scheduledLocalNotifications {
        if let result = minFireDateWithIndex(notifications: n) {
            let i = result.1
            snoozeEnabled = alarms[i].snoozeEnabled
        }
    }
    // Specify the notification types.
    let notificationTypes: UIUserNotificationType = [UIUserNotificationType.alert, UIUserNotificationType.sound]
    
    // Specify the notification actions.
    let stopAction = UIMutableUserNotificationAction()
    stopAction.identifier = "stop"
    stopAction.title = "OK"
    stopAction.activationMode = UIUserNotificationActivationMode.background
    stopAction.isDestructive = false
    stopAction.isAuthenticationRequired = false
    
    let snoozeAction = UIMutableUserNotificationAction()
    snoozeAction.identifier = "snooze"
    snoozeAction.title = "Snooze"
    snoozeAction.activationMode = UIUserNotificationActivationMode.background
    snoozeAction.isDestructive = false
    snoozeAction.isAuthenticationRequired = false
    
    let actionsArray = snoozeEnabled ? [UIUserNotificationAction](arrayLiteral: snoozeAction, stopAction) : [UIUserNotificationAction](arrayLiteral: stopAction)
    let actionsArrayMinimal = snoozeEnabled ? [UIUserNotificationAction](arrayLiteral: snoozeAction, stopAction) : [UIUserNotificationAction](arrayLiteral: stopAction)
    // Specify the category related to the above actions.
    let alarmCategory = UIMutableUserNotificationCategory()
    alarmCategory.identifier = "myAlarmCategory"
    alarmCategory.setActions(actionsArray, for: .default)
    alarmCategory.setActions(actionsArrayMinimal, for: .minimal)
    
    
    let categoriesForSettings = Set(arrayLiteral: alarmCategory)
    // Register the notification settings.
    let newNotificationSettings = UIUserNotificationSettings(types: notificationTypes, categories: categoriesForSettings)
    UIApplication.shared.registerUserNotificationSettings(newNotificationSettings)
    }
    
    
    private func minFireDateWithIndex(notifications: [UILocalNotification]) -> (Date, Int)? {
        if notifications.isEmpty {
            return nil
        }
        var minIndex = -1
        var minDate: Date = notifications.first!.fireDate!
        for n in notifications {
            let index = n.userInfo!["index"] as! Int
            if(n.fireDate! <= minDate) {
                minDate = n.fireDate!
                minIndex = index
            }
        }
        return (minDate, minIndex)
    }

    
}
