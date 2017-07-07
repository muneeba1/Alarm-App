//
//  EventsModel.swift
//  Alarm App
//
//  Created by Muneeba Khatoon on 7/7/17.
//  Copyright © 2017 Muneeba Khatoon. All rights reserved.
//

import Foundation
import UIKit
import GoogleAPIClientForREST


class EventsModel: NSObject{
    
    var startDate: Date
    var eventSummary: String
    var endDate: Date
    var location: String

    init(startDate: Date, eventSummary: String, endDate: Date, location: String)
    {
        self.startDate = startDate
        self.eventSummary = eventSummary
        self.endDate = endDate
        self.location = location
    }
    
    
    
    func displayEvents(){
        

    }
}
