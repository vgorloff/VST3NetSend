//
//  ConnectionStatusValueTransformer.swift
//  VST3NetSend
//
//  Created by Vlad Gorlov on 25/09/2016.
//  Copyright © 2016 Vlad Gorlov. All rights reserved.
//

import AudioToolbox
import Foundation

class ConnectionStatusValueTransformer: ValueTransformer {

   override class func transformedValueClass() -> Swift.AnyClass {
      return NSString.self
   }

   override class func allowsReverseTransformation() -> Bool {
      return false
   }

   override func transformedValue(_ value: Any?) -> Any? {
      var result = ""
      if let value = value as? NSNumber {
         switch value.intValue {
         case kAUNetStatus_NotConnected:
            result = "Not Connected"
         case kAUNetStatus_Connected:
            result = "Connected"
         case kAUNetStatus_Overflow:
            result = "Overflow"
         case kAUNetStatus_Underflow:
            result = "Underflow"
         case kAUNetStatus_Connecting:
            result = "Connecting"
         case kAUNetStatus_Listening:
            result = "Listening"
         default:
            break
         }
      }
      return result
   }
}
