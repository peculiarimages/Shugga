//
//  StepCountData.swift
//  Shugga
//
//  Created by Rodi on 2/26/23.
//

import Foundation
import HealthKit

class StepCountData {
    
    let healthStore = HKHealthStore()

    init () {
        
        askForHealthKitStepsPermission()
        
    }
    
    
    @Published var numberOfTimesUserSteppedXSteps: Int = 0
    
    
    
    
    
    
    
    
    
    
    
    func askForHealthKitStepsPermission () {
        
        
        let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount)!

        healthStore.requestAuthorization(toShare: nil, read: [stepCountType]) { success, error in
            if success {
                // The user granted permission to read step count data
            } else {
                // The user denied permission to read step count data, or an error occurred
            }
        }

        
        
    }
    func startMonitoringStepCount() {
        let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let predicate = HKQuery.predicateForSamples(withStart: Date.distantPast, end: nil, options: .strictEndDate)

        let observerQuery = HKObserverQuery(sampleType: stepCountType, predicate: predicate) { query, completionHandler, error in
            self.checkStepCount()
            print ("startMonitoringStepCount")

            completionHandler()
        }

        healthStore.execute(observerQuery)
    }

    func checkStepCount(stepsToCount: Double = 50) {
        print ("checkStepCount")
        let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let predicate = HKQuery.predicateForSamples(withStart: Date.distantPast, end: nil, options: .strictEndDate)

        let query = HKStatisticsQuery(quantityType: stepCountType, quantitySamplePredicate: predicate, options: .cumulativeSum) { query, result, error in
            guard let result = result else {
                print("Error retrieving step count: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            if let sum = result.sumQuantity() {
                let steps = sum.doubleValue(for: .count())

                if steps >= stepsToCount {
                    self.userWalkedMoreThanXSteps(stepsToCount: stepsToCount)
                    self.numberOfTimesUserSteppedXSteps += 1
                }
            }
        }

        healthStore.execute(query)
    }

    func userWalkedMoreThanXSteps(stepsToCount: Double) {
        print("User walked more than \(stepsToCount) steps!")
     
    }
    
    
    
    
}
