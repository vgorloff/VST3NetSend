//
//  UIViewControllerPreview.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 29.10.19.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

import SwiftUI

#if !os(macOS)
#if canImport(UIKit)
import Foundation
import UIKit

@available(iOS 13.0, *)
public struct UIViewControllerPreview<ViewControllerType: UIViewController>: UIViewControllerRepresentable {

   public let builder: () -> ViewControllerType
   public var updateHandler: ((ViewControllerType) -> Void)?

   public init(_ builder: @escaping () -> ViewControllerType, _ updateHandler: ((ViewControllerType) -> Void)? = nil) {
      PreviewFontRegistration.registerCustomFonts()
      self.builder = builder
      self.updateHandler = updateHandler
   }

   // MARK: - UIViewControllerRepresentable

   public func makeUIViewController(context: Context) -> ViewControllerType {
      let vc = builder()
      // Below lines seems does nothing.
      // vc.view.setContentHuggingPriority(.defaultHigh, for: .vertical)
      // vc.view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
      return vc
   }

   public func updateUIViewController(_ uiViewController: ViewControllerType, context: Context) {
      updateHandler?(uiViewController)
   }
}
#endif
#else // macOS
@available(macOS 10.15, *)
public struct UIViewControllerPreview<ViewControllerType: NSViewController>: NSViewControllerRepresentable {

   private let builder: () -> ViewControllerType
   private let updateHandler: ((ViewControllerType) -> Void)?

   public init(_ builder: @escaping () -> ViewControllerType, _ updateHandler: ((ViewControllerType) -> Void)? = nil) {
      PreviewFontRegistration.registerCustomFonts()
      self.builder = builder
      self.updateHandler = updateHandler
   }

   // MARK: - NSViewControllerRepresentable

   public func makeNSViewController(context: Context) -> ViewControllerType {
      let vc = builder()
      // Below lines seems does nothing.
      // vc.view.setContentHuggingPriority(.defaultHigh, for: .vertical)
      // vc.view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
      return vc
   }

   public func updateNSViewController(_ nsViewController: ViewControllerType, context: Context) {
      nsViewController.preferredContentSize = CGSize(width: NSView.noIntrinsicMetric, height: NSView.noIntrinsicMetric)
      nsViewController.view.wantsLayer = true
      nsViewController.view.layer?.borderWidth = 1 / (NSScreen.main?.backingScaleFactor ?? 1)
      nsViewController.view.layer?.borderColor = NSColor.magenta.cgColor
      updateHandler?(nsViewController)
   }
}
#endif
