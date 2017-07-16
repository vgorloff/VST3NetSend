//
//  AudioComponentInstantiationOptions.swift
//  WL
//
//  Created by Vlad Gorlov on 10.07.17.
//  Copyright © 2017 WaveLabs. All rights reserved.
//

import AudioUnit

extension AudioComponentInstantiationOptions: CustomReflectable {

   public var customMirror: Mirror {
      #if os(OSX)
      if #available(OSX 10.11, *) {
         let children: Array<Mirror.Child> = [
            ("rawValue", rawValue),
            ("LoadInProcess", contains(AudioComponentInstantiationOptions.loadInProcess)),
            ("LoadOutOfProcess", contains(AudioComponentInstantiationOptions.loadOutOfProcess))
         ]
         return Mirror(self, children: children)
      } else {
         let children: Array<Mirror.Child> = [
            ("rawValue", rawValue)
         ]
         return Mirror(self, children: children)
      }
      #elseif os(iOS)
      let children: Array<Mirror.Child> = [
         ("rawValue", rawValue),
         ("LoadOutOfProcess", contains(AudioComponentInstantiationOptions.loadOutOfProcess))
      ]
      return Mirror(self, children: children)
      #endif
   }
}
