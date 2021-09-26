//
//  UIPreviewDevice.swift
//  iosclient
//
//  Created by Vlad Gorlov on 07.04.21.
//  Copyright © 2021 Vlad Gorlov. All rights reserved.
//

import Foundation
import SwiftUI

#if !os(watchOS)

public enum UIPreviewDeviceType: String, CaseIterable {

   // Enumeration values taken from `xcrun simctl list devicetypes`. See also `PreviewDevice`
   case iPhoneSE_1stGen = "iPhone SE (1st generation)"
   case iPhone11 = "iPhone 11"
   case iPad_6thGen = "iPad (6th generation)"

   @available(iOS 13.0, macOS 10.15, *)
   public var device: PreviewDevice {
      return PreviewDevice(rawValue: rawValue)
   }

   public func dimension(isLandscape: Bool) -> CGSize {
      let result: CGSize
      switch self {
      case .iPhoneSE_1stGen:
         result = CGSize(width: 320, height: 568)
      case .iPhone11:
         result = CGSize(width: 414, height: 896)
      case .iPad_6thGen:
         result = CGSize(width: 768, height: 1024)
      }
      return isLandscape ? CGSize(width: result.height, height: result.width) : result
   }

   public func safeAreaDimension(isLandscape: Bool) -> CGSize {
      let size = dimension(isLandscape: isLandscape)
      return CGSize(width: size.width, height: size.height - 20) // `20` - status bar area.
   }

   public var previewDisplayName: String {
      let name: String
      switch self {
      case .iPhone11:
         name = rawValue
      case .iPhoneSE_1stGen:
         name = "iPhone SE 1Gen"
      case .iPad_6thGen:
         name = "iPad 6Gen"
      }
      return name
   }
}

@available(iOS 13.0, macOS 10.15, *)
public struct UIPreviewDevice: ViewModifier {

   public let type: UIPreviewDeviceType
   public let shouldShrinkToSafeAreas: Bool
   public let isLandscape: Bool

   public init(type: UIPreviewDeviceType, isLandscape: Bool = false, shouldShrinkToSafeAreas: Bool = false) {
      self.type = type
      self.shouldShrinkToSafeAreas = shouldShrinkToSafeAreas
      self.isLandscape = isLandscape
   }

   public func body(content: Content) -> some SwiftUI.View {
      let dimension = shouldShrinkToSafeAreas ? type.safeAreaDimension(isLandscape: isLandscape) : type.dimension(isLandscape: isLandscape)
      var size = sizeToString(type.dimension(isLandscape: isLandscape))
      if shouldShrinkToSafeAreas {
         size += "/" + sizeToString(type.safeAreaDimension(isLandscape: isLandscape))
      }
      let name = type.previewDisplayName + " (\(size))"
      return content
         .previewDevice(type.device)
         .previewLayout(.fixed(width: dimension.width, height: dimension.height)).previewDisplayName(name)
   }

   private func sizeToString(_ size: CGSize) -> String {
      return "\(Int(size.width))x\(Int(size.height))"
   }
}

@available(iOS 13.0, macOS 10.15, *)
extension SwiftUI.View {
   public func previewDevice(_ type: UIPreviewDeviceType, isLandscape: Bool = false, shouldShrinkToSafeAreas: Bool = false) -> some SwiftUI.View {
      modifier(UIPreviewDevice(type: type, isLandscape: isLandscape, shouldShrinkToSafeAreas: shouldShrinkToSafeAreas))
   }
}

#endif
