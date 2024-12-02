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
    @AppStorage("hasSeenPermissinPriminig") private var hasSeenPermissionPrimining: Bool = false
    @State private var isShowingPermissionPrmiingSheet: Bool = false
    @State private var selectedMetric: HealtMetricContext = .steps
    
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
                        StepBarChart(selectedStat: selectedMetric, chartData: hkManager.stepData)
                        StepPieChart(chartData: ChartMath.averageWeekdayCount(for: hkManager.stepData))
                    case .weight:
                        WeightLineChart(selectedStat: selectedMetric, chartData: hkManager.weightData)
                    }
                    
                }
            }
            .padding()
            .onAppear{ isShowingPermissionPrmiingSheet = !hasSeenPermissionPrimining
            }
            .task {
                await hkManager.fetchStepCount()
                await hkManager.fetchWeights()
            }
            .navigationTitle("Dashboard")
            .navigationDestination(for: HealtMetricContext.self) { metric in
                HealtDataListView(metric: metric)
            }
            .sheet(isPresented: $isShowingPermissionPrmiingSheet) {
                
            } content: {
                HealtKitPermissionPrmingView(hasSeen: $hasSeenPermissionPrimining)
            }
        }
        .tint(isSteps ? .pink : .indigo)
    }
}

#Preview {
    DashboardView()
        .environment(HealtKitManager())
}
