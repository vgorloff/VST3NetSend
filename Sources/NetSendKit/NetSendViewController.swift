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
   private lazy var netSendView = NetSendView()

   public init() {
      super.init(nibName: nil, bundle: nil)
      Log.initialize(subsystem: .controller)
   }

   public override func loadView() {
      view = netSendView
   }

   public required init?(coder: NSCoder) {
      fatalError()
   }

   public override func viewDidLoad() {
      super.viewDidLoad()
      setupBindings()
      setupObservers()
      netSendView.port.cell?.formatter = IntegerFormatter()
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
      let connectionButtonTitleBindingOptions = [NSBindingOption.valueTransformer: ConnectionFlagValueTransformer()]
      let connectionStatusBindingOptions = [NSBindingOption.valueTransformer: ConnectionStatusValueTransformer()]
      let bindingOptions = [NSBindingOption.nullPlaceholder: ""]

      let bindingValue = NSBindingName(rawValue: "value")
      netSendView.status.bind(bindingValue, to: viewModelObjectController,
                              withKeyPath: "selection.status", options: connectionStatusBindingOptions)
      netSendView.connectionFlag.bind(NSBindingName(rawValue: "title"), to: viewModelObjectController,
                                      withKeyPath: "selection.connectionFlag", options: connectionButtonTitleBindingOptions)
      netSendView.connectionFlag.bind(bindingValue, to: viewModelObjectController,
                                      withKeyPath: "selection.connectionFlag", options: nil)
      netSendView.dataFormat.bind(NSBindingName(rawValue: "selectedTag"), to: viewModelObjectController,
                                  withKeyPath: "selection.dataFormat", options: nil)
      netSendView.port.bind(bindingValue, to: viewModelObjectController,
                            withKeyPath: "selection.port", options: nil)
      netSendView.bonjourName.bind(bindingValue, to: viewModelObjectController,
                                   withKeyPath: "selection.bonjourName", options: bindingOptions)
      netSendView.password.bind(bindingValue, to: viewModelObjectController,
                                withKeyPath: "selection.password", options: bindingOptions)
   }

   private func removeBindings() {
      let bindingValue = NSBindingName(rawValue: "value")
      netSendView.status.unbind(bindingValue)
      netSendView.connectionFlag.unbind(bindingValue)
      netSendView.connectionFlag.unbind(NSBindingName(rawValue: "title"))
      netSendView.dataFormat.unbind(NSBindingName(rawValue: "selectedTag"))
      netSendView.port.unbind(bindingValue)
      netSendView.bonjourName.unbind(bindingValue)
      netSendView.password.unbind(bindingValue)
   }
}
