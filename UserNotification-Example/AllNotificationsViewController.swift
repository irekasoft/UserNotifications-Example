//
//  AllNotificationsViewController.swift
//  UserNotification-Example
//
//  Created by Muhammad Hijazi on 23/12/2017.
//  Copyright © 2017 iReka Soft. All rights reserved.
//

import UIKit
import UserNotifications

class AllNotificationsViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  let userNotificationCenter = UNUserNotificationCenter.current()
  
  var notificationsRequest : [UNNotificationRequest]?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    userNotificationCenter.getPendingNotificationRequests { (_notificationsRequest) in
      
      for notificationRequest in _notificationsRequest {
        
        print(notificationRequest)
        
      }
      
      self.notificationsRequest = _notificationsRequest
      
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
      

      
    }
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  @IBAction func done2(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func done(_ sender: Any) {
    
    dismiss(animated: true, completion: nil)
    
  }
  

  @IBAction func removeAllNotifs(_ sender: Any) {
    
    userNotificationCenter.removeAllPendingNotificationRequests()
    
    perform(#selector(reloadTableViewData), with: nil, afterDelay: 0.3)
    
  }
  
  @objc func reloadTableViewData(){
    
    tableView.reloadData()
    
  }
  
}



extension AllNotificationsViewController : UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    if notificationsRequest != nil {
      return (self.notificationsRequest?.count)!
    }else {
      return 0
    }

    
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
    
    let notificationRequest = notificationsRequest![indexPath.row]
    
//  let identifier = notificationRequest.identifier
    
    let body = notificationRequest.content.body
    let identifier = notificationRequest.identifier
    cell?.textLabel?.text = body
    
    if let trigger = notificationRequest.trigger as? UNCalendarNotificationTrigger {
      
      print(trigger.dateComponents.date)
      
      cell?.detailTextLabel?.text = "\(identifier)"
      
      
      
    }

    
    return cell!
    
    
  }
  
  
  
}
