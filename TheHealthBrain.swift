//
//  TheHealthBrain.swift
//  Shugga
//
//  Created by Rodi on 2/26/23.
//

import Foundation
import HealthKit

class HealthStoreWrapper: ObservableObject {
    let healthStore = HKHealthStore()
    
//    func startBackgroundDelivery(for sampleType: HKSampleType, unit: HKUnit) {
        // Code to start background delivery
//    }
    // any other healthstore related functions
}


class TheHealthBrain: ObservableObject {
    
    
    static let shared = TheHealthBrain()
    
    init () {
        
        
        bloodGlucoseData.requestBloodGlucoseAuthorization()
       // bloodGlucoseData.requestStepsAuthorization()

//        stepCountData.startMonitoringStepCount()

    }
    
    
    let bloodGlucoseData = BloodGlucoseData()
    
//    let stepCountData = StepCountData()
    
    
    
}
