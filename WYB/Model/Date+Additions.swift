//
//  Date+Additions.swift
//  WYB
//
//  Created by Priscilla Okawa on 6/9/18.
//  Copyright © 2018 Priscilla Okawa. All rights reserved.
//

import Foundation

extension String {
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
        return dateFormatter.date(from: self)
    }
}
