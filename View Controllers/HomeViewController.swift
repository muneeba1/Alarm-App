//
//  HomeViewController.swift
//  Alarm App
//
//  Created by Muneeba Khatoon on 7/5/17.
//  Copyright © 2017 Muneeba Khatoon. All rights reserved.
//

import GoogleAPIClientForREST
import GoogleSignIn
import UIKit
import UserNotifications
import AVFoundation

class HomeViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate
{
    
    @IBOutlet weak var tableView: UITableView!
    
    let speechService = SpeechService()
    var eventsArray: [EventsModel] = []
    
    // If modifying these scopes, delete your previously saved credentials by
    // resetting the iOS simulator or uninstall the app.
    private let scopes = [kGTLRAuthScopeCalendarReadonly]
    
    private let service = GTLRCalendarService()
    let signInButton = GIDSignInButton()
    let output = UITextView()
    
    let scheduler = AlarmService()
    var alarms: [AlarmModel] = []
    var today: Int = 0
    var displayedAlarm: AlarmModel?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Configure Google Sign-in.
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().scopes = scopes
        GIDSignIn.sharedInstance().signIn()
        //GIDSignIn.sharedInstance().signInSilently()
        //GIDSignIn.sharedInstance().clientID = "<CLIENT_ID>"
        
        //back button color
        self.navigationController?.navigationBar.tintColor = UIColor.myOrangeColor()
        
        // Add the sign-in button.
        view.addSubview(signInButton)
        
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
                let ud = UserDefaults.standard
                let hour = ud.object(forKey: "hour")
                let mins = ud.object(forKey: "minutes")
                let period = ud.object(forKey: "period")
                //let date = Date().addingTimeInterval(TimeInterval(exactly: 60)!)
                //let alarm = AlarmModel(date: date, enabled: true, weekDay: .Thursday, label: "Testing 1")
                //self.scheduler.setupNotificationsForAlarm(alarm: alarm)
                
                //dispalying ud
                //saving it
            }
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEE MMMMd")
        // self.title = dateFormatter.string(from: Date())
        let cal :Calendar = Calendar(identifier: .gregorian)
        let weekDay = cal.component(.weekday, from: Date())
        today = weekDay
        
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        label.textAlignment = .center
        label.text = dateFormatter.string(from: Date())
        label.textColor = UIColor.myPurpleColor()
        self.navigationItem.titleView = label
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        alarms = AlarmModel.getAlarms()
        displayedAlarm = alarms[today]
        print("today \(String(describing: displayedAlarm?.date)) label \(String(describing: displayedAlarm?.label))")
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            showAlert(title: "Authentication Error", message: error.localizedDescription)
            self.service.authorizer = nil
        } else {
            self.signInButton.isHidden = true
            self.output.isHidden = false
            self.service.authorizer = user.authentication.fetcherAuthorizer()
            fetchEvents()
        }
    }
    
    // Construct a query and get a list of upcoming events from the user calendar
    func fetchEvents() {
        let query = GTLRCalendarQuery_EventsList.query(withCalendarId: "primary")
        query.maxResults = 10
        query.timeMin = GTLRDateTime(date: Date())
        query.singleEvents = true
        query.orderBy = kGTLRCalendarOrderByStartTime
        service.executeQuery(
            query,
            delegate: self,
            didFinish: #selector(displayResultWithTicket(ticket:finishedWithObject:error:)))
    }
    
    // Display the start dates and event summaries in the UITextView
    func displayResultWithTicket(
        ticket: GTLRServiceTicket,
        finishedWithObject response : GTLRCalendar_Events,
        error : NSError?) {
        
        if let error = error {
            showAlert(title: "Error", message: error.localizedDescription)
            return
        }
        
        var outputText = ""
        if let events = response.items, !events.isEmpty
        {
            let formatter = DateFormatter()
            formatter.locale = Locale.current
            formatter.setLocalizedDateFormatFromTemplate("yyyy-MM-ddTHH:mm:ss")
            for gEvent in events
            {
                //let startString = gEvent.start!.dateTime?.stringValue ?? gEvent.start!.date!.stringValue
                //let startDate = formatter.date(from: startString)
                //let endString = gEvent.end!.dateTime?.stringValue ?? gEvent.end!.date!.stringValue
                //let endDate = formatter.date(from: endString)
                let summaryString = gEvent.summary ?? ""
                let locationString = gEvent.location ?? ""
                let event: EventsModel = EventsModel(startDate: (gEvent.start?.dateTime?.date)!, eventSummary: summaryString, endDate: (gEvent.end?.dateTime?.date)!, location: locationString)
                eventsArray.append(event)
            }
            tableView.reloadData()
        }
        else
        {
            speakEvents()
            outputText = "No upcoming events found."
        }
        output.text = outputText
    }
    
    
    // Helper for showing an alert
    func showAlert(title : String, message: String)
    {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.alert
        )
        let ok = UIAlertAction(
            title: "OK",
            style: UIAlertActionStyle.default,
            handler: nil
        )
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func speakEvents()
    {
        let ud = UserDefaults.standard
        let speakIsOff: Bool = ud.object(forKey: "speakIsOff") as? Bool ?? false
        if !speakIsOff
        {
            var stringToSpeak = "Good Morning. Today you have \(eventsArray.count) events. Here they are: "
            for event in eventsArray
            {
                stringToSpeak += " \(event.eventSummary),  then  "
            }
            stringToSpeak += " you're free! "
            speechService.speakString(text: stringToSpeak)
        }
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0
        {
            return 1
        }
        else
        {
            return eventsArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0
        {
            return 140.0
        }else
        {
            return 100.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0
        {
            let formatter = DateFormatter()
            formatter.setLocalizedDateFormatFromTemplate("hh:mm A")
            let cell = tableView.dequeueReusableCell(withIdentifier: "alarmCell", for: indexPath) as! AlarmTableViewCell
            //cell.timeLabel.text = formatter.string(from: displayedAlarm?.date ?? Date())
            cell.titleField.text = displayedAlarm?.label ?? "no alarm"
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as! InfoTableViewCell
            let event = eventsArray[indexPath.row]
            let dateFormatter = DateFormatter()
            dateFormatter.setLocalizedDateFormatFromTemplate("h:mm a")
            cell.label.text = "\(dateFormatter.string(from: event.startDate)) to \(dateFormatter.string(from: event.endDate))"
            cell.textView.text = event.eventSummary
            
            return cell
        }
    }
}

extension UIColor
{
    class func myOrangeColor() -> UIColor
    {
        return UIColor(red:0.60, green:0.49, blue:0.42, alpha:1.0)
    }
    
    class func myPurpleColor() -> UIColor
    {
        return UIColor(red:0.17, green:0.17, blue:0.22, alpha:1.0)
    }
}

