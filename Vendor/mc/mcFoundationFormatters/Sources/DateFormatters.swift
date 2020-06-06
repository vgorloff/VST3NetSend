//
//  DateFormatters.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 03.06.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

import Foundation

public class DateFormatters {

   public static let sharedInstance = DateFormatter()

   public let formatterISO8601Extended: DateFormatter
   public let formatterISO8601: DateFormatter
   public let formatterDay: DateFormatter
   public let formatterMonth: DateFormatter
   public let formatterWeekdayDate: DateFormatter
   public let formatterShortDate: DateFormatter
   public let formatterFullDate: DateFormatter
   public let formatterTime: DateFormatter

   public let formatterShortDateTime: DateFormatter

   public static let longDateFormatter: DateFormatter = {
      let formatter = DateFormatter()
      formatter.timeStyle = .none
      formatter.dateStyle = .long
      return formatter
   }()

   public static let shortTimeFormatter: DateFormatter = {
      let formatter = DateFormatter()
      formatter.timeStyle = .short
      formatter.dateStyle = .none
      return formatter
   }()

   fileprivate init() {
      // Parsing formatter for date strings from server, need to use the locale from the server
      formatterISO8601Extended = DateFormatter()
      formatterISO8601Extended.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
      formatterISO8601Extended.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

      formatterISO8601 = DateFormatter()
      formatterISO8601.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
      formatterISO8601.dateFormat = "yyyy-MM-dd"

      // Display formatter for NSDates, should use current locale of user

      formatterDay = DateFormatter()
      formatterDay.dateFormat = "dd."
      formatterMonth = DateFormatter()
      formatterMonth.dateFormat = "MMM"
      formatterWeekdayDate = DateFormatter()
      formatterWeekdayDate.dateFormat = "EEEE, dd.MMMM"
      formatterShortDate = DateFormatter()
      formatterShortDate.dateFormat = "dd.MM.yyyy"
      formatterFullDate = DateFormatter()
      formatterFullDate.dateFormat = "EE dd.MM.yyyy"
      formatterTime = DateFormatter()
      formatterTime.dateFormat = "HH:mm"

      formatterShortDateTime = DateFormatter()
      formatterShortDateTime.dateStyle = .short
      formatterShortDateTime.timeStyle = .short
   }
}
