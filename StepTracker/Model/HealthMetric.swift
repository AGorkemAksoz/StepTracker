//
//  HealthMetric.swift
//  StepTracker
//
//  Created by Gorkem on 25.11.2024.
//

import Foundation

struct HealthMetric: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
}
