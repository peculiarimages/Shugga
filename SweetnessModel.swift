//
//  SweetnessModel.swift
//  sugar me high
//
//  Created by Rodi on 9/21/22.
//

import Foundation
import SwiftUI
import HealthKit
//import HealthKitReporter
import UIKit
import AVFoundation
import BackgroundTasks


struct DebugStruct {
    
    var id = UUID()
    var timeString:  String = ""
    var diagnostic: String = ""
    var startTimestampHumanReadable : String = ""
    var whoCalledToAddSweetness: WhoCalledTheFunction = .unassigned
    
}



struct Sweetness: Identifiable, Equatable, Hashable{
    
    static func ==(lhs: Sweetness, rhs: Sweetness) -> Bool {
        
        return   lhs.assignedID == rhs.assignedID
//                    lhs.sweetness ==            rhs.sweetness &&
//                    lhs.sweetnessRegressive ==  rhs.sweetnessRegressive &&
//                    lhs.sweetness_string ==     rhs.sweetness_string &&
                   // lhs.startTimestamp ==       rhs.startTimestamp //&&
//                    lhs.source_name ==          rhs.source_name &&
//                    lhs.manufacturer ==         rhs.manufacturer &&
//                    lhs.model ==                rhs.model
       }
    func hash(into hasher: inout Hasher) {
       hasher.combine(id)
     }
    
    var id = UUID()
    var assignedID:  UUID?                      // assigned by dexcom, loop, etc
    var sweetness: Double = 0.0                 // 162.000  This is the blood glucose value in var unit
    var sweetnessRegressive: Double?            // a new reassigned glucose value
    var lastRegressionRecording: Double?        // when was the regression reassignment happen last
    var sweetness_string: String = ""           // "162.0"
    var startTimestamp: Double = 1.0            // 1672349878.589397    ->  init(timeIntervalSince1970: TimeInterval)    -> 1 January 1970  = 0
    var source_name: String = ""                // Loop
    var manufacturer: String = ""               // Dexcom
    var model: String = ""                      // G6
    var glucoseTrendRateValue: Double?
    var glucoseTrendRateUnit: String?          // "mg/min·dL"
    var unit: String = ""                       // eg "mg/dL" - this is for var sweetness
    var whoRecorded: WhoCalledTheFunction = .unassigned
    var timeRecordedHere: Double?               // 1672349878.589397    ->  init(timeIntervalSince1970: TimeInterval)    -> 1 January 1970  = 0
    
    var thisValueWasUttered: Bool = false
    
    var deBug = DebugStruct()
    
//    var userUnit : String = ""              
}




class ManySweetnesses: ObservableObject {  // array of Sweetness
    
    
    static let shared = ManySweetnesses()

    
    
   // var bloodGlucoseData = BloodGlucoseData.shared

    
    
    
    @Published var sweetnesses : [Sweetness]? = []
    
    @Published var sugahNow : Bool = false
    
    @Published var deBug = DebugStruct()

    
    
    
    
    func returnTimeSinceLastCGM (purportedLastUUID: UUID? = nil, purportedLastStartTimeStamp: Double? = nil ) -> Double {
        
        
        
        if self.sweetnesses?.count ?? 0 > 10 {
            
            print ("self.sweetnesses?.count: \(self.sweetnesses?.count)")
        }
        
        
        
        
        
        var timeInterval: Double = 0
        
        
        if let _ = purportedLastUUID {
            
            if let theSweetness = self.sweetnesses?.first(where: { $0.id == purportedLastUUID }) {
                

                timeInterval = Date().timeIntervalSince(Date(timeIntervalSince1970: theSweetness.startTimestamp ))


                print("Found struct with UUID \(String(describing: purportedLastUUID)).")
                
            } else
            
            {
                print("No struct found with UUID \(String(describing: purportedLastUUID))")
            }
            
        }
        else
        
        if let theTimeStamp = purportedLastStartTimeStamp {
            
            
            timeInterval = Date().timeIntervalSince(Date(timeIntervalSince1970: theTimeStamp))

            
        }
        
        else
            
            {
            
             timeInterval = Date().timeIntervalSince(Date(timeIntervalSince1970: self.sweetnesses?.last?.startTimestamp ?? rodisBirthdayTimeStamp))

        }

        
        
        return (timeInterval)
        
    
        
      
    }
    
    
    
    
    
    func checkIfThisSweetnessAlreadyExists (sweetness: Sweetness) -> Bool {
        

        var itExists = false
        if let unwrappedSweetnesses = self.sweetnesses { // if not nil
             for aSweetness in unwrappedSweetnesses {
                 // Check if the current `aSweetness` is equal to the `sweetness` parameter
                 if (aSweetness.assignedID == sweetness.assignedID) || (aSweetness.id == sweetness.id) || (aSweetness.startTimestamp == sweetness.startTimestamp){
                     itExists = true
                     return itExists

                 }
             }
         }
         return itExists
     
    }
    
    
    
