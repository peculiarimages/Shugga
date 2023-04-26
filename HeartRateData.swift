//
//  HeartRateData.swift
//  Shugga
//
//  Created by Rodi on 2/26/23.
//

import Foundation

import HealthKit

class HeartRateMonitor {
    
    let healthStore = HKHealthStore()

    func startMonitoringHeartRate() {
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
            // Heart rate type is not available on this device
            return
        }

        let query = HKObserverQuery(sampleType: heartRateType, predicate: nil) { query, completionHandler, error in
            if let error = error {
                print("Error monitoring heart rate: \(error.localizedDescription)")
                return
            }

            self.fetchHeartRateData(completionHandler: completionHandler)
        }

        healthStore.execute(query)
    }

    func fetchHeartRateData(completionHandler: @escaping () -> Void) {
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
            // Heart rate type is not available on this device
            return
        }

        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let query = HKSampleQuery(sampleType: heartRateType, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { query, samples, error in
            if let error = error {
                print("Error fetching heart rate data: \(error.localizedDescription)")
                return
            }

            guard let sample = samples?.first as? HKQuantitySample else {
                // No heart rate data available
                return
            }

            let heartRateUnit = HKUnit(from: "count/min")
            let heartRate = sample.quantity.doubleValue(for: heartRateUnit)
            print("Heart rate updated: \(heartRate)")

            completionHandler()
        }

        healthStore.execute(query)
    }
}
