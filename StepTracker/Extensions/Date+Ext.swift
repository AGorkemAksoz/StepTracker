//
//  Date+Ext.swift
//  StepTracker
//
//  Created by Gorkem on 26.11.2024.
//

import Foundation

extension Date {
    var weekdayInt: Int {
        Calendar.current.component(.weekday, from: self)
    }
}
