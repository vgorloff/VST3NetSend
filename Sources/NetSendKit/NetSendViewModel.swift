//
//  NetSendViewModel.swift
//  VST3NetSend
//
//  Created by Vlad Gorlov on 25/09/2016.
//  Copyright © 2016 Vlad Gorlov. All rights reserved.
//

import Foundation

public class NetSendViewModel: NSObject {

   @objc public var status: NSNumber = 0
   @objc public var connectionFlag: NSNumber = 0
   @objc public var dataFormat: NSNumber = 0
   @objc public var port: NSNumber = 0
   @objc public var bonjourName: NSString = ""
   @objc public var password: NSString = ""
}
