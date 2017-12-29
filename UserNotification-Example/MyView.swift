//
//  MyView.swift
//  UserNotification-Example
//
//  Created by Muhammad Hijazi on 24/12/2017.
//  Copyright © 2017 iReka Soft. All rights reserved.
//

import UIKit

class MyView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
  
  override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    return false
  }

}
