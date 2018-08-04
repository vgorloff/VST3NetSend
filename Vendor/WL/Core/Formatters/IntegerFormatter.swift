//
//  IntegerFormatter.swift
//  mcCore
//
//  Created by Vlad Gorlov on 25/09/2016.
//  Copyright © 2016 Vlad Gorlov. All rights reserved.
//

import Foundation

class IntegerFormatter: Formatter {

   func string(forNumber number: NSNumber) -> String {
      return String(format: "%d", number.intValue)
   }

   override func string(for obj: Any?) -> String? {
      guard let number = obj as? NSNumber else {
         return nil
      }
      return string(forNumber: number)
   }

   override func editingString(for obj: Any) -> String? {
      return string(for: obj)
   }

   override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String,
                                errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {

      var integerResult = 0
      var returnValue = false
      let scanner = Scanner(string: string.replacingOccurrences(of: ",", with: "."))
      if scanner.scanInt(&integerResult) && scanner.isAtEnd {
         returnValue = true
         if let obj = obj {
            obj.pointee = NSNumber(value: integerResult)
         }
      } else {
         if let error = error {
            error.pointee = NSLocalizedString("Couldn’t convert text to integer", comment: "Error converting") as NSString
         }
      }

      return returnValue
   }
}
