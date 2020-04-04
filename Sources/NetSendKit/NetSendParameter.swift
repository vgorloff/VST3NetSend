//
//  NetSendParameter.swift
//  VST3NetSend
//
//  Created by Vlad Gorlov on 16.07.17.
//  Copyright © 2017 Vlad Gorlov. All rights reserved.
//

import Foundation

@objc public enum NetSendParameter: Int, CustomStringConvertible {
   
   case dataFormat, port, bonjourName, password, connectionFlag
   
   public var description: String {
      switch self {
      case .bonjourName:
         return "bonjourName"
      case .connectionFlag:
         return "connectionFlag"
      case .dataFormat:
         return "dataFormat"
      case .port:
         return "port"
      case .password:
         return "password"
      }
   }
}
