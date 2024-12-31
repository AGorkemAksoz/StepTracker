//
//  StepTrackerApp.swift
//  StepTracker
//
//  Created by Gorkem on 15.11.2024.
//

import SwiftUI

@main
struct StepTrackerApp: App {
    
    let hkManager = HealtKitManager()
    var body: some Scene {
        WindowGroup {
            DashboardView()
                .environment(hkManager)
        }
    }
}
