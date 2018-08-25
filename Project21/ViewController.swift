//
//  ViewController.swift
//  Project21
//
//  Created by Charles Martin Reed on 8/24/18.
//  Copyright © 2018 Charles Martin Reed. All rights reserved.
//

//importing UserNotifications to handle our permissions request and follow up code
import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //adding the buttons to our nav controller, programmatically
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
    }

    
    @objc func registerLocal() {
        //we need to request user permission to be able to bug them on the notification screen - uses the requestAuthorization method
        let center = UNUserNotificationCenter.current()
        
        //requestAuthorization takes an options array that allows you to specifiy what types of notifications you'd like to allow
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Yay!")
            } else {
                print("D'oh!")
            }
        }
        
    }
    
    //NOTE: You can CANCEL pending notifications using .removeAllPendingNotificationRequests()
    //ex: center.removeAllPendingNotificationRequests()
    
    @objc func scheduleLocal() {
        //notificaitions require content, a trigger, and a request that combines the two
        //creating a repeating alert using the calendar and DateComponents
        //UNMutableNotificationContent allows us to decide WHAT to show in our notification
        /*
         example:
         let content = UNMutableNotificationContent()
         content.title = "Title goes here"
         content.body = "Main text goes here"
         content.categoryIdentifier = "customIdentifier" -> this allows you to attach custom actions
         content.userInfo = ["customData": "fizzbuzz"] -> this allows you to attach custom data
         content.sound = UNNotificationSound.default()
         */
        
        //each notification can use a UUID to update it, think live scores, without having to generate an entirely new notification
        
        registerCategories()
        
        let center = UNUserNotificationCenter.current()
        
        //CONTENT
        let content = UNMutableNotificationContent()
        content.title = "Late wake up call"
        content.body = "The early bird catches the worm, but the second mouse gets the cheese."
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData" : "fizzbuzz"]
        content.sound = UNNotificationSound.default()
        
        //TRIGGER
        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 30
        //let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        //quicker TRIGGER for testing purposes
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        //REQUEST, with our UUID class generating a random character
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        //ADDING THE REQUEST to the Notification Center
        center.add(request)
        
    }
    
    //define what we do when we receive a notification
    //in this exercise, we take the customData we implemented in the content segement of the Nootification request
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        //pull out the info from the userInfo dictionary
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            print("Custom data received: \(customData)")
            
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                //the user swiped to unlock
                print("Default identifier")
                
            case "show":
                //the user tapped our "show more info..." button
                print("Show more information...")
                
            default:
                break
            }
        }
        
        //you must call the completion handler when you're finished
        completionHandler()
    }
    
    //we can add actions to our notifications, activated by buttons
    //this requires three parameters sent to UNNotificationAtion - identifier that gets sent when the button is tapped, title which is displayed to user in the UI and options that relate to the action.
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self //so the alerts are routed to the view controller for handling
        
        //launch the app in the foreground
        let show = UNNotificationAction(identifier: "show", title: "Tell me more...", options: .foreground)
        let category = UNNotificationCategory(identifier: "alarm", actions: [show], intentIdentifiers: [])
        
        center.setNotificationCategories([category])
    }


}

