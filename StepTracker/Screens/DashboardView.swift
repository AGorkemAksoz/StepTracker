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
            .task { fetchHealthData() }
            .navigationTitle("Dashboard")
            .navigationDestination(for: HealtMetricContext.self) { metric in
                HealtDataListView(metric: metric)
            }
            .fullScreenCover(isPresented: $isShowingPermissionPrmiingSheet) {
                fetchHealthData()
            } content: {
                HealtKitPermissionPrmingView()
            }
            .alert(isPresented: $isShowingAlert, error: fetchError, actions: { fetchedError in
                // Actions
            }, message: { fetchedError in
                Text(fetchedError.failureReason!)
            })
        }
        .tint(selectedMetric == .steps ? .pink : .indigo)
    }
    
    private func fetchHealthData() {
        Task {
            do {
                async let steps = hkManager.fetchStepCount()
                async let weightsForLineChart = hkManager.fetchWeights(daysBack: 28)
                async let weightsForDiffBarChart = hkManager.fetchWeights(daysBack: 29)
                
                hkManager.stepData =  try await steps
                hkManager.weightData = try await weightsForLineChart
                hkManager.weightDiffData = try await weightsForDiffBarChart
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
    }
}

#Preview {
    DashboardView()
        .environment(HealtKitManager())
}
