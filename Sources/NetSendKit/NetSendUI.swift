//
//  NetSendUI.swift
//  VST3NetSend
//
//  Created by Vlad Gorlov on 25.07.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

import Cocoa
import mcUIExtensions
import mcUIReusable
import mcUI
import mcFoundationFormatters
import mcMediaExtensions

@objc public class NetSendUI: NSView {
   
   fileprivate lazy var viewModelObjectController: NSObjectController = NSObjectController(content: self.viewModel)
   @objc public private(set) lazy var viewModel = NetSendViewModel()
   @objc public var modelChangeHandler: ((NetSendParameter) -> Void)?
   fileprivate var observers = [NSKeyValueObservation]()
   
   @objc public var status: Int = 0 {
      didSet {
         let title = AUNetStatus(auNetStatus: status)?.title ?? "Unknown"
         statusValue.text = title
      }
   }
   
   @objc public var connectionFlag: Double = 0 {
      didSet {
         // Value == "0" in AU means "Connected"
         // Value > "0" in AU means "Disconnected"
         // But button should showd opposite title.
         // So, when value not "0" we need to show title "Connect"
         let title = connectionFlag > 0 ? "Connect" : "Disconnect"
         connectionButton.title = title
         connectionButton.doubleValue = connectionFlag
      }
   }
   
   @objc public var password: String {
      get {
         return passwordValue.text
      } set {
         passwordValue.text = newValue
      }
   }
   
   @objc public var bonjourName: String {
      get {
         return bonjourNameValue.text
      } set {
         bonjourNameValue.text = newValue
      }
   }
   
   private lazy var boxTop = Box()
   private lazy var boxOptions = Box()
   
   private lazy var connectionButton = Button()
   
   private lazy var statusLabel = Label(title: "Status:")
   private lazy var statusValue = Label()
   
   private lazy var portLabel = Label(title: "Port:")
   private lazy var port = TextField()
   
   private lazy var dataFormatLabel = Label(title: "Data format:")
   private lazy var dataFormat = PopUpButton()
   
   private lazy var bonjourNameLabel = Label(title: "Bonjour name:")
   private lazy var bonjourNameValue = TextField()
   
   private lazy var passwordLabel = Label(title: "Password:")
   private lazy var passwordValue = SecureTextField()
   
   private let labelFont = NSFont.systemFont(ofSize: NSFont.systemFontSize(for: .small), weight: .regular)
   
   public override func draw(_ dirtyRect: NSRect) {
      NSColor.controlColor.setFill()
      dirtyRect.fill()
   }

   public override init(frame frameRect: NSRect) {
      super.init(frame: frameRect)
      log.initialize()
      setupUI()
      setupLayout()
      setupBindings()
      setupObservers()
      setupDefaults()
   }
   
   deinit {
      observers.removeAll()
      removeBindings()
      log.deinitialize()
   }

   required init?(coder decoder: NSCoder) {
      fatalError()
   }
   
   private func setupDefaults() {
      status = -1
      connectionFlag = 0
   }
   
