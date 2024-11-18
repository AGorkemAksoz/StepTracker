//
//  HealtKitManager.swift
//  StepTracker
//
//  Created by Ali Görkem Aksöz on 18.11.2024.
//

import Foundation
import HealthKitUI
import Observation

@Observable class HealtKitManager {
    let store = HKHealthStore()
    
    let types: Set = [HKQuantityType(.stepCount), HKQuantityType(.bodyMass)]
}
