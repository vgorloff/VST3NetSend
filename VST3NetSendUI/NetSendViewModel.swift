//
//  NetSendViewModel.swift
//  VST3NetSend
//
//  Created by Vlad Gorlov on 25/09/2016.
//  Copyright © 2016 Vlad Gorlov. All rights reserved.
//

import Foundation

class NetSendViewModel: NSObject {

   var status = NSNumber(integerLiteral: 0)
   var connectionFlag = NSNumber(integerLiteral: 0)
   var dataFormat = NSNumber(integerLiteral: 0)
   var port = NSNumber(integerLiteral: 0)
   var bonjourName = NSString(string: "")
   var password = NSString(string: "")

}
