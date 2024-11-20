//
//  HealtKitPermissionPrmingView.swift
//  StepTracker
//
//  Created by Ali Görkem Aksöz on 18.11.2024.
//

import HealthKitUI
import SwiftUI

struct HealtKitPermissionPrmingView: View {
    
    @Environment(HealtKitManager.self) private var hkManager
    @Environment(\.dismiss) private var dismiss
    @State private var isShowingHealthKitPermission: Bool = false
    @Binding var hasSeen: Bool
    
    var description = """
    This app displays your step and weight data in interactive charts.
    
    You can also add new step or weight data to Apple Healt from this app. Your data is private and secured.
"""
    
    var body: some View {
        VStack(spacing: 130) {
            VStack(alignment: .leading, spacing: 10) {
                Image(.appleHealth)
                    .resizable()
                    .frame(width: 90, height: 90)
                    .shadow(color: .gray.opacity(0.3), radius: 16)
                    .padding(.bottom, 12)
                
                Text("Apple Health Intergration")
                    .font(.title2).bold()
                
                Text(description)
                    .foregroundStyle(.secondary)
                
                Button("Connect to Apple Health") {
                    isShowingHealthKitPermission = true
                }
                .buttonStyle(.bordered)
                .tint(.pink)
            }
        }
        .padding(30)
        .interactiveDismissDisabled()
        .onAppear{ hasSeen = true }
        .healthDataAccessRequest(store: hkManager.store,
                                 shareTypes: hkManager.types,
                                 readTypes: hkManager.types,
                                 trigger: isShowingHealthKitPermission) { result in
            switch result {
            case .success(_):
                dismiss()
            case .failure(_):
                // Handle error later
                dismiss()
            }
        }
    }
}

#Preview {
    HealtKitPermissionPrmingView(hasSeen: .constant(true))
        .environment(HealtKitManager())
}
