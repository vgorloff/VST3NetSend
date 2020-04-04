import AppKit
import Foundation
import Combine
import PlaygroundSupport
import SwiftUI
import AudioToolbox
@testable import VST3NetSendKit

let view = NetSendUI()
view.needsLayout = true
view.layoutSubtreeIfNeeded()

view.fittingSize
view.intrinsicContentSize
view.sizeToFit()
print(view.frame)
DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
   print(view.dump())
   view.intrinsicContentSize
}

view.onChange = {
   print($0)
}

DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
   view.status = kAUNetStatus_Overflow
   view.connectionFlag = 1
   view.password = "ABCD"
   view.bonjourName = "Name"
   view.port = 200
   view.dataFormat = 2
}

PlaygroundPage.current.setLiveView(view)

     
      
                      
     