   private func setupUI() {
            
      let label = Label(title: "Options")
      label.font = labelFont
      let title = StackView(views: label, NSView())
      title.edgeInsets = NSEdgeInsets(horizontal: 4)
      let stackView = StackView(axis: .vertical)
      stackView.addArrangedSubviews(boxTop, title, boxOptions)
      stackView.spacing = 6
      stackView.setCustomSpacing(2, after: title)
      
      addSubviews(stackView)
      LayoutConstraint.pin(to: .insets(.init(dimension: 15)), stackView).activate()
      
      let stackViewOptions = StackView(axis: .vertical)
      stackViewOptions.spacing = 6
      stackViewOptions.translatesAutoresizingMaskIntoConstraints = true
      
      boxOptions.borderType = .lineBorder
      boxOptions.titlePosition = .noTitle
      boxOptions.contentView = stackViewOptions
      boxOptions.contentViewMargins = NSSize(squareSide: 8)
      
      let stackViewTop = StackView(axis: .vertical)
      stackViewTop.spacing = 6
      stackViewTop.translatesAutoresizingMaskIntoConstraints = true
      
      boxTop.borderType = .lineBorder
      boxTop.titlePosition = .noTitle
      boxTop.contentView = stackViewTop
      boxTop.contentViewMargins = NSSize(squareSide: 8)
      
      LayoutConstraint.equalWidth(viewA: boxOptions, viewB: boxTop).activate()
      
      connectionButton.controlSize = .small
      connectionButton.font = labelFont
      connectionButton.setButtonType(.toggle)
      
      passwordLabel.alignment = .right
      passwordLabel.font = labelFont
      passwordLabel.usesSingleLineMode = true
      
      passwordValue.controlSize = .small
      passwordValue.font = labelFont
      passwordValue.cell?.sendsActionOnEndEditing = true
      
      portLabel.alignment = .right
      portLabel.font = labelFont
      portLabel.usesSingleLineMode = true
      
      port.controlSize = .small
      port.font = labelFont
      port.cell?.sendsActionOnEndEditing = true
      port.cell?.formatter = IntegerFormatter()
      
      dataFormatLabel.alignment = .right
      dataFormatLabel.font = labelFont
      dataFormatLabel.usesSingleLineMode = true
      
      dataFormat.controlSize = .small
      dataFormat.font = labelFont
      
      statusLabel.alignment = .right
      statusLabel.font = labelFont
      statusLabel.usesSingleLineMode = true
   
      statusValue.font = labelFont
      
      bonjourNameLabel.alignment = .right
      bonjourNameLabel.font = labelFont
      bonjourNameLabel.usesSingleLineMode = true
      
      bonjourNameValue.controlSize = .small
      bonjourNameValue.font = labelFont
      bonjourNameValue.cell?.sendsActionOnEndEditing = true

      do {
         let stackView = StackView()
         stackView.addArrangedSubviews(bonjourNameLabel, bonjourNameValue)
         stackViewOptions.addArrangedSubviews(stackView)
      }
      do {
         let stackView = StackView()
         stackView.addArrangedSubviews(passwordLabel, passwordValue)
         stackViewOptions.addArrangedSubviews(stackView)
      }
      
      do {
         let stackView = StackView()
         stackView.addArrangedSubviews(statusLabel, statusValue, NSView(), connectionButton)
         stackViewTop.addArrangedSubviews(stackView)
      }
      
      do {
         let stackView = StackView()
         stackView.addArrangedSubviews(portLabel, port)
         stackViewTop.addArrangedSubviews(stackView)
      }
      
      do {
         let stackView = StackView()
         stackView.addArrangedSubviews(dataFormatLabel, dataFormat)
         stackViewTop.addArrangedSubviews(stackView)
      }
      
      let customMenu = NSMenu()
      customMenu.addItem(NSMenuItem(title: "32 bit floating point PCM", tag: 0))
      customMenu.addItem(NSMenuItem(title: "24 bit integer PCM", tag: 1))
      customMenu.addItem(NSMenuItem(title: "16 bit integer PCM", tag: 2))
      customMenu.addItem(NSMenuItem.separator().withTag(-1))
      customMenu.addItem(NSMenuItem(title: "24 bit Apple Lossless", tag: 3))
      customMenu.addItem(NSMenuItem(title: "16 bit Apple Lossless", tag: 4))
      customMenu.addItem(NSMenuItem.separator().withTag(-1))
      customMenu.addItem(NSMenuItem(title: "µ-Law", tag: 5))
      customMenu.addItem(NSMenuItem(title: "IMA 4:1", tag: 6))
      customMenu.addItem(NSMenuItem.separator().withTag(-1))
      customMenu.addItem(NSMenuItem(title: "AAC 128 kbps per channel", tag: 7))
      customMenu.addItem(NSMenuItem(title: "AAC 96 kbps per channel", tag: 8))
      customMenu.addItem(NSMenuItem(title: "AAC 80 kbps per channel", tag: 9))
      customMenu.addItem(NSMenuItem(title: "AAC 64 kbps per channel", tag: 10))
      customMenu.addItem(NSMenuItem(title: "AAC 48 kbps per channel", tag: 11))
      customMenu.addItem(NSMenuItem(title: "AAC 40 kbps per channel", tag: 12))
      customMenu.addItem(NSMenuItem(title: "AAC 32 kbps per channel", tag: 13))
      customMenu.addItem(NSMenuItem.separator().withTag(-1))
      customMenu.addItem(NSMenuItem(title: "AAC Low Delay 64 kbps per channel", tag: 14))
      customMenu.addItem(NSMenuItem(title: "AAC Low Delay 48 kbps per channel", tag: 15))
      customMenu.addItem(NSMenuItem(title: "AAC Low Delay 40 kbps per channel", tag: 16))
      customMenu.addItem(NSMenuItem(title: "AAC Low Delay 32 kbps per channel", tag: 17))
      dataFormat.menu = customMenu
   }
   
   private func setupLayout() {
      LayoutConstraint.equalWidth(viewA: portLabel, viewB: statusLabel).activate()
      LayoutConstraint.equalWidth(viewA: portLabel, viewB: dataFormatLabel).activate()
      LayoutConstraint.equalWidth(viewA: passwordLabel, viewB: dataFormatLabel).activate()
      LayoutConstraint.equalWidth(viewA: bonjourNameLabel, viewB: passwordLabel).activate()
   }
   
   private func setupObservers() {
      observers.append(viewModel.observe(\.dataFormat) { [weak self] _, _ in
         self?.modelChangeHandler?(.dataFormat)
      })
      observers.append(viewModel.observe(\.port) { [weak self] _, _ in
         self?.modelChangeHandler?(.port)
      })
   }

   private func setupBindings() {
      connectionButton.setHandler(self) {
         $0.connectionFlag = $0.connectionButton.doubleValue
         $0.modelChangeHandler?(.connectionFlag)
         log.debug(.media, "Changed \(NetSendParameter.connectionFlag) to value \($0.connectionFlag)")
      }
      passwordValue.setHandler(self) {
         log.debug(.media, "Changed \(NetSendParameter.password) to value \($0.password)")
         $0.modelChangeHandler?(.password)
      }
      bonjourNameValue.setHandler(self) {
         log.debug(.media, "Changed \(NetSendParameter.bonjourName) to value \($0.bonjourName)")
         $0.modelChangeHandler?(.bonjourName)
      }
      let bindingValue = NSBindingName(rawValue: "value")
      dataFormat.bind(NSBindingName(rawValue: "selectedTag"), to: viewModelObjectController,
                                  withKeyPath: "selection.dataFormat", options: nil)
      port.bind(bindingValue, to: viewModelObjectController,
                            withKeyPath: "selection.port", options: nil)
   }

   private func removeBindings() {
      let bindingValue = NSBindingName(rawValue: "value")
      dataFormat.unbind(NSBindingName(rawValue: "selectedTag"))
      port.unbind(bindingValue)
   }
}
