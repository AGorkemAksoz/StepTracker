//
//  HealtDataListView.swift
//  StepTracker
//
//  Created by Ali Görkem Aksöz on 17.11.2024.
//

import SwiftUI

struct HealtDataListView: View {
    
    @Environment(HealtKitManager.self) private var hkManager
    @State private var isShowingAddData: Bool = false
    @State private var addDataDate: Date = .now
    @State private var valueToAdd: String = ""
    
    var metric: HealtMetricContext
    var isSteps: Bool { metric == .steps }
    
    var listData: [HealthMetric] {
        isSteps ? hkManager.stepData : hkManager.weightData
    }
    
    var body: some View {
        List(listData.reversed()) { data in
            HStack {
                Text(data.date, format: .dateTime.month().day().year())
                Spacer()
                Text(data.value, format: .number.precision(.fractionLength(isSteps ? 0 : 1)))
            }
        }
        .navigationTitle(metric.title)
        .sheet(isPresented: $isShowingAddData) {
            addDataView
        }
        .toolbar {
            Button("Add Data", systemImage: "plus") {
                isShowingAddData = true
            }
        }
    }
}

extension HealtDataListView {
    var addDataView: some View {
        NavigationStack {
            Form {
                DatePicker("Date", selection: $addDataDate, displayedComponents: .date)
                HStack {
                    Text("Value")
                    Spacer()
                    TextField("Value", text: $valueToAdd)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 140)
                        .keyboardType(isSteps ? .numberPad : .decimalPad)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(metric.title)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Dismiss") {
                        isShowingAddData = false
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Data") {
                        Task {
                            switch metric {
                            case .steps:
                                await hkManager.addStepData(for: addDataDate, value: Double(valueToAdd)!)
                                await hkManager.fetchStepCount()
                                isShowingAddData = false
                            case .weight:
                                await hkManager.addWeightData(for: addDataDate, value: Double(valueToAdd)!)
                                await hkManager.fetchWeights()
                                await hkManager.fetchWeightsForDifferentials()
                                isShowingAddData = false
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    HealtDataListView(metric: .steps)
        .environment(HealtKitManager())
}
