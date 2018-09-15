//
//  DateFormatter+Additions.swift
//  WYB
//
//  Created by Priscilla Okawa on 14/9/18.
//  Copyright © 2018 Priscilla Okawa. All rights reserved.
//

import Foundation

// Credit: https://useyourloaf.com/blog/swift-codable-with-custom-dates/
extension DateFormatter {
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
//        2018-12-09T00:00:00.000Z
//        yyyy-MM-ddTHH:mm:ss.SSSZ
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
