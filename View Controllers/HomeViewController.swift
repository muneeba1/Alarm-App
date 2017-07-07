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

class HomeViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {
    
  
    @IBOutlet weak var tableView: UITableView!
    var eventsArray: [EventsModel] = []

    // If modifying these scopes, delete your previously saved credentials by
    // resetting the iOS simulator or uninstall the app.
    private let scopes = [kGTLRAuthScopeCalendarReadonly]
    
    private let service = GTLRCalendarService()
    let signInButton = GIDSignInButton()
    let output = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure Google Sign-in.
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().scopes = scopes
        GIDSignIn.sharedInstance().signIn()
        //GIDSignIn.sharedInstance().signInSilently()
        //GIDSignIn.sharedInstance().clientID = "<CLIENT_ID>"
        
        // Add the sign-in button.
        view.addSubview(signInButton)
        
        // Add a UITextView to display output.
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        if let events = response.items, !events.isEmpty {
            let formatter = DateFormatter()
            formatter.locale = Locale.current
            formatter.setLocalizedDateFormatFromTemplate("yyyy-MM-ddTHH:mm:ss")
            for gEvent in events {
                //let startString = gEvent.start!.dateTime?.stringValue ?? gEvent.start!.date!.stringValue
                //let startDate = formatter.date(from: startString)
                //let endString = gEvent.end!.dateTime?.stringValue ?? gEvent.end!.date!.stringValue
                //let endDate = formatter.date(from: endString)
                let summaryString = gEvent.summary ?? ""
                let locationString = gEvent.location ?? ""
                let event: EventsModel = EventsModel(startDate: Date(), eventSummary: summaryString, endDate: Date(), location: locationString)
                eventsArray.append(event)
            }
            tableView.reloadData()
        } else {
            outputText = "No upcoming events found."
        }
        output.text = outputText
    }
    
    
    // Helper for showing an alert
    func showAlert(title : String, message: String) {
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
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0  {
            return 1
        }
        else{
            return eventsArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0{
            return 180.0
        }else{
            return 100.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "alarmCell", for: indexPath) as! AlarmTableViewCell
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as! InfoTableViewCell
            let event = eventsArray[indexPath.row]
            let dateFormatter = DateFormatter()
            dateFormatter.setLocalizedDateFormatFromTemplate("hh:mm A")
            cell.label.text = "\(dateFormatter.string(from: event.startDate)) to \(dateFormatter.string(from: event.endDate))"
            cell.textView.text = event.eventSummary
            return cell
        }
    }
}
