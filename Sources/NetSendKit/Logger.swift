//
//  Logger.swift
//  VST3NetSend
//
//  Created by Vlad Gorlov on 04.08.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

import Foundation
import mcxFoundationLogging

enum ModuleLogCategory: String, LogCategory {
   case media, core
}

let log = Log<ModuleLogCategory>(subsystem: "netSend")
