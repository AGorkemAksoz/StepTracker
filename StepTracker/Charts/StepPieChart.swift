//
//  StepPieChart.swift
//  StepTracker
//
//  Created by Gorkem on 29.11.2024.
//

import Charts
import SwiftUI

struct StepPieChart: View {
    
    var chartData: [WeekdayChartData]
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack {
                Label("Averages", systemImage: "calendar")
                    .font(.title3).bold()
                    .foregroundStyle(.pink)
                
                Text("Last 28 Days")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Chart {
                ForEach(chartData) { weekday in
                    SectorMark(angle: .value("Average Steps", weekday.value),
                               innerRadius: .ratio(0.618),
                               angularInset: 1)
                    .foregroundStyle(.pink.gradient)
                    .cornerRadius(6)
                }
            }
            .frame(height: 240)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
    }
}

#Preview {
    StepPieChart(chartData: ChartMath.averageWeekdayCount(for: HealthMetric.mockData))
}
