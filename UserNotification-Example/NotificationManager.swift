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
  
}
