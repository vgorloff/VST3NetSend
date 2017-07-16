//
//  NetSendProcessSetup.swift
//  VST3NetSendKit
//
//  Created by Vlad Gorlov on 15.07.17.
//  Copyright © 2017 Vlad Gorlov. All rights reserved.
//

import Foundation

public final class NetSendProcessSetup: NSObject {

   @objc public private (set) var sampleRate: Double = 44100
   @objc public private (set) var maxSamplesPerBlock: UInt32 = 512

   public override init() {
      super.init()
   }

   @objc public init(sampleRate: Double, maxSamplesPerBlock: UInt32) {
      self.sampleRate = sampleRate
      self.maxSamplesPerBlock = maxSamplesPerBlock
      super.init()
   }

}
