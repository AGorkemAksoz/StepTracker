//
//  StepBarChart.swift
//  StepTracker
//
//  Created by Gorkem on 26.11.2024.
//

import Charts
import SwiftUI

struct StepBarChart: View {
    
    @State private var rawSelectedDate: Date?
    
    var selectedStat: HealtMetricContext
    var chartData: [HealthMetric]
    
    var avgStepCount: Double {
        guard !chartData.isEmpty else { return 0}
        let totalSteps = chartData.reduce(0) { $0 + $1.value }
        return totalSteps/Double(chartData.count)
    }
    
    var selectedHealtMetric: HealthMetric? {
        guard let rawSelectedDate else { return nil }
        
        return chartData.first {
            Calendar.current.isDate(rawSelectedDate, inSameDayAs: $0.date)
        }
    }
    
    
    var body: some View {
        VStack {
            NavigationLink(value: selectedStat) {
                HStack {
                    VStack(alignment: .leading) {
                        Label("Steps", systemImage: "figure.walk")
                            .font(.title3).bold()
                            .foregroundStyle(.pink)
                        
                        Text("Avg: \(Int(avgStepCount)) steps")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.secondary)
                }
            }
            .foregroundStyle(.secondary)
            .padding(.bottom, 12)
            
            Chart {
                
                if let selectedHealtMetric {
                    RuleMark(x: .value("Selected Metrick", selectedHealtMetric.date, unit: .day))
                        .foregroundStyle(Color.secondary.opacity(0.3))
                        .offset(y: -10)
                        .annotation(position: .top,
                                    spacing: 0,
                                    overflowResolution: .init(x: .fit(to: .chart), y: .disabled)) { annotataionView }
                }
                
                RuleMark(y: .value("Average", avgStepCount))
                    .foregroundStyle(Color.secondary)
                    .lineStyle(.init(lineWidth: 1, dash: [5]))
                
                ForEach(chartData) { steps in
                    BarMark(
                        x: .value("Date", steps.date, unit: .day),
                        y: .value("Steps", steps.value)
                    )
                    .foregroundStyle(Color.pink.gradient)
                    .opacity(rawSelectedDate == nil || steps.date == selectedHealtMetric?.date ? 1.0 : 0.3 )
                }
            }
            .frame(height: 150)
            .chartXSelection(value: $rawSelectedDate.animation(.easeInOut))
            .chartXAxis {
                AxisMarks {
                    AxisValueLabel(format: .dateTime.month(.defaultDigits).day())
                }
            }
            .chartYAxis {
                AxisMarks { value in
                    AxisGridLine()
                        .foregroundStyle(Color.secondary.opacity(0.3))
                    
                    AxisValueLabel((value.as(Double.self) ?? 0)
                        .formatted(.number.notation(.compactName)))
                }
            }
            
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
    }
    
    var annotataionView: some View {
        VStack(alignment: .leading) {
            Text(selectedHealtMetric?.date ?? .now, format: .dateTime.weekday(.abbreviated).month(.abbreviated).day())
                .font(.footnote.bold())
                .foregroundStyle(.secondary)
            
            Text(selectedHealtMetric?.value ?? 0, format: .number.precision(.fractionLength(0)))
                .fontWeight(.heavy)
                .foregroundStyle(.pink)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(Color(.secondarySystemBackground))
                .shadow(color: .secondary.opacity(0.3), radius: 2, x: 2, y: 2)
        )
    }
}

#Preview {
    StepBarChart(selectedStat: .steps, chartData: MockData.steps)
}
