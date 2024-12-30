//
//  Array+Ext.swift
//  StepTracker
//
//  Created by Gorkem on 30.12.2024.
//

import Foundation

extension Array where Element == Double {
    var average: Double {
        guard !self.isEmpty else { return 0}
        let total = self.reduce(0, +)
        return total/Double(self.count)
    }
}
