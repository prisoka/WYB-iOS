//
//  Date+Additions.swift
//  WYB
//
//  Created by Priscilla Okawa on 6/9/18.
//  Copyright © 2018 Priscilla Okawa. All rights reserved.
//

import Foundation

//extension String {
//    func toDate() -> Date? {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
//        return dateFormatter.date(from: self)
//    }
//}

extension String {
    func convertDateFormatter(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"//string date format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        dateFormatter.locale = Locale(identifier: "en_US")
        let convertedDate = dateFormatter.date(from: self)

        guard dateFormatter.date(from: date) != nil else {
            assert(false, "no date from string")
            return ""
        }

        dateFormatter.dateFormat = "MM'-'dd'-'yyyy"// format I want to convert
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let timeStamp = dateFormatter.string(from: convertedDate!)
        print(timeStamp)
        return timeStamp
    }
}
