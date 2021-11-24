//
//  NSTextField.swift
//  MCA-OSS-VSTNS
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if os(macOS)
import AppKit

extension NSTextField {

   public var title: String {
      get {
         return stringValue
      } set {
         stringValue = newValue
      }
   }

   public var text: String {
      get {
         return stringValue
      } set {
         stringValue = newValue
      }
   }

   public var platformText: String? {
      get {
         return stringValue
      } set {
         stringValue = newValue ?? ""
      }
   }

   public var placeholder: String? {
      get {
         return placeholderString
      } set {
         placeholderString = newValue
      }
   }
}
#endif
