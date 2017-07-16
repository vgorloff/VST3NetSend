//
//  NetSendParameter.swift
//  VST3NetSend
//
//  Created by Vlad Gorlov on 16.07.17.
//  Copyright © 2017 Vlad Gorlov. All rights reserved.
//

import Foundation

@objc public enum NetSendParameter: Int {
   case dataFormat, port, bonjourName, password, connectionFlag
}
