//
//  NetSendViewModel.swift
//  VST3NetSend
//
//  Created by Vlad Gorlov on 25/09/2016.
//  Copyright © 2016 Vlad Gorlov. All rights reserved.
//

import Foundation

public class NetSendViewModel: NSObject {

   @objc public var status = NSNumber(integerLiteral: 0)
   @objc public var connectionFlag = NSNumber(integerLiteral: 0)
   @objc public var dataFormat = NSNumber(integerLiteral: 0)
   @objc public var port = NSNumber(integerLiteral: 0)
   @objc public var bonjourName = NSString(string: "")
   @objc public var password = NSString(string: "")

}
