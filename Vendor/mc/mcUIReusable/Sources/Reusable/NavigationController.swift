//
//  NavigationController.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 29.05.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import UIKit

open class NavigationController: UINavigationController {

   public init() {
      super.init(nibName: nil, bundle: nil)
   }

   public override init(rootViewController: UIViewController) {
      super.init(nibName: nil, bundle: nil)
      setViewControllers([rootViewController], animated: false)
   }

   public required init?(coder aDecoder: NSCoder) {
      fatalError()
   }

   open override func viewDidLoad() {
      super.viewDidLoad()
      setupUI()
   }

   @objc open dynamic func setupUI() {
   }
}
#endif
