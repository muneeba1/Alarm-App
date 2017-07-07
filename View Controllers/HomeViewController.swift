//
//  HomeViewController.swift
//  Alarm App
//
//  Created by Muneeba Khatoon on 7/5/17.
//  Copyright © 2017 Muneeba Khatoon. All rights reserved.
//

import UIKit
import UserNotifications

class HomeViewController: UIViewController
{

    @IBOutlet weak var homeTableView: UITableView!
    let scheduler = AlarmService()
    var alarms: [AlarmModel] = []
    var today: Int = 0

    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        let notificationCenter = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound]
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized
            {
                notificationCenter.requestAuthorization(options: options, completionHandler: { (success, error) in
                    print("notifications success \(success) and error \(error!.localizedDescription)")
                })
            }
            else
            {
                print("already authorized")
                let date = Date().addingTimeInterval(TimeInterval(exactly: 60)!)
                let alarm = AlarmModel(date: date, enabled: true, weekDay: .Thursday, label: "Testing 1")
                self.scheduler.setupNotificationsForAlarm(alarm: alarm)
            }
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEE MMMMd")
        self.title = dateFormatter.string(from: Date())
        let cal :Calendar = Calendar(identifier: .gregorian)
        let weekDay = cal.component(.weekday, from: Date())
        today = weekDay
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        alarms = AlarmModel.getAlarms()
        print("test")
    }

}


extension HomeViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0
        {
            let alarmCell = tableView.dequeueReusableCell(withIdentifier: "alarmCell", for: indexPath) as! AlarmTableViewCell
            return alarmCell
        }
        else
        {
            let infoCell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as! InfoTableViewCell
            return infoCell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 0
    }
}
