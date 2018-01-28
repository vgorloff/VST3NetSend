//
//  NetSendViewController.swift
//  VST3NetSend
//
//  Created by Vlad Gorlov on 25/09/2016.
//  Copyright © 2016 Vlad Gorlov. All rights reserved.
//

import Cocoa

public class NetSendViewController: NSViewController {

   fileprivate lazy var viewModelObjectController: NSObjectController = NSObjectController(content: self.viewModel)
   @objc public private(set) lazy var viewModel = NetSendViewModel()
   @objc public var modelChangeHandler: ((NetSendParameter) -> Void)?

   fileprivate var observers = [NSKeyValueObservation]()

   public required init?(coder: NSCoder) {
      super.init(coder: coder)
      Log.initialize(subsystem: .controller)
   }

   public override func awakeFromNib() {
      super.awakeFromNib()
      setupBindings()
      setupObservers()
      if let view = view as? NetSendView {
         view.port.cell?.formatter = IntegerFormatter()
      }
   }

   deinit {
      observers.removeAll()
      removeBindings()
      Log.deinitialize(subsystem: .controller)
   }

   private func setupObservers() {
      observers.append(viewModel.observe(\.dataFormat) { [weak self] _, _ in
         self?.modelChangeHandler?(.dataFormat)
      })
      observers.append(viewModel.observe(\.connectionFlag) { [weak self] _, _ in
         self?.modelChangeHandler?(.connectionFlag)
      })
      observers.append(viewModel.observe(\.port) { [weak self] _, _ in
         self?.modelChangeHandler?(.port)
      })
      observers.append(viewModel.observe(\.bonjourName) { [weak self] _, _ in
         self?.modelChangeHandler?(.bonjourName)
      })
      observers.append(viewModel.observe(\.password) { [weak self] _, _ in
         self?.modelChangeHandler?(.password)
      })
   }

   private func setupBindings() {
      if let view = view as? NetSendView {
         let connectionButtonTitleBindingOptions = [NSBindingOption.valueTransformer: ConnectionFlagValueTransformer()]
         let connectionStatusBindingOptions = [NSBindingOption.valueTransformer: ConnectionStatusValueTransformer()]
         let bindingOptions = [NSBindingOption.nullPlaceholder: ""]

         view.status.bind(NSBindingName(rawValue: "value"), to: viewModelObjectController,
                          withKeyPath: "selection.status", options: connectionStatusBindingOptions)
         view.connectionFlag.bind(NSBindingName(rawValue: "value"), to: viewModelObjectController,
                                  withKeyPath: "selection.connectionFlag", options: nil)
         view.connectionFlag.bind(NSBindingName(rawValue: "title"), to: viewModelObjectController,
                                  withKeyPath: "selection.connectionFlag", options: connectionButtonTitleBindingOptions)
         view.dataFormat.bind(NSBindingName(rawValue: "selectedTag"), to: viewModelObjectController,
                              withKeyPath: "selection.dataFormat", options: nil)
         view.port.bind(NSBindingName(rawValue: "value"), to: viewModelObjectController,
                        withKeyPath: "selection.port", options: nil)
         view.bonjourName.bind(NSBindingName(rawValue: "value"), to: viewModelObjectController,
                               withKeyPath: "selection.bonjourName", options: bindingOptions)
         view.password.bind(NSBindingName(rawValue: "value"), to: viewModelObjectController,
                            withKeyPath: "selection.password", options: bindingOptions)
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
