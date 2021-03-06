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
  
  @IBOutlet weak var lbl_smile: UILabel!
  

  
  let userNotificationCenter = UNUserNotificationCenter.current()
  
  let calendar = Calendar(identifier: .gregorian)
  
  override func viewDidLoad() {
    super.viewDidLoad()

    registerUserNotification()
    
//    Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (timer) in
//
//      self.updateTime()
//
//    }
    
    // Create an unscheduled timer
    let timer = Timer(
      timeInterval: 0.1,
      target: self,
      selector: #selector(updateTime),
      userInfo: nil,
      repeats: true)
    
    // Add the timer to a runloop (in this case the main run loop)
    RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    UIView.animate(withDuration: 1) {
      
      //self.lbl_smile.alpha = 0
      
    }
    
    let basicAnim = CABasicAnimation(keyPath: "opacity")

    basicAnim.toValue = 0
    basicAnim.autoreverses = true
    basicAnim.duration = 0.5
    basicAnim.repeatCount = Float.infinity
    
//    basicAnim.fillMode = "backwards"
    
    lbl_smile.layer.add(basicAnim, forKey: "aa")

//    addCATextLayer()
    
  }
  

  
  let baseFontSize: CGFloat = 24.0
  var textLayer = CATextLayer()
  
  func addCATextLayer(){
    
    textLayer.frame = tv_top.bounds
    textLayer.string = "AAAA"

    var fontName: CFString = "Noteworthy-Light" as CFString
    let noteworthyLightFont = CTFontCreateWithName(fontName, baseFontSize, nil)
    fontName = "Helvetica" as CFString
    let helveticaFont = CTFontCreateWithName(fontName, baseFontSize, nil)
    
    textLayer.font = CTFontCreateWithName(fontName, baseFontSize, nil)

    textLayer.foregroundColor = UIColor.darkGray.cgColor
    textLayer.isWrapped = true
    textLayer.alignmentMode = kCAAlignmentLeft
    textLayer.contentsScale = UIScreen.main.scale
    tv_top.layer.addSublayer(textLayer)
    
  }
  
  // MARK: - Update
  
  @objc func updateTime(){
    
    let dateFormatter = DateFormatter()
    dateFormatter.locale = NSLocale.current

    dateFormatter.dateFormat = "(EEE) dd/mm/yy, h:mm:ss zzz"
    //    dateFormatter.dateStyle = .short
    //    dateFormatter.timeStyle = .full
    let dateString = dateFormatter.string(from: Date())
    
    DispatchQueue.main.async {
      self.tv_top.text = dateString
      
    }
    
//    self.textLayer.string = dateString
    
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
  
  // MARK: - Actions
  
  @IBAction func trigger(_ sender: Any) {
    
    var recurring = [String]()
    
    for btn in btns_weekday {
      if (btn.isSelected){
        print("btn \(btn.tag) is selected")
        recurring.append("\(btn.tag)")
      }
    }
    
    if recurring.count > 0 {
      createNotificationWeekdayBasis()
    }else{
      createOneOffNotification()
    }

    
  }
  
  func createOneOffNotification(){
    
    let selectedDate = datePicker.date
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    
    let calendar = Calendar(identifier: .gregorian)
    
    let hour = calendar.component(.hour, from: selectedDate) // This will always return in 24-hour format of hour. 0-23
    let minute = calendar.component(.minute, from: selectedDate)

    var components = DateComponents()
    components.timeZone = .current
    components.hour = hour
    components.minute = minute
    
    let createdDate = timeDate(weekday: 0, hour: hour, minute: minute)
    
    scheduleNotification(at: createdDate, body: "For \(hour):\(minute)", titles: "Notif", notifID:uniqueString(), extraID: "0",isRepeating: false)
    
  }
  
  func uniqueString()-> String {
    
    let timestampAsString = String(format: "%f", NSDate.timeIntervalSinceReferenceDate)
    let timestampParts = timestampAsString.components(separatedBy: ".")
    return timestampParts[0]
    
  }
  
  func createNotificationWeekdayBasis(){
    print(datePicker.date)
    
    print("24 hour", IRHelper.is24h() )
    
    let selectedDate = datePicker.date
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    
    let hour = calendar.component(.hour, from: selectedDate) // This will always return in 24-hour format of hour. 0-23
    
    let minute = calendar.component(.minute, from: selectedDate)
    
    print(hour, minute)
    
    let uniqueString = self.uniqueString()
    
    for btn in btns_weekday {
      
      if (btn.isSelected){
        
        print("btn \(btn.tag) is selected")
        
        // (Sunday = 1, Monday = 2, Tuesday = 3, Wednesday = 4, thursday = 5, Friday = 6, Saturday = 7)
        let weekday = btn.tag
        
        let createdDate = timeDate(weekday: weekday, hour: hour, minute: minute)
        
        scheduleNotification(at: createdDate, body: "For \(hour):\(minute)", titles: "Notif", notifID:uniqueString, extraID: "\(btn.tag)", isRepeating: true)
        
      }
      
    }
  }

  // MARK: - Notification Creation

  //Create Date from picker selected value.
  func timeDate(weekday: Int, hour: Int, minute: Int)->Date{
    
    var components = DateComponents()
    components.hour = hour
    components.minute = minute
    
    if weekday != 0 {
      components.weekday = weekday // sunday = 1 ... saturday = 7
    }
    
    components.timeZone = .current
    
    let calendar = Calendar(identifier: .gregorian)
    
    return calendar.date(from: components)!
    
  }
  
  //Schedule Notification with weekly basis.
  func scheduleNotification(at date: Date, body: String, titles:String, notifID: String, extraID: String, isRepeating: Bool) {

    var dateComponent : DateComponents!
    
    if isRepeating == true {
      dateComponent = Calendar.current.dateComponents([.weekday,.hour,.minute], from: date)
    }else{
      dateComponent = Calendar.current.dateComponents([.hour,.minute], from: date)
    }
    
    // change this for repeating or not
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: isRepeating)
    
    let content = UNMutableNotificationContent()
    content.title = titles
    content.body = body
//    content.sound = UNNotificationSound.default()
    content.sound = UNNotificationSound.init(named: "ring.caf")
    content.categoryIdentifier = "alarm"
    
    let uniqueString = notifID+"-\(extraID)"
    
    let request = UNNotificationRequest(identifier: uniqueString, content: content, trigger: trigger)
    
    UNUserNotificationCenter.current().delegate = self
    
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
    content.sound = UNNotificationSound.init(named: "ring.caf")
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
    
    tv_top.text = "Just got notification"
    
    completionHandler([.sound])
    
    let vc = storyboard?.instantiateViewController(withIdentifier: "AlarmAlertVC")
    present(vc!, animated: true, completion: nil)
    
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    
    let vc = storyboard?.instantiateViewController(withIdentifier: "AlarmAlertVC")
    
    present(vc!, animated: true, completion: nil)
    
  }
  
}

