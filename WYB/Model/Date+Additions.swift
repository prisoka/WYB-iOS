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
//        dateFormatter.dateFormat = "MM-dd-yyyy" //"yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
//        return dateFormatter.date(from: self)
//    }
//}

extension Date {
    func toFormattedString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM'-'dd'-'yyyy"
        
        return dateFormatter.string(from: self)
    }
}

extension String {
    func toFormattedTimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        
        if let date = dateFormatter.date(from: self) {
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "K:mm a"
            return timeFormatter.string(from: date)
        } else{
            return ""
        }
    }
}
