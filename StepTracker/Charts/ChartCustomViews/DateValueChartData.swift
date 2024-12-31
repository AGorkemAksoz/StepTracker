//
//  ChartDataTypes.swift
//  StepTracker
//
//  Created by Gorkem on 26.11.2024.
//

import Foundation

struct DateValueChartData: Identifiable, Equatable {
    let id = UUID()
    let date: Date
    let value: Double
}
