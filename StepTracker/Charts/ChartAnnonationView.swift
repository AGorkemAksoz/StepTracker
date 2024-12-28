//
//  ChartAnnonationView.swift
//  StepTracker
//
//  Created by Ali Görkem Aksöz on 28.12.2024.
//

import SwiftUI

struct ChartAnnonationView: View {
    let data: DateValueChartData
    let context: HealtMetricContext
    var body: some View {
        VStack(alignment: .leading) {
            Text(data.date, format: .dateTime.weekday(.abbreviated).month(.abbreviated).day())
                .font(.footnote.bold())
                .foregroundStyle(.secondary)
            
            Text(data.value, format: .number.precision(.fractionLength(context == .steps ? 0 : 1)))
                .fontWeight(.heavy)
                .foregroundStyle(context == .steps ? .pink : .indigo)
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
    ChartAnnonationView(data: .init(date: .now, value: 1000), context: .steps)
}
