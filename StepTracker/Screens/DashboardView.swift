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
                    
                    Picker("Selected Metric", selection: $selectedMetric) {
                        ForEach(HealtMetricContext.allCases) {
                            Text($0.title)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    StepBarChart(selectedStat: selectedMetric, chartData: hkManager.stepData)
                    
                    VStack(alignment: .leading) {
                        VStack {
                            Label("Averages", systemImage: "calendar")
                                .font(.title3).bold()
                                .foregroundStyle(.pink)
                            
                            Text("Last 28 Days")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(.secondary)
                            .frame(height: 240)
                    }
                    .padding()
                    .onAppear{ isShowingPermissionPrmiingSheet = !hasSeenPermissionPrimining
                    }
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
                }
            }
            .padding()
            .task {
                await hkManager.fetchStepCount()
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
