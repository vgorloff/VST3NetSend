//
//  UIViewControllerPreview.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 29.10.19.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
#if !os(macOS)
import Foundation
import UIKit

import SwiftUI

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
      return builder()
   }

   public func updateUIViewController(_ uiViewController: ViewControllerType, context: Context) {
      updateHandler?(uiViewController)
   }
}
#endif
#endif
