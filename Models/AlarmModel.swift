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
    enum weekdays { case Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday }

    var date: Date = Date()
    var enabled: Bool = false
    var weekDay: weekdays
    var label: String = "Alarm"
    var onSnooze: Bool = false
    
    init(date:Date, enabled:Bool, weekDay: weekdays, label:String)
    {
        self.date = date
        self.weekDay = weekDay
        self.enabled = enabled
        self.label = label
        self.onSnooze = false
        super.init()
    }
    
    init(date:Date, enabled:Bool, weekDay: weekdays, label:String, onSnooze: Bool)
    {
        self.date = date
        self.weekDay = weekDay
        self.enabled = enabled
        self.label = label
        self.onSnooze = onSnooze
        super.init()
    }
}
extension AlarmModel
{
    var formattedTime: String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: self.date)
    }
    
    
}

