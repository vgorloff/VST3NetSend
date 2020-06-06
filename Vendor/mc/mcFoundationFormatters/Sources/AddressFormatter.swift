//
//  AddressFormatter.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 03.06.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

import Foundation
#if os(iOS) || os(OSX) || os(watchOS)
import Contacts

public class AddressFormatter {

   private let countryCode: String
   private let separator: String

   private let formatter = CNPostalAddressFormatter()

   public init(countryCode: String, separator: String = ", ") {
      self.countryCode = countryCode
      self.separator = separator
   }
}

extension AddressFormatter {

   public func format(house: String? = nil,
                      street: String? = nil,
                      zip: String? = nil,
                      city: String? = nil,
                      country: String? = nil) -> String {
      let postalAddress = CNMutablePostalAddress()
      if var street = street {
         if let house = house {
            street = isHouseNumberBeforeStreet ? "\(house) \(street)" : "\(street) \(house)"
         }
         postalAddress.street = street
      }
      postalAddress.city = city ?? ""
      postalAddress.postalCode = zip ?? ""
      postalAddress.country = country ?? ""

      postalAddress.isoCountryCode = countryCode

      let result = formatter.string(from: postalAddress).trimmingCharacters(in: .whitespacesAndNewlines)
      let components = result.components(separatedBy: "\n").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
      return components.joined(separator: separator)
   }
}

extension AddressFormatter {

   // See details: https://en.wikipedia.org/wiki/Address_(geography)
   private var isHouseNumberBeforeStreet: Bool {
      return false // FIXME: Implement me.
   }
}
#endif
