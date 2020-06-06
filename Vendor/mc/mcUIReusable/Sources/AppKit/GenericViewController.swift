//
//  GenericViewController.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 08.06.18.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
import mcTypes

open class GenericViewController<T: NSView>: NSViewController {

   public let contentView = T()
   private let layoutUntil = DispatchUntil()

   open override func loadView() {
      view = contentView
   }

   public init() {
      super.init(nibName: nil, bundle: nil)
   }

   public required init?(coder: NSCoder) {
      fatalError()
   }

   open override func viewDidLayout() {
      super.viewDidLayout()
      layoutUntil.performIfNeeded {
         setupLayoutDefaults()
      }
   }

   open override func viewDidAppear() {
      super.viewDidAppear()
      layoutUntil.fulfill()
      view.assertOnAmbiguityInSubviewsLayout()
   }

   open override func viewDidLoad() {
      super.viewDidLoad()
      setupUI()
      setupLayout()
      setupDatasource()
      setupHandlers()
      setupDefaults()
   }

   open func setupUI() {
   }

   open func setupLayout() {
   }

   open func setupHandlers() {
   }

   open func setupDefaults() {
   }

   open func setupDatasource() {
   }

   open func setupLayoutDefaults() {
   }
}
#endif
