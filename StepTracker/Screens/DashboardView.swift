//
//  DashboardView.swift
//  StepTracker
//
//  Created by Gorkem on 15.11.2024.
//
import Charts
import SwiftUI

enum HealtMetricContext: CaseIterable, Identifiable {
    case steps, weight
    var id: Self { self }
    
    var title: String {
        switch self {
            case .steps: return "Steps"
            case .weight: return "Weight"
        }
    }
}

struct DashboardView: View {
    @Environment(HealtKitManager.self) private var hkManager
    @State private var isShowingPermissionPrmiingSheet: Bool = false
    @State private var selectedMetric: HealtMetricContext = .steps
    @State private var isShowingAlert: Bool = false
    @State private var fetchError: STError = .noData
    
    var isSteps: Bool { selectedMetric == .steps }
   
    var body: some View {
        NavigationStack {
            ScrollView{
                VStack(spacing: 20) {
                    
                    Picker("Selected Metric", selection: $selectedMetric.animation(.easeIn)) {
                        ForEach(HealtMetricContext.allCases) {
                            Text($0.title)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    switch selectedMetric {
                    case .steps:
                        StepBarChart(chartData: ChartHelper.convert(data: hkManager.stepData))
                        StepPieChart(chartData: ChartMath.averageWeekdayCount(for: hkManager.stepData))
                    case .weight:
                        WeightLineChart(chartData: ChartHelper.convert(data: hkManager.weightData))
                        WeightDiffBarChart(chartData: ChartMath.averageDailyWeightDiffs(for: hkManager.weightDiffData))
                    }
                    
                }
            }
            .padding()
            .task {
                do {
                    try await hkManager.fetchStepCount()
                    try await hkManager.fetchWeights()
                    try await hkManager.fetchWeightsForDifferentials()
                } catch STError.authNotDetermined {
                    isShowingPermissionPrmiingSheet = true
                } catch STError.noData {
                    fetchError = .noData
                    isShowingAlert = true
                } catch {
                    fetchError = .unableToCompleteRequest
                    isShowingAlert = true
                }
            }
            .navigationTitle("Dashboard")
            .navigationDestination(for: HealtMetricContext.self) { metric in
                HealtDataListView(metric: metric)
            }
            .sheet(isPresented: $isShowingPermissionPrmiingSheet) {
                
            } content: {
                HealtKitPermissionPrmingView()
            }
            .alert(isPresented: $isShowingAlert, error: fetchError, actions: { fetchedError in
                // Actions
            }, message: { fetchedError in
                Text(fetchedError.failureReason!)
            })
        }
        .tint(isSteps ? .pink : .indigo)
    }
}

#Preview {
    DashboardView()
        .environment(HealtKitManager())
}
