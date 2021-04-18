//
//  DateFormatter.swift
//  Project1210
//
//  Created by Ilayda Kodal on 4/18/21.
//

import UIKit

extension Date {
    struct Formatter {
        static let iso8601: DateFormatter = {
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .iso8601)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.dateFormat = "ddmmyyyy"
            return formatter
        }()
    }
    var iso8601: String { return Formatter.iso8601.string(from: self) }
}

extension String {
    var dateFromISO8601: Date? {
        return Date.Formatter.iso8601.date(from: self)
    }
}
