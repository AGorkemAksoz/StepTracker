//
//  ChartMath.swift
//  StepTracker
//
//  Created by Gorkem on 26.11.2024.
//

import Algorithms
import Foundation

struct ChartMath {
    
    static func averageWeekdayCount(for metric: [HealthMetric]) -> [DateValueChartData] {
        let sortedByWeekday = metric.sorted(using: KeyPathComparator(\.date.weekdayInt))
        let weekdayArray = sortedByWeekday.chunked { $0.date.weekdayInt == $1.date.weekdayInt }
        
        var weekdayChartData: [DateValueChartData] = []
        
        for array in weekdayArray {
            guard let firsValue = array.first else { continue }
            let total = array.reduce(0) {$0 + $1.value}
            let avgSteps = total/Double(array.count)
            
            weekdayChartData.append(.init(date: firsValue.date, value: avgSteps))
        }
        
        return weekdayChartData
    }
    
    static func averageDailyWeightDiffs(for weights: [HealthMetric]) -> [DateValueChartData] {
        var diffValues: [(date: Date, value: Double)] = []
        
        guard weights.count > 1 else { return []}
        
        for i in 1..<weights.count {
            let date = weights[i].date
            let diff = weights[i].value - weights[i-1].value
            diffValues.append((date: date, value: diff))
        }

        let sortedByWeekday = diffValues.sorted(using: KeyPathComparator(\.date.weekdayInt))
        let weekdayArray = sortedByWeekday.chunked { $0.date.weekdayInt == $1.date.weekdayInt }
        
        var weekdayChartData: [DateValueChartData] = []
        
        for array in weekdayArray {
            guard let firsValue = array.first else { continue }
            let total = array.reduce(0) {$0 + $1.value}
            let avgWeightDiff = total/Double(array.count)
            
            weekdayChartData.append(.init(date: firsValue.date, value: avgWeightDiff))
        }
        
        return weekdayChartData
    }
}
