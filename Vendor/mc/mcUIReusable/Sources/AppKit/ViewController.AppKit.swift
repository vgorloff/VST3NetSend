//
//  ViewController.AppKit.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 03.02.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
import mcTypes
import mcUI

public class __ViewControllerContent: InstanceHolder<ViewController> {

   public var view: View {
      return instance.contentView
   }
}


open class ViewController: NSViewController {

   fileprivate let contentView: View
   private let layoutUntil = DispatchUntil()

   public var content: __ViewControllerContent {
      return __ViewControllerContent(instance: self)
   }

   open override func loadView() {
      view = contentView
   }

   public init() {
      contentView = View()
      contentView.translatesAutoresizingMaskIntoConstraints = true
      super.init(nibName: nil, bundle: nil)
      contentView.onAppearanceDidChanged = { [weak self] in
         self?.setupAppearance($0)
      }
   }

   public init(view: View) {
      view.translatesAutoresizingMaskIntoConstraints = true
      contentView = view
      super.init(nibName: nil, bundle: nil)
      contentView.onAppearanceDidChanged = { [weak self] in
         self?.setupAppearance($0)
      }
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
      setupAppearance(contentView.systemAppearance)
      setupLayout()
      setupHandlers()
      setupDefaults()
   }

   @objc open dynamic func setupUI() {
   }

   @objc open dynamic func setupLayout() {
   }

   @objc open dynamic func setupHandlers() {
   }

   @objc open dynamic func setupDefaults() {
   }

   @objc open dynamic func setupLayoutDefaults() {
   }

   @objc open dynamic func setupAppearance(_: SystemAppearance) {
   }
}
#endif
