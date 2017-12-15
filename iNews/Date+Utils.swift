//
//  Date+Utils.swift
//  iNews
//
//  Created by Ashish Bansal on 12/14/17.
//  Copyright © 2017 iNews. All rights reserved.
//

import Foundation

public extension Date {
    
    /**
     Convert NSDate to a String in specified format
     
     - Parameter formatString: The format for the output date
     - Returns: Formated String for the Date.
     */
    func convertToFormat(formatString: String) -> String {
        return Formatter.create(formatString: formatString).string(from: self)
    }
    
    /**
     Adds the specified number of days to self.
     
     - Parameter days: The number of days to add.
     - Returns: The Date after adding days.
     */
    func dateByAddingDays(days: Int) -> Date? {
        var dateComponent = DateComponents()
        dateComponent.day = days
        let calendar = NSCalendar.current
        return calendar.date(byAdding: dateComponent, to: self)
    }
    
    /// The ISO8601 standard format string for this date.
    var iso8601Date: String {
        return Formatter.iso8601.string(from: self)
    }
    
    public struct Formatter {
        
        public static let iso8601: DateFormatter = {
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: Calendar.Identifier.iso8601)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"
            return formatter
        } ()
        
        public static func create(formatString: String) -> DateFormatter {
            let formatter = DateFormatter()
            formatter.dateFormat = formatString
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            return formatter
        }
    }
}

public extension String {
    
    /// The Date from a ISO8601 standard format stirng.
    var dateFromISO8601: Date? {
        return Date.Formatter.iso8601.date(from: self)
    }
}
