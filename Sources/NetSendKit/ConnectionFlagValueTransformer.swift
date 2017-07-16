//
//  ConnectionFlagValueTransformer.swift
//  VST3NetSend
//
//  Created by Vlad Gorlov on 16.07.17.
//  Copyright © 2017 Vlad Gorlov. All rights reserved.
//

import Foundation

class ConnectionFlagValueTransformer: ValueTransformer {

   override class func transformedValueClass() -> Swift.AnyClass {
      return NSString.self
   }

   override class func allowsReverseTransformation() -> Bool {
      return false
   }

   override func transformedValue(_ value: Any?) -> Any? {
      var result = ""
      if let value = value as? NSNumber {
         // Value == "0" in AU means "Connected"
         // Value >  "0" in AU means "Disconnected"
         // But button should showd opposite title.
         // So, when value not "0" we need to show title "Connect"
         result = value.boolValue == true ? "Connect" : "Disconnect"
      }
      return result as NSString
   }
}
