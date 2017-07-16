//
//  NetSendView.swift
//  VST3NetSend
//
//  Created by Vlad Gorlov on 25/09/2016.
//  Copyright © 2016 Vlad Gorlov. All rights reserved.
//

import Cocoa

class NetSendView: NSView {

   @IBOutlet weak var status: NSTextField!
   @IBOutlet weak var connectionFlag: NSButton!
   @IBOutlet weak var dataFormat: NSPopUpButton!
   @IBOutlet weak var port: NSTextField!
   @IBOutlet weak var bonjourName: NSTextField!
   @IBOutlet weak var password: NSSecureTextField!

   override func draw(_ dirtyRect: NSRect) {
      NSColor.controlColor.setFill()
      dirtyRect.fill()
   }
}
