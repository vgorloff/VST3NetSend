//
//  NetSendView.swift
//  VST3NetSend
//
//  Created by Vlad Gorlov on 25.07.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

import Cocoa
import mcUIExtensions
import mcUIReusable
import mcUI

class NetSendView: NSView {
   
   private lazy var boxTop = Box()
   private lazy var boxOptions = Box()
   
   private (set) lazy var connectionFlag = Button()
   
   private lazy var statusLabel = Label(title: "Status:")
   private (set) lazy var status = Label()
   
   private lazy var portLabel = Label(title: "Port:")
   private (set) lazy var port = TextField()
   
   private lazy var dataFormatLabel = Label(title: "Data format:")
   private (set) lazy var dataFormat = PopUpButton()
   
   private lazy var bonjourNameLabel = Label(title: "Bonjour name:")
   private (set) lazy var bonjourName = TextField()
   
   private lazy var passwordLabel = Label(title: "Password:")
   private (set) lazy var password = SecureTextField()
   
   private let labelFont = NSFont.systemFont(ofSize: NSFont.systemFontSize(for: .small), weight: .regular)
   
   override func draw(_ dirtyRect: NSRect) {
      NSColor.controlColor.setFill()
      dirtyRect.fill()
   }

   override init(frame frameRect: NSRect) {
      super.init(frame: frameRect)
      setupUI()
      setupLayout()
   }

   required init?(coder decoder: NSCoder) {
      fatalError()
   }
   
   private func setupUI() {
            
      let stackView = StackView(axis: .vertical)
      stackView.addArrangedSubviews(boxTop, boxOptions)
      stackView.spacing = 8
      
      addSubviews(stackView)
      LayoutConstraint.pin(to: .insets(.init(dimension: 15)), stackView).activate()
      
      let stackViewOptions = StackView(axis: .vertical)
      stackViewOptions.translatesAutoresizingMaskIntoConstraints = true
      
      boxOptions.borderType = .lineBorder
      boxOptions.title = "Options"
      boxOptions.contentView = stackViewOptions
      boxOptions.contentViewMargins = NSSize(squareSide: 8)
      
      let stackViewTop = StackView(axis: .vertical)
      stackViewTop.translatesAutoresizingMaskIntoConstraints = true
      
      boxTop.borderType = .lineBorder
      boxTop.titlePosition = .noTitle
      boxTop.contentView = stackViewTop
      boxTop.contentViewMargins = NSSize(squareSide: 8)
      
      LayoutConstraint.equalWidth(viewA: boxOptions, viewB: boxTop).activate()
      
      connectionFlag.controlSize = .small
      connectionFlag.font = labelFont
      connectionFlag.setButtonType(.toggle)
      
      passwordLabel.alignment = .right
      passwordLabel.font = labelFont
      passwordLabel.usesSingleLineMode = true
      
      password.controlSize = .small
      password.font = labelFont
      //(password.cell as? NSTextFieldCell)?.sendsActionOnEndEditing = true
      
      portLabel.alignment = .right
      portLabel.font = labelFont
      portLabel.usesSingleLineMode = true
      
      port.controlSize = .small
      port.font = labelFont
      //(port.cell as? NSTextFieldCell)?.sendsActionOnEndEditing = true
      
      dataFormatLabel.alignment = .right
      dataFormatLabel.font = labelFont
      dataFormatLabel.usesSingleLineMode = true
      
      dataFormat.controlSize = .small
      dataFormat.font = labelFont
      
      statusLabel.alignment = .right
      statusLabel.font = labelFont
      statusLabel.usesSingleLineMode = true
   
      status.font = labelFont
      
      bonjourNameLabel.alignment = .right
      bonjourNameLabel.font = labelFont
      bonjourNameLabel.usesSingleLineMode = true
      
      bonjourName.controlSize = .small
      bonjourName.font = labelFont

      do {
         let stackView = StackView()
         stackView.addArrangedSubviews(bonjourNameLabel, bonjourName)
         stackViewOptions.addArrangedSubviews(stackView)
      }
      do {
         let stackView = StackView()
         stackView.addArrangedSubviews(passwordLabel, password)
         stackViewOptions.addArrangedSubviews(stackView)
      }
      
      do {
         let stackView = StackView()
         stackView.addArrangedSubviews(statusLabel, status, NSView(), connectionFlag)
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
}
