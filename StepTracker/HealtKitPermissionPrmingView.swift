//
//  HealtKitPermissionPrmingView.swift
//  StepTracker
//
//  Created by Ali Görkem Aksöz on 18.11.2024.
//

import SwiftUI

struct HealtKitPermissionPrmingView: View {
    
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
                    
                }
                .buttonStyle(.bordered)
                .tint(.pink)
            }
        }
        .padding(30)
    }
}

#Preview {
    HealtKitPermissionPrmingView()
}
