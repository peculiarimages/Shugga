//
//  CBM_Model.swift
//  Shugga
//
//  Created by Rodi on 3/5/23.
//

import Foundation
import SwiftUI
import BackgroundTasks


struct GlucoseMonitor: Hashable {
    let manufacturer:       String
    let modelName:          String
    let modelShortName:     String
    let samplingSeconds:    Double
    let warmupSeconds:      Double
    let universalDeviceFDA: String?         //GUIDID
    let dateDiscontinued:   Date?
    let manufactureURL:     URL?
    
    init(manufacturer:              String,
         modelName:                 String,
         modelShortName:            String,
         samplingSeconds:           Double,
         warmupSeconds:             Double,
         universalDeviceFDA:        String? = nil,
         dateDiscontinued:          Date? = nil,
         manufactureURL:            URL? = nil)
    {
        
        
        self.manufacturer =         manufacturer
        self.modelName =            modelName
        self.modelShortName =       modelShortName
        self.samplingSeconds =      samplingSeconds
        self.warmupSeconds =        warmupSeconds
        self.universalDeviceFDA =   universalDeviceFDA
        self.dateDiscontinued =     dateDiscontinued
        self.manufactureURL =       manufactureURL
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(modelName)
        hasher.combine(modelShortName)
        hasher.combine(universalDeviceFDA)
    }
    
    static func == (lhs: GlucoseMonitor, rhs: GlucoseMonitor) -> Bool {
        
        return  lhs.modelName == rhs.modelName &&
                lhs.modelShortName == rhs.modelShortName &&
                lhs.universalDeviceFDA == rhs.universalDeviceFDA
        // In this implementation, the hash(into:) method combines only the modelName,
        // modelShortName, and universalDeviceFDA properties.
        // The == operator compares only those properties as well.
    }
}

class GlucoseMonitorModel {
    
   // @ObservedObject var bloodGlucoseData =  BloodGlucoseData.shared

    
    
    var currentGlucoseMonitor: GlucoseMonitor?
    
    let glucoseMonitors: Set<GlucoseMonitor> = [  // Set because each are unique

    GlucoseMonitor(manufacturer:        "Dexcom",
                   modelName:           "Dexcom G6 Continuous Glucose Monitoring System",
                   modelShortName:      "G6",
                   samplingSeconds:     Double(SecondsIn.fiveMinutes.rawValue),
                   warmupSeconds:       Double(SecondsIn.twoHours.rawValue),
                   universalDeviceFDA:  "00386270000385"),
    
    GlucoseMonitor(manufacturer:        "Dexcom",
                   modelName:           "Dexcom G7 Continuous Glucose Monitoring System",
                   modelShortName:      "G7",
                   samplingSeconds:     Double(SecondsIn.fiveMinutes.rawValue),
                   warmupSeconds:       Double(SecondsIn.thirtyMinutes.rawValue)
                   )

   ]

    func returnGlucoseMonitor(modelShortName: String?, universalDeviceFDA: String? = "") throws -> GlucoseMonitor {
        guard let lookingFor = modelShortName ?? universalDeviceFDA,
              let glucoseMonitor = glucoseMonitors.first(where: { $0.modelShortName == lookingFor || $0.universalDeviceFDA == lookingFor })
        else {
            if let modelShortName = modelShortName {
                throw GlucoseMonitorError.noMatchingGlucoseMonitorShortName(modelShortName: modelShortName)
            } else if let universalDeviceFDA = universalDeviceFDA {
                throw GlucoseMonitorError.noMatchingGlucoseMonitorFDA_ID(modelShortName: universalDeviceFDA)
            } else {
                throw GlucoseMonitorError.invalidInput
            }
        }
        return glucoseMonitor
    }

    
    
    
    
    
    
    
}
