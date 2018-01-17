//
//  NotificationManager.swift
//  UserNotification-Example
//
//  Created by Muhammad Hijazi on 16/01/2018.
//  Copyright © 2018 iReka Soft. All rights reserved.
//

import UIKit
import UserNotifications

let userNotificationCenter = UNUserNotificationCenter.current()
var notificationsRequest : [UNNotificationRequest]?

class NotificationManager: NSObject {
  
  class func allNotifications() {
    userNotificationCenter.getPendingNotificationRequests { (_notificationsRequest) in
      
      for notificationRequest in _notificationsRequest {
        
        print(notificationRequest)
        
      }
      
    }
    
  }
  
  //Schedule Notification with weekly basis.
  func scheduleNotification(at date: Date, body: String, titles:String, notifID: String, extraID: String) {
    
    let triggerWeekly = Calendar.current.dateComponents([.weekday,.hour,.minute], from: date)
    
    // change this for repeating or not
    let trigger = UNCalendarNotificationTrigger(dateMatching: triggerWeekly, repeats: true)
    
    let content = UNMutableNotificationContent()
    content.title = titles
    content.body = body
    //    content.sound = UNNotificationSound.default()
    content.sound = UNNotificationSound.init(named: "ring.caf")
    content.categoryIdentifier = "alarm"
    
    let uniqueString = notifID+"-\(extraID)"
    
    let request = UNNotificationRequest(identifier: uniqueString, content: content, trigger: trigger)
    
    UNUserNotificationCenter.current().add(request) {(error) in
      if let error = error {
        print("Uh oh! We had an error: \(error)")
      }
    }
    
  }
  
}
