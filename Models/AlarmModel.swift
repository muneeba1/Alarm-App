//
//  AlarmModel.swift
//  Alarm App
//
//  Created by Muneeba Khatoon on 7/5/17.
//  Copyright © 2017 Muneeba Khatoon. All rights reserved.
//

import Foundation
import MediaPlayer

class AlarmModel: NSObject {
    
    private static var _alarms: [AlarmModel]? {
        didSet{
            //sync userdefaults
        }
    }
    
    static var alarms: [AlarmModel]
    {
        guard let currentAlarms = _alarms else { fatalError("Error: Alarm does not exist")}
        return currentAlarms
    }
    
    var date: Date = Date()
    var enabled: Bool = false
    var snoozeEnabled: Bool = false
    var repeatWeekdays: [Int] = []
    var uuid: String = ""
    var mediaID: String = ""
    var mediaLabel: String = "bell"
    var label: String = "Alarm"
    var onSnooze: Bool = false
    
    init(date:Date, enabled:Bool, snoozeEnabled:Bool, repeatWeekdays:[Int], uuid:String, mediaID:String, mediaLabel:String, label:String, onSnooze: Bool){
        self.date = date
        self.enabled = enabled
        self.snoozeEnabled = snoozeEnabled
        self.repeatWeekdays = repeatWeekdays
        self.uuid = uuid
        self.mediaID = mediaID
        self.mediaLabel = mediaLabel
        self.label = label
        self.onSnooze = onSnooze
    }
    
    
/*
    init(_ dict: PropertyReflectable.RepresentationType){
        date = dict["date"] as! Date
        enabled = dict["enabled"] as! Bool
        snoozeEnabled = dict["snoozeEnabled"] as! Bool
        repeatWeekdays = dict["repeatWeekdays"] as! [Int]
        uuid = dict["uuid"] as! String
        mediaID = dict["mediaID"] as! String
        mediaLabel = dict["mediaLabel"] as! String
        label = dict["label"] as! String
        onSnooze = dict["onSnooze"] as! Bool
    }
*/
}
