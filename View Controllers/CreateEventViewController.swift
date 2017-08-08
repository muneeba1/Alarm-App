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
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem)
    {
        let ud = UserDefaults.standard
        ud.set(eventName, forKey: "eventTitle")
        self.navigationController?.popViewController(animated: true)
    }
    
    var eventName: String = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        eventName = titleTextField.text!
        
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
    
    func todayPressed(sender: UIBarButtonItem) {
        
        let formatter = DateFormatter()
        
        formatter.dateStyle = DateFormatter.Style.medium
        
        formatter.timeStyle = DateFormatter.Style.medium
        
        startTimeTextField.text = formatter.string(from: NSDate() as Date)
        
        startTimeTextField.resignFirstResponder()
        
        endTimeTextField.text = formatter.string(from: NSDate() as Date)
        
        endTimeTextField.resignFirstResponder()
    }
    
    func datePickerValueChanged(sender: UIDatePicker) {
        
        let formatter = DateFormatter()
        
        formatter.dateStyle = DateFormatter.Style.medium
        
        formatter.timeStyle = DateFormatter.Style.short
        
        startTimeTextField.text = formatter.string(from: sender.date)
        
        endTimeTextField.text = formatter.string(from: sender.date)
    }
    
    func donePressed(sender: UIBarButtonItem) {
        
        startTimeTextField.resignFirstResponder()
        endTimeTextField.resignFirstResponder()
    }
}

