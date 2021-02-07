//
//  UIViewPreview.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 29.10.19.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

import SwiftUI
import Foundation

#if canImport(UIKit)
#if !os(macOS)
import UIKit

public struct UIViewPreview<ViewType: UIView>: UIViewRepresentable {

   public var builder: () -> ViewType
   public var updateHandler: ((ViewType) -> Void)?

   public init(_ builder: @escaping () -> ViewType, _ updateHandler: ((ViewType) -> Void)? = nil) {
      PreviewFontRegistration.registerCustomFonts()
      self.builder = builder
      self.updateHandler = updateHandler
   }

   // MARK: - UIViewRepresentable

   public func makeUIView(context: Context) -> ViewType {
      let view = builder()
      view.setContentHuggingPriority(.defaultHigh, for: .vertical)
      view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
      return view
   }

   public func updateUIView(_ view: ViewType, context: Context) {
      updateHandler?(view)
   }
}
#endif
#endif

#if os(macOS)
public struct UIViewPreview<ViewType: NSView>: NSViewRepresentable {

   public var builder: () -> ViewType
   public var updateHandler: ((ViewType) -> Void)?

   public init(_ builder: @escaping () -> ViewType, _ updateHandler: ((ViewType) -> Void)? = nil) {
      PreviewFontRegistration.registerCustomFonts()
      self.builder = builder
      self.updateHandler = updateHandler
   }

   // MARK: - UIViewRepresentable

   public func makeNSView(context: Context) -> ViewType {
      let view = builder()
      view.setContentHuggingPriority(.defaultHigh, for: .vertical)
      view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
      return view
   }

   public func updateNSView(_ view: ViewType, context: Context) {
      updateHandler?(view)
   }
}
#endif

