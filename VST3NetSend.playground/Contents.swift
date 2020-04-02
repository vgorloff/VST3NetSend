import AppKit
import Foundation
import Combine
import PlaygroundSupport
import SwiftUI
@testable import VST3NetSendKit

let vc = NetSendViewController()
vc.view.needsLayout = true
vc.view.layoutSubtreeIfNeeded()

vc.view.fittingSize
vc.view.intrinsicContentSize
vc.view.sizeToFit()
print(vc.view.frame)
DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
   print(vc.view.dump())
   vc.view.intrinsicContentSize
}

PlaygroundPage.current.setLiveView(vc)


   
               
 
