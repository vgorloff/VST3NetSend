//
//  NetSendUI.Previews.swift
//  VST3NetSendKit
//
//  Created by Vlad Gorlov on 07.02.21.
//  Copyright © 2021 WaveLabs. All rights reserved.
//

import SwiftUI
import mcUIPreviews
import mcTypes
import AudioToolbox

@available(macOS 11.0, *)
struct NetSendUI_Previews: PreviewProvider {

   static func makeView() -> NetSendUI {
      let view = NetSendUI()
      view.status = kAUNetStatus_Overflow
      view.connectionFlag = 1
      view.password = "ABCD"
      view.bonjourName = "Name"
      view.port = 200
      view.dataFormat = 2
      view.needsLayout = true
      view.layoutSubtreeIfNeeded()
      view.sizeToFittingSize()
      return view
   }

   static var previews: some SwiftUI.View {
      return Group {
         UIViewPreview {
            makeView()
         }.previewLayout(.sizeThatFits).previewDevice("Mac").preferredColorScheme(.light)
         UIViewPreview {
            makeView()
         }.previewLayout(.sizeThatFits).previewDevice("Mac").preferredColorScheme(.dark)
      }
   }
}
