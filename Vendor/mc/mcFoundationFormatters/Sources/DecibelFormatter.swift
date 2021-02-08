//
//  DecibelFormatter.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 04.03.16.
//  Copyright © 2016 Vlad Gorlov. All rights reserved.
//

import Foundation
import mcMath

public final class DecibelFormatter: Formatter {

   public var minValue = -120.0
   public var maxValue = 0.0
   public var unit = "dB"

   override public func string(for obj: Any?) -> String? {
      guard let value = obj as? NSNumber else {
         return nil
      }
      return stringForNumberValue(value, forEditing: false)
   }

   override public func editingString(for obj: Any) -> String? {
      guard let value = obj as? NSNumber else {
         return nil
      }
      return stringForNumberValue(value, forEditing: true)
   }

   override public func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String,
                                       errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
      var returnValue = false
      let scanner = Scanner(string: string.replacingOccurrences(of: ",", with: "."))
      var doubleResult: Double?
      if #available(OSX 10.15, iOS 13.0, *) {
         doubleResult = scanner.scanDouble()
      } else {
         var value = 0.0
         if scanner.scanDouble(&value) {
            doubleResult = value
         }
      }

      if let doubleResult = doubleResult, scanner.isAtEnd {
         returnValue = true
         let result = Math.valueInRange(doubleResult, min: minValue, max: maxValue)
         if obj != nil {
            obj?.pointee = NSNumber(value: result)
         }
      } else {
         if error != nil {
            error?.pointee = "Couldn’t convert to double"
         }
      }
      return returnValue
   }

   // MARK: - Private

   private func stringForNumberValue(_ value: NSNumber, forEditing: Bool) -> String? {
      var format = (abs(value.intValue) < 100) ? "%.2f" : "%.1f"
      if !forEditing {
         format += " \(unit)"
      }
      return String(format: format, value.floatValue)
   }
}
