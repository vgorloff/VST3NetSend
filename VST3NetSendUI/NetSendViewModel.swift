//
//  NetSendViewModel.swift
//  VST3NetSend
//
//  Created by Vlad Gorlov on 25/09/2016.
//  Copyright © 2016 Vlad Gorlov. All rights reserved.
//

import Foundation

class NetSendViewModel: NSObject {

   @objc var status = NSNumber(integerLiteral: 0)
   @objc var connectionFlag = NSNumber(integerLiteral: 0)
   @objc var dataFormat = NSNumber(integerLiteral: 0)
   @objc var port = NSNumber(integerLiteral: 0)
   @objc var bonjourName = NSString(string: "")
   @objc var password = NSString(string: "")

}
