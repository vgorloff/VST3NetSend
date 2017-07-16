//
//  NetSendAU.swift
//  VST3NetSendKit
//
//  Created by Vlad Gorlov on 15.07.17.
//  Copyright © 2017 Vlad Gorlov. All rights reserved.
//

import AVFoundation

public final class NetSendAU: NSObject {

   private var au: AVAudioUnit?
   private var timeStamp = AudioTimeStamp()
   private var isActive: Bool = false
   private var buffer: AVAudioPCMBuffer?
   private var sampleRate: Double = 44100
   private var blockSize: UInt32 = 512
   private var numberOfChannels: UInt32 = 2
   private var vstBufferList: UnsafeMutablePointer<AudioBufferList>?

   public override init() {
      super.init()
      let desc = AudioComponentDescription(type: kAudioUnitType_Effect, subType: kAudioUnitSubType_NetSend)
      let sema = DispatchSemaphore(value: 1)
      AVAudioUnit.instantiate(with: desc, options: [.loadInProcess]) { [weak self] avAU, error in
         if let e = error {
            Log.error(subsystem: .media, category: .initialise, error: e)
         } else if let avAU = avAU {
            self?.au = avAU
         } else {
            fatalError()
         }
         sema.signal()
      }
      if sema.wait(timeout: .now() + 1) == .timedOut {
         Log.info(subsystem: .media, category: .initialise, message: "Timout waiting for `AVAudioUnit.instantiate` callback.")
      }
      timeStamp.mFlags = [.sampleTimeValid]
      timeStamp.mSampleTime = 0

      setTransmissionFormatIndex(kAUNetSendPresetFormat_PCMFloat32)
      setPortNumber(52800)
      setServiceName("WaveLabs VST3NetSend")
      setPassword("")

      setupStreamFormat(sampleRate: sampleRate, blockSize: blockSize, numChannels: numberOfChannels)
      setupRenderCallback()
   }

   deinit {
      setActive(false)
      au = nil
   }
}

extension NetSendAU {

   @objc public func setupProcessing(_ setupInfo: NetSendProcessSetup) {
      sampleRate = setupInfo.sampleRate
      blockSize = setupInfo.maxSamplesPerBlock
      setupStreamFormat(sampleRate: sampleRate, blockSize: blockSize, numChannels: numberOfChannels)
   }

   @objc public func setActive(_ shouldActivate: Bool) {
      guard let au = au?.audioUnit else {
         return
      }
      if shouldActivate && !isActive {
         guard AudioUnitInitialize(au) == noErr else {
            Log.error(subsystem: .media, category: .initialise, message: "Unable to initialize AUNetSend instance.")
            return
         }
         isActive = true
      } else if isActive {
         guard AudioUnitUninitialize(au) == noErr else {
            Log.error(subsystem: .media, category: .initialise, message: "Unable to uninitialize AUNetSend instance.")
            return
         }
         isActive = false
      }
   }

   @objc public func render(numberOfFrames: UInt32, bufferList: UnsafeMutablePointer<AudioBufferList>) {
      guard let au = au?.audioUnit, let buffer = buffer else {
         return
      }
      assert(numberOfFrames <= buffer.frameCapacity)
      buffer.frameLength = numberOfFrames
      vstBufferList = bufferList
      var actionFlags = AudioUnitRenderActionFlags(rawValue: 0)
      let status = AudioUnitRender(au, &actionFlags, &timeStamp, 0, numberOfFrames, buffer.mutableAudioBufferList)
      assert(status == noErr)
      timeStamp.mSampleTime += Float64(numberOfFrames)
   }

   @objc public func setNumberOfChannels(_ numChannels: UInt32) {
      numberOfChannels = numChannels
      setupStreamFormat(sampleRate: sampleRate, blockSize: blockSize, numChannels: numberOfChannels)
   }

   @objc public func setServiceName(_ serviceName: String) {
      guard let au = au?.audioUnit else {
         return
      }
      setProperty("ServiceName") {
         try AudioUnitSettings.setProperty(for: au, propertyID: kAUNetSendProperty_ServiceName,
                                           scope: .global, element: 0, data: (serviceName as CFString))
      }
   }

   @objc public func setPassword(_ password: String) {
      guard let au = au?.audioUnit else {
         return
      }
      setProperty("Password") {
         try AudioUnitSettings.setProperty(for: au, propertyID: kAUNetSendProperty_Password,
                                           scope: .global, element: 0, data: (password as CFString))
      }
   }

