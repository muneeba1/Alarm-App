//
//  CreateEventViewController.swift
//  Alarm App
//
//  Created by Muneeba Khatoon on 8/8/17.
//  Copyright © 2017 Muneeba Khatoon. All rights reserved.
//

import Foundation
import UIKit

class CreateEventViewController: UIViewController
{
    
    @IBOutlet weak var endTimeTextField: UITextField!
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    
    var eventsArray: [EventsModel] = []
    var eventName: String = ""
    var startTime: String = ""
    var endTime: String = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        for event in eventsArray
        {
            print("start: \(event.startDate)")
            print("end: \(event.endDate)")
        }
        
        let datePicker = UIDatePicker()
        
        datePicker.datePickerMode = UIDatePickerMode.dateAndTime
        
        datePicker.addTarget(self, action: #selector(CreateEventViewController.datePickerValueChanged(sender:)), for: UIControlEvents.valueChanged)
        
        startTimeTextField.inputView = datePicker
        endTimeTextField.inputView = datePicker
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
        
        toolbar.barStyle = UIBarStyle.blackTranslucent
        
        toolbar.tintColor = UIColor.white
        
        let todayButton = UIBarButtonItem(title: "Today", style: UIBarButtonItemStyle.plain, target: self, action: #selector(CreateEventViewController.todayPressed(sender:)))
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(CreateEventViewController.donePressed(sender:)))
        
        let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width/3, height: 40))
        
        label.font = UIFont.systemFont(ofSize: 14)
        
        label.textColor = UIColor.yellow
        
        label.textAlignment = NSTextAlignment.center
        
        label.text = "Select a Date"
        
        let labelButton = UIBarButtonItem(customView: label)
        
        toolbar.setItems([todayButton, flexButton, labelButton, flexButton, doneButton], animated: true)
        
        startTimeTextField.inputAccessoryView = toolbar
        endTimeTextField.inputAccessoryView = toolbar
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let identifier = segue.identifier {
            if identifier == "cancel" {
                print("Cancel button tapped")
            } else if identifier == "save" {
                print("Save button tapped")
                
                eventName = titleTextField.text!
                startTime = startTimeTextField.text!
                endTime = endTimeTextField.text!
                
                for event in eventsArray
                {
                    let dateString = startTime
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "EEE, dd MMM yyyy hh:mm"
                    dateFormatter.locale = Locale.init(identifier: "en_GB")
                    
                    let dateObj = dateFormatter.date(from: dateString)
                    
                    dateFormatter.dateFormat = "MM-dd-yyyy"
                    print("Dateobj: \(dateFormatter.string(from: dateObj!))")
                    
                    event.startDate = dateObj!
                    //event.endDate = endTime
                    event.eventSummary = eventName
                    
                    print("startTime: \(event.startDate), endtime: \(event.endDate), eventName: \(event.eventSummary)")
                }
            }
        }
    }
    
    func todayPressed(sender: UIBarButtonItem)
    {
        let formatter = DateFormatter()
        
        formatter.dateStyle = DateFormatter.Style.medium
        
        formatter.timeStyle = DateFormatter.Style.short
        
        startTimeTextField.text = formatter.string(from: NSDate() as Date)
        
        startTimeTextField.resignFirstResponder()
        
        endTimeTextField.text = formatter.string(from: NSDate() as Date)
        
        endTimeTextField.resignFirstResponder()
    }
    
    func datePickerValueChanged(sender: UIDatePicker)
    {
        let formatter = DateFormatter()
        
        formatter.dateStyle = DateFormatter.Style.medium
        
        formatter.timeStyle = DateFormatter.Style.short
        
        startTimeTextField.text = formatter.string(from: sender.date)
        
        endTimeTextField.text = formatter.string(from: sender.date)
        
        startTime = startTimeTextField.text!
        endTime =  startTimeTextField.text!
        
        //startTime = formatter.timeStyle = DateFormatter.Style.short
    }
    
    func donePressed(sender: UIBarButtonItem)
    {
        startTimeTextField.resignFirstResponder()
        endTimeTextField.resignFirstResponder()
    }
    
    //    func createEvents ()
    //    {
    //        //        let ud = UserDefaults.standard
    //        //        let eventName: String = ud.object(forKey: "eventTitle") as! String
    //        //        let startTime: String = ud.object(forKey: "startTime") as! String
    //        //        let endTime: String = ud.object(forKey: "endTime") as! String
    //        //
    //        for event in eventsArray
    //        {
    //
    //            let dateString = startTime
    //            let dateFormatter = DateFormatter()
    //            dateFormatter.dateFormat = "EEE, dd MMM yyyy hh:mm:ss +zzzz"
    //            dateFormatter.locale = Locale.init(identifier: "en_GB")
    //            let dateObj = dateFormatter.date(from: dateString)
    //
    //           // eventName = titleTextField.text!
    //
    //            dateFormatter.dateFormat = "MM-dd-yyyy"
    //            print("Dateobj: \(dateFormatter.string(from: dateObj!))")
    //
    //            //starttime string to date
    //            event.startDate = dateObj!
    //            print(event.startDate)
    //            //event.endDate = endTime
    //            event.eventSummary = eventName
    //
    //            print("startTime: \(event.startDate), event Name: \(event.eventSummary)")
    //        }
    //
    //    }
}

