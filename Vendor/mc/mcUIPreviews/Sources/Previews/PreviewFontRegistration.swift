//
//  PreviewFontRegistration.swift
//  Shared
//
//  Created by Vlad Gorlov on 07.02.21.
//

import Foundation
import CoreText

public struct PreviewFontRegistration {

   /// Provide application fonts here. Example: ["OpenSans-Bold", "OpenSans-BoldItalic"]
   public static var fontNames: [String] = []

   static func registerCustomFonts() {
      fontNames.forEach {
         if let fontURL = Bundle.main.url(forResource: $0, withExtension: "ttf") {
            CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, nil)
         } else {
            NSLog("Unable to form url for font: \($0)")
         }
      }
   }
}
