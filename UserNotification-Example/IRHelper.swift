//
//  IRHelper.swift
//  UserNotification-Example
//
//  Created by Muhammad Hijazi on 23/12/2017.
//  Copyright © 2017 iReka Soft. All rights reserved.
//

import UIKit

class IRHelper: NSObject {

  class func is24h()->Bool{
    
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
  
}
