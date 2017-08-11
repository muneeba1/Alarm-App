//
//  EditTimeViewController.swift
//  Alarm App
//
//  Created by Muneeba Khatoon on 8/7/17.
//  Copyright © 2017 Muneeba Khatoon. All rights reserved.
//

import Foundation
import UIKit

class EditTimeViewController: UIViewController{
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var timePickerView: UIPickerView!
   
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem)
    {
        let ud = UserDefaults.standard
        ud.set(selectedHour, forKey: "hour")
        ud.set(selectedMins, forKey: "minutes")
        ud.set(selectedPeriod, forKey: "period")
        
        print("\(self.selectedHour):\(self.selectedMins)\(self.selectedPeriod)")
        self.navigationController?.popViewController(animated: true)
    }
  
    var hourArray: [String] = ["1","2","3","4","5","6","7","8","9","10","11","12"]
    var minArray: [String] = ["00","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59"]
    var periodArray: [String] = ["AM", "PM"]
    
    var selectedHour: String = "7"
    var selectedMins: String = "00"
    var selectedPeriod: String = "AM"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
}

extension EditTimeViewController: UIPickerViewDelegate, UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if component == 0
        {
            return hourArray.count
        }
        else if component == 1
        {
            return minArray.count
        }else
        {
            return periodArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if component == 0
        {
            selectedHour = hourArray[row]
            return hourArray[row]
        }
        else if component == 1
        {
            selectedMins = minArray[row]
            return minArray[row]
        }else
        {
            selectedPeriod = periodArray[row]
            return periodArray[row]
        }
    }
    
    //styling picker data
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString?
    {
        if component == 0
        {
        let titleData = hourArray[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size:15.0)!,NSForegroundColorAttributeName:UIColor.gray])
        return myTitle
            
        }else if component == 1
        {
            let titleData = minArray[row]
            let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 15.0)!,NSForegroundColorAttributeName:UIColor.gray])
            return myTitle
            
        }else
        {
            let titleData = periodArray[row]
            let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 15.0)!,NSForegroundColorAttributeName:UIColor.gray])
            return myTitle
        }
    }

}
