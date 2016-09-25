//
//  NetSendViewController.swift
//  VST3NetSend
//
//  Created by Vlad Gorlov on 25/09/2016.
//  Copyright © 2016 Vlad Gorlov. All rights reserved.
//

import Cocoa

open class NetSendViewController: NSViewController {

   open lazy var viewModelObjectController: NSObjectController = NSObjectController(content: self.viewModel)
   private lazy var viewModel = NetSendViewModel()

   open override func awakeFromNib() {
      super.awakeFromNib()
      setupBindings()
      if let view = view as? NetSendView {
         view.port.cell?.formatter = IntegerFormatter()
      }
   }

   deinit {
      removeBindings()
   }

   private func setupBindings() {
      if let view = view as? NetSendView {
         let connectionButtonTitleBindingOptions = [NSValueTransformerBindingOption: ConnectionFlagValueTransformer()]
         let connectionStatusBindingOptions = [NSValueTransformerBindingOption: ConnectionStatusValueTransformer()]
         let bindingOptions = [NSNullPlaceholderBindingOption: ""]

         view.status.bind("value", to: viewModelObjectController, withKeyPath: "selection.status", options: connectionStatusBindingOptions)
         view.connectionFlag.bind("value", to: viewModelObjectController, withKeyPath: "selection.connectionFlag", options: nil)
         view.connectionFlag.bind("title", to: viewModelObjectController, withKeyPath: "selection.connectionFlag", options: connectionButtonTitleBindingOptions)
         view.dataFormat.bind("selectedTag", to: viewModelObjectController, withKeyPath: "selection.dataFormat", options: nil)
         view.port.bind("value", to: viewModelObjectController, withKeyPath: "selection.port", options: nil)
         view.bonjourName.bind("value", to: viewModelObjectController, withKeyPath: "selection.bonjourName", options: bindingOptions)
         view.password.bind("value", to: viewModelObjectController, withKeyPath: "selection.password", options: bindingOptions)
      }
   }

   private func removeBindings() {
      if let view = view as? NetSendView {
         view.status.unbind("value")
         view.connectionFlag.unbind("value")
         view.dataFormat.unbind("selectedTag")
         view.port.unbind("value")
         view.bonjourName.unbind("value")
         view.password.unbind("value")
      }
   }
}