    func cleanUpSweetnesses() {
        
        var sweetnessSet = Set<Sweetness>()
        for sweetness in self.sweetnesses ?? [] {
            sweetnessSet.insert(sweetness)
        }
        self.sweetnesses = Array(sweetnessSet).sorted { $0.startTimestamp < $1.startTimestamp }
    }

    
    

        
        
    
    func addQueryDirectly(limit: Int = oneTimeBloodGlucoseFetchCountLimit, whoCalledTheFunction: WhoCalledTheFunction = WhoCalledTheFunction.unassigned, samples: [HKQuantitySample], completion: @escaping (Bool) -> Void) {
        
        var thisGlucoseTrendRateValue: Double?
        var thisGlucoseTrendRateUnit: String?
        
        var counter: Int = 0
        
        for sample in samples {
            
            switch sample.sourceRevision.source.name {
            case "Dexcom G6":
                _ = true
                
                
                
            case "Loop":
                
                
                
                _ = true
            default:
                _ = true }
            
            if sample.sourceRevision.source.name == "Loop" {
                thisGlucoseTrendRateValue = sample.metadata?["com.LoopKit.GlucoseKit.HKMetadataKey.GlucoseTrendRateValue"] as? Double
                
                thisGlucoseTrendRateUnit = sample.metadata?["com.LoopKit.GlucoseKit.HKMetadataKey.GlucoseTrendRateUnit"] as? String // "mg/min·dL"
            }
            
            let deBug = DebugStruct(
                timeString: timeStampToLocal_hh_mm_ss(timestamp: Date().timeIntervalSince1970),
                diagnostic: "from: fetchLatestBloodGlucose",
                startTimestampHumanReadable: timeStampToLocal_hh_mm_ss(timestamp: sample.startDate.timeIntervalSince1970),
                whoCalledToAddSweetness: whoCalledTheFunction)
            
            let sweetness = Sweetness(assignedID: sample.uuid,                                                              // UUID
                                      sweetness: sample.quantity.doubleValue(for: bloodGlucoseMgDlUnit),                    // Double: 77
                                      sweetness_string: String(sample.quantity.doubleValue(for: bloodGlucoseMgDlUnit)),     // String: "77.0"
                                      startTimestamp: sample.startDate.timeIntervalSince1970,                               // Double: 1678203118.805573
                                      source_name: sample.sourceRevision.source.name,                                       // String: "Loop"
                                      manufacturer: sample.device?.manufacturer ?? "-",                                     // String: "Dexcom"
                                      model: sample.device?.model ?? "-",                                                   // String: "G6"
                                      glucoseTrendRateValue: thisGlucoseTrendRateValue,                                     // Double: -0.20000000000000001
                                      glucoseTrendRateUnit: thisGlucoseTrendRateUnit,                                       // String:
                                      unit: "mg/dL",                                                                        // String: "mg/dL"
                                      whoRecorded:  whoCalledTheFunction,                                                   // enum Shugga.WhoCalledTheFunction    healthKitBackgroundDelivery
                                      timeRecordedHere: Date().timeIntervalSince1970,                                       // Double: 1678210287.4432189
                                      deBug: deBug
            )
            
            if whoCalledTheFunction == .HKObserverQuery {
                
//                
//                self.bloodGlucoseData.thePlayer.speakAnything(toBeSpoken: "HK \(sweetness.sweetness_string)")
//                {
//                    print ("health kit values spoken")
//                }
                
            }
            
            addSweetnessWithCompletionHandler(sweetness: sweetness) { (success) in
                print (whoCalledTheFunction.rawValue)
                if success {
//                    print("Sweetness added successfully $$$ \(counter)")
//                    print (sample.quantity.doubleValue(for: bloodGlucoseMgDlUnit))
//                    
                    
                    printTimestamp(description: "fetchLatestBloodGlucose", content: whoCalledTheFunction.rawValue + " " + String(self.sweetnesses?.last?.sweetness ?? -123), label: "🩸+ ")
                    
                    
                    
                    
                } else {
//                    print("This was not added to sweetness: addQueryDirectly $$$ \(counter)")
//                    print (sample.quantity.doubleValue(for: bloodGlucoseMgDlUnit))

                }
                
            }
            counter += 1
            
            //        completion(true)

        }
     
        completion(true)

    }
    
    func addSweetness(sweetness: Sweetness) -> Bool { //returns true if added
        //
        var success = false

        DispatchQueue.main.async { [self] in

            if (sweetness.startTimestamp > self.sweetnesses?.last?.startTimestamp ?? 0) && !(self.checkIfThisSweetnessAlreadyExists(sweetness: sweetness))
            {
                
//                   / self.cleanUpSweetnesses()

                    // printTimestamp(description: "addSweetness", content: sweetness.sweetness_string, label: "s1")
                    self.sweetnesses?.append(sweetness)
                self.sugahNow = true
                 success =  true
                }
            
                
            
            }
        return success
        }
    
    func addSweetnessWithCompletionHandler (sweetness: Sweetness, completion: @escaping (Bool) -> Void) {
//        DispatchQueue.main.async { [self] in // removed this queue.main because it will be nested inside another. reduced cpu load.🧐
            var success = false
            if sweetness.startTimestamp > self.sweetnesses?.last?.startTimestamp ?? 0, !self.checkIfThisSweetnessAlreadyExists(sweetness: sweetness) {
                    self.sweetnesses?.append(sweetness)
                    self.sugahNow = true
                    
                    success = true
            }
            completion(success)
//        }
    }

        
    
    
    
    
    
    
    
}