   @objc public func setTransmissionFormatIndex(_ formatIndex: UInt32) {
      guard let au = au?.audioUnit else {
         return
      }
      assert(formatIndex < kAUNetSendNumPresetFormats)
      setProperty("TransmissionFormatIndex") {
         try AudioUnitSettings.setProperty(for: au, propertyID: kAUNetSendProperty_TransmissionFormatIndex,
                                           scope: .global, element: 0, data: formatIndex)
      }
   }

   @objc public func setDisconnect(_ flag: UInt32) {
      guard let au = au?.audioUnit else {
         return
      }
      setProperty("Disconnect") {
         try AudioUnitSettings.setProperty(for: au, propertyID: kAUNetSendProperty_Disconnect,
                                           scope: .global, element: 0, data: flag)
      }
   }

   @objc public func setPortNumber(_ port: UInt32) {
      guard let au = au?.audioUnit else {
         return
      }
      setProperty("PortNum") {
         try AudioUnitSettings.setProperty(for: au, propertyID: kAUNetSendProperty_PortNum,
                                           scope: .global, element: 0, data: port)
      }
   }

   @objc public func getStatus() -> Int {
      var result: Float32 = -1
      guard let au = au?.audioUnit else {
         return Int(result)
      }
      getParameter("Status") {
         result = try AudioUnitSettings.getParameter(for: au, parameterID: kAUNetSendParam_Status, scope: .global, element: 0)
      }
      return Int(result)
   }
}

extension NetSendAU {

   private func setProperty(_ name: String, closure: () throws -> Void) {
      do {
         try closure()
      } catch {
         Log.error(subsystem: .media, category: .event, message: "Unable to set property `\(name)`.")
      }
   }

   private func getParameter(_ name: String, closure: () throws -> Void) {
      do {
         try closure()
      } catch {
         Log.error(subsystem: .media, category: .event, message: "Unable to get parameter `\(name)`.")
      }
   }

   private func setupRenderCallback() {
      guard let au = au?.audioUnit else {
         return
      }
      let context = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
      let callback = AURenderCallbackStruct(inputProc: renderCallback, inputProcRefCon: context)
      setProperty("SetRenderCallback") {
         try AudioUnitSettings.setProperty(for: au, propertyID: kAudioUnitProperty_SetRenderCallback,
                                           scope: .input, element: 0, data: callback)
      }
   }

   fileprivate func render(flags: UnsafeMutablePointer<AudioUnitRenderActionFlags>, timestamp: UnsafePointer<AudioTimeStamp>,
                           busNumber: UInt32, numberOfFrames: UInt32, data: UnsafeMutablePointer<AudioBufferList>?) -> OSStatus {
      guard let vstBufferList = vstBufferList, let data = data else {
         return kAudioUnitErr_Uninitialized
      }
      let ablVST = UnsafeMutableAudioBufferListPointer(vstBufferList)
      let ablAU = UnsafeMutableAudioBufferListPointer(data)
      guard ablVST.count == ablAU.count else {
         return kAudioUnitErr_FormatNotSupported
      }
      for index in 0 ..< ablVST.count {
         let abVST = ablVST[index]
         let abAU = ablAU[index]
         assert(abAU.mDataByteSize == abVST.mDataByteSize)
         memcpy(abAU.mData, abVST.mData, Int(abAU.mDataByteSize))
      }
      return noErr
   }

   private func setupStreamFormat(sampleRate: Double, blockSize: UInt32, numChannels: UInt32) {
      guard let au = au?.audioUnit else {
         return
      }
      guard let format = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: sampleRate,
                                       channels: numChannels, interleaved: false) else {
         fatalError()
      }
      let sd = format.streamDescription.pointee
      setProperty("StreamFormat (Input)") {
         try AudioUnitSettings.setProperty(for: au, propertyID: kAudioUnitProperty_StreamFormat, scope: .input,
                                           element: 0, data: sd)
      }
      setProperty("StreamFormat (Output)") {
         try AudioUnitSettings.setProperty(for: au, propertyID: kAudioUnitProperty_StreamFormat, scope: .output,
                                           element: 0, data: sd)
      }

      guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: blockSize) else {
         fatalError()
      }
      self.buffer = buffer
   }
}

private let renderCallback: AURenderCallback = { inRefCon, ioActionFlags, inTimeStamp, inBusNumber, inNumberFrames, ioData in
   let thisRef: Unmanaged<NetSendAU> = Unmanaged.fromOpaque(inRefCon)
   let this = thisRef.takeUnretainedValue()
   return this.render(flags: ioActionFlags, timestamp: inTimeStamp, busNumber: inBusNumber,
                      numberOfFrames: inNumberFrames, data: ioData)
}
