//
//  ViewController.swift
//  UserNotification-Example
//
//  Created by Muhammad Hijazi on 23/12/2017.
//  Copyright © 2017 iReka Soft. All rights reserved.
//
// https://stackoverflow.com/questions/45061324/repeating-local-notifications-for-specific-days-of-week-swift-3-ios-10

import UIKit
import UserNotifications

class ViewController: UIViewController {

  @IBOutlet weak var tv_top: UITextView!
  @IBOutlet var btns_weekday: [UIButton]!
  @IBOutlet weak var datePicker: UIDatePicker!
  
  let userNotificationCenter = UNUserNotificationCenter.current()
  
  override func viewDidLoad() {
    super.viewDidLoad()

    registerUserNotification()
    
    Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (timer) in
      
      self.updateTime()
      
    }
    
  }
  
  func updateTime(){
    
    let dateFormatter = DateFormatter()
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateStyle = .short
    dateFormatter.timeStyle = .full
    
    let dateString = dateFormatter.string(from: Date())
    
    
    DispatchQueue.main.async {
      self.tv_top.text = dateString
    }
    

    
  }
  
  func registerUserNotification(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
    { (granted, error) in
      // Enable or disable features based on authorization.
    }
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func enableDisable(_ sender: UIButton) {
    
    sender.isSelected = !sender.isSelected

    
  }
  
  func is24h()->Bool{
    
    let dateFormatter = DateFormatter()
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateStyle = .none
    dateFormatter.timeStyle = .short
    
    let dateString = dateFormatter.string(from: Date())
    let amRange = dateString.range(of: dateFormatter.amSymbol)
    let pmRange = dateString.range(of: dateFormatter.pmSymbol)
    
    
    print(dateString)
    print(dateFormatter.amSymbol)
    
    
    if ((amRange != nil) || (pmRange != nil)){
      return false
    }else {
      return true
    }
    
  }
  
  // MARK: - Actions
  
  @IBAction func trigger(_ sender: Any) {
    
    print(datePicker.date)
    
    print("24 hour", is24h() )
    
    let selectedDate = datePicker.date
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    
    
    
    // (Sunday = 1, Monday = 2, Tuesday = 3, Wednesday = 4, thursday = 5, Friday = 6, Saturday = 7)
    for btn in btns_weekday {
      
      
      
      if (btn.isSelected){
        print("btn \(btn.tag) is selected")
        
        
        
      }
      
    }
  
  }


  //Create Date from picker selected value.
  func createDate(weekday: Int, hour: Int, minute: Int)->Date{
    
    var components = DateComponents()
    components.hour = hour
    components.minute = minute
    components.weekday = weekday // sunday = 1 ... saturday = 7
    components.weekdayOrdinal = 10
    components.timeZone = .current
    
    let calendar = Calendar(identifier: .gregorian)
    
    return calendar.date(from: components)!
    
  }
  
  //Schedule Notification with weekly bases.
  func scheduleNotification(at date: Date, body: String, titles:String) {
    
    let triggerWeekly = Calendar.current.dateComponents([.weekday,.hour,.minute,.second,], from: date)
    
    let trigger = UNCalendarNotificationTrigger(dateMatching: triggerWeekly, repeats: true)
    
    let content = UNMutableNotificationContent()
    content.title = titles
    content.body = body
    content.sound = UNNotificationSound.default()
    content.categoryIdentifier = "todoList"
    
    let request = UNNotificationRequest(identifier: "textNotification", content: content, trigger: trigger)
    
    UNUserNotificationCenter.current().delegate = self
    //UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    UNUserNotificationCenter.current().add(request) {(error) in
      if let error = error {
        print("Uh oh! We had an error: \(error)")
      }
    }
    
  }
  
  @IBAction func triggerIn3Sec(_ sender: Any) {
    
    // 1. Notification Content
    let content = UNMutableNotificationContent()
    content.title = "User Notifications"
//    content.subtitle = "Subtitle"
    content.body = "You should drink more"
    content.sound = UNNotificationSound.default()
    content.badge = (UIApplication.shared.applicationIconBadgeNumber + 1) as NSNumber; // Always Increment
    content.categoryIdentifier = "notification-category" // For Actionable notification
    
    // 2. Trigger
    let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval:3, repeats: false)
    
    // Schedule the notification
    let request = UNNotificationRequest.init(identifier: "id-123", content: content, trigger: trigger)
    
    // 3. Add to User Notification Center
    userNotificationCenter.delegate = self
    userNotificationCenter.add(request)
    
  }
  
}

extension ViewController : UNUserNotificationCenterDelegate {
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    
    // To show the banner in-app
    
    tv_top.text = "just got notification"
    
    completionHandler([.badge, .alert, .sound])
    
  }
  
}

