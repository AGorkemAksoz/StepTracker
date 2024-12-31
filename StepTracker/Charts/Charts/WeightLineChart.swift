//
//  WeightLineChart.swift
//  StepTracker
//
//  Created by Ali Görkem Aksöz on 30.11.2024.
//

import Charts
import SwiftUI

struct WeightLineChart: View {
    
    @State private var rawSelectedDate: Date?
    @State private var selectedDay: Date?
    
    var chartData: [DateValueChartData]
    
    var minValue: Double {
        chartData.map { $0.value}.min() ?? 0
    }
    
    var selectedData: DateValueChartData? {
        ChartHelper.parseSelectedData(from: chartData, in: rawSelectedDate)
    }
    
    var averageWeight: Double {
        chartData.map { $0.value }.average
    }

    
    var body: some View {
        ChartContainer(config: .init(title: "Weight", symbol: "figure", subtitle: "Avg: \(averageWeight.formatted(.number.precision(.fractionLength(1)))) lbs", context: .weight, isNav: true)) {
            Chart {
                if let selectedData {
                    ChartAnnonationView(data: selectedData, context: .weight)
                }
                
                if !chartData.isEmpty {
                    RuleMark(y: .value("Goals", 155))
                        .foregroundStyle(.mint)
                        .lineStyle(.init(lineWidth: 1, dash: [5]))
                }
                
                ForEach(chartData) { weight in
                    AreaMark(
                        x: .value("Day", weight.date, unit: .day),
                        yStart: .value("Value", weight.value),
                        yEnd: .value("Min Value", minValue)
                    )
                    .foregroundStyle(Gradient(colors: [.indigo.opacity(0.5), .clear]))
                    .interpolationMethod(.catmullRom)
                    
                    LineMark(
                        x: .value("Day", weight.date, unit: .day),
                        y: .value("Value", weight.value)
                    )
                    .foregroundStyle(.indigo)
                    .interpolationMethod(.catmullRom)
                    .symbol(.circle)
                }
            }
            .frame(height: 150)
            .chartXSelection(value: $rawSelectedDate)
            .chartYScale(domain: .automatic(includesZero: false))
            .chartXAxis {
                AxisMarks {
                    AxisValueLabel(format: .dateTime.month(.defaultDigits).day())
                }
            }
            .chartYAxis {
                AxisMarks { value in
                    AxisGridLine()
                        .foregroundStyle(Color.secondary.opacity(0.3))
                    AxisValueLabel()
                }
            }
            .overlay {
                if chartData.isEmpty {
                    ChartEmptyView(systemImageName: "chart.pie", title: "No Data", description: "There is no step count data from the Health App")
                }
            }
        }
        .sensoryFeedback(.selection, trigger: selectedDay)
        .onChange(of: rawSelectedDate) { oldValue, newValue in
            if oldValue?.weekdayInt != newValue?.weekdayInt {
                selectedDay = newValue
            }
        }
    }
}

#Preview {
    WeightLineChart(chartData: ChartHelper.convert(data: MockData.weights))
}
