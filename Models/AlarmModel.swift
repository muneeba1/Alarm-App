//
//  AlarmModel.swift
//  Alarm App
//
//  Created by Muneeba Khatoon on 7/5/17.
//  Copyright © 2017 Muneeba Khatoon. All rights reserved.
//

import Foundation
import MediaPlayer

class AlarmModel: NSObject
{
    let ud: UserDefaults = UserDefaults.standard
    enum Weekdays : Int{ case Monday = 0, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday }

    var date: Date = Date()
    var enabled: Bool = false
    var weekDay: Weekdays
    var label: String = "Alarm"
    var onSnooze: Bool = false
    
    init(date:Date, enabled:Bool, weekDay: Weekdays, label:String)
    {
        self.date = date
        self.weekDay = weekDay
        self.enabled = enabled
        self.label = label
        self.onSnooze = false
        super.init()
    }
    
    init(date:Date, enabled:Bool, weekDay: Weekdays, label:String, onSnooze: Bool)
    {
        self.date = date
        self.weekDay = weekDay
        self.enabled = enabled
        self.label = label
        self.onSnooze = onSnooze
        super.init()
    }
    
    func save()
    {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("hh:mm a")
        ud.set(dateFormatter.string(from: date), forKey:"\(weekDay)alarmTime")
        ud.set(enabled, forKey:"\(weekDay)alarmEnabled")
        ud.set(label, forKey: "\(weekDay)alarmLabel")
        ud.synchronize()
    }
    
    class func getAlarms() -> [AlarmModel]
    {
        let ud: UserDefaults = UserDefaults.standard
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("hh:mm a")
        var alarms: [AlarmModel] = []
        for i in 0...6
        {
            let dateString = ud.object(forKey: "\(i)alarmTime") as? String ?? "07:00 AM"
            let date = dateFormatter.date(from: dateString) ?? Date()
            let enabled = ud.object(forKey: "\(i)alarmEnabled") as? Bool ?? false
            let label = ud.object(forKey: "\(i)alarmLabel") as? String ?? "Alarm"
            let alarm: AlarmModel = AlarmModel(date: date, enabled: enabled, weekDay: Weekdays(rawValue: i)!, label: label)
            alarms.append(alarm)
        }
        return alarms
    }
}
extension AlarmModel
{
    
    
}

