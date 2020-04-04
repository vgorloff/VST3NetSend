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

view.modelChangeHandler = {
   print($0)
}

DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
   view.status = kAUNetStatus_Overflow
}

PlaygroundPage.current.setLiveView(view)

     
      
                      
     
