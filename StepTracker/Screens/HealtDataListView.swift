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
    @State private var isShowingAlert: Bool = false
    @State private var writeError: STError = .noData
    
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
            .alert(isPresented: $isShowingAlert, error: writeError, actions: { writtenError in
                switch writtenError {
                case .authNotDetermined, .noData, .unableToCompleteRequest, .invalidValue:
                    EmptyView()
                case .sharingDenied(_):
                    Button("Settings") {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    }
                    
                    Button("Cancel", role: .cancel) { }
                }
            }, message: { writtenError in
                Text(writeError.failureReason!)
            })
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Dismiss") {
                        isShowingAddData = false
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Data") {
                        guard let value = Double(valueToAdd) else {
                            writeError = .invalidValue
                            isShowingAlert = true
                            valueToAdd = ""
                            return
                        }
                        Task {
                            switch metric {
                            case .steps:
                                do {
                                    try await hkManager.addStepData(for: addDataDate, value: value)
                                    try await hkManager.fetchStepCount()
                                    isShowingAddData = false
                                } catch STError.sharingDenied(let quantityType) {
                                    writeError = .sharingDenied(quantityType: quantityType)
                                    isShowingAlert = true
                                } catch {
                                    writeError = .unableToCompleteRequest
                                    isShowingAlert = true
                                }
                            case .weight:
                                do {
                                    try await hkManager.addWeightData(for: addDataDate, value: value)
                                    try await hkManager.fetchWeights()
                                    try await hkManager.fetchWeightsForDifferentials()
                                    isShowingAddData = false
                                } catch STError.sharingDenied(let quantityType) {
                                    writeError = .sharingDenied(quantityType: quantityType)
                                    isShowingAlert = true
                                } catch {
                                    writeError = .unableToCompleteRequest
                                    isShowingAlert = true
                                }
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
