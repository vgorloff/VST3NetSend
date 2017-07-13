//
//  NetSendViewController.swift
//  VST3NetSend
//
//  Created by Vlad Gorlov on 25/09/2016.
//  Copyright © 2016 Vlad Gorlov. All rights reserved.
//

import Cocoa

open class NetSendViewController: NSViewController {

   @objc open lazy var viewModelObjectController: NSObjectController = NSObjectController(content: self.viewModel)
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
         let connectionButtonTitleBindingOptions = [NSBindingOption.valueTransformer: ConnectionFlagValueTransformer()]
         let connectionStatusBindingOptions = [NSBindingOption.valueTransformer: ConnectionStatusValueTransformer()]
         let bindingOptions = [NSBindingOption.nullPlaceholder: ""]

         view.status.bind(NSBindingName(rawValue: "value"), to: viewModelObjectController, withKeyPath: "selection.status", options: connectionStatusBindingOptions)
         view.connectionFlag.bind(NSBindingName(rawValue: "value"), to: viewModelObjectController, withKeyPath: "selection.connectionFlag", options: nil)
         view.connectionFlag.bind(NSBindingName(rawValue: "title"), to: viewModelObjectController, withKeyPath: "selection.connectionFlag", options: connectionButtonTitleBindingOptions)
         view.dataFormat.bind(NSBindingName(rawValue: "selectedTag"), to: viewModelObjectController, withKeyPath: "selection.dataFormat", options: nil)
         view.port.bind(NSBindingName(rawValue: "value"), to: viewModelObjectController, withKeyPath: "selection.port", options: nil)
         view.bonjourName.bind(NSBindingName(rawValue: "value"), to: viewModelObjectController, withKeyPath: "selection.bonjourName", options: bindingOptions)
         view.password.bind(NSBindingName(rawValue: "value"), to: viewModelObjectController, withKeyPath: "selection.password", options: bindingOptions)
      }
   }

   private func removeBindings() {
      if let view = view as? NetSendView {
         view.status.unbind(NSBindingName(rawValue: "value"))
         view.connectionFlag.unbind(NSBindingName(rawValue: "value"))
         view.dataFormat.unbind(NSBindingName(rawValue: "selectedTag"))
         view.port.unbind(NSBindingName(rawValue: "value"))
         view.bonjourName.unbind(NSBindingName(rawValue: "value"))
         view.password.unbind(NSBindingName(rawValue: "value"))
      }
   }
}
