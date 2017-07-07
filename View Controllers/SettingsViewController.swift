//
//  SettingsViewController.swift
//  Alarm App
//
//  Created by Muneeba Khatoon on 7/5/17.
//  Copyright © 2017 Muneeba Khatoon. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // 1
            if let identifier = segue.identifier {
                // 2
                if identifier == "displayCalendar" {
                    // 3
                    print("Calendar Settings")
                }
                if identifier == "displayAnnounceTime" {
                    // 3
                    print("Announce Time Settings")
                }
                if identifier == "displaySnooze" {
                    // 3
                    print("Smart Snooze Settings")
                }

            }
        }
    
}
