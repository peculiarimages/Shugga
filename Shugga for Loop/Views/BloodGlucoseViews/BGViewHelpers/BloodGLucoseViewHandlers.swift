//
//  BloodGLucoseViewHandlers.swift
//  shugga
//
//  Created by Rodi on 2/22/23.
//

import Foundation
import SwiftUI


func handleSettingsLogoTapGesture(doubleTapForSugah: Bool, bloodGlucoseData: BloodGlucoseData) {
    
    if doubleTapForSugah {
      //  bloodGlucoseData.thePlayer.speakTimeNow(sampleTime: Date(timeIntervalSince1970: Double(bloodGlucoseData.manySweetnesses.sweetnesses?.last?.startTimestamp ?? rodisBirthdayTimeStamp)))
        triggerHaptic(binaryPattern: "10100100010000100001", timeUnit: 1)
        
        if bloodGlucoseData.manySweetnesses.sugahNow {
                
            bloodGlucoseData.fetchLatestBloodGlucoseAndSpeak(whoCalledTheFunction: .bloodGlucoseView_on2Tap) { success in
                if success {
                    print("👄Latest blood glucose fetched and spoken successfully! \(WhoCalledTheFunction.bloodGlucoseView_on2Tap.rawValue)")
                } else {
                    print("Failed to fetch or speak latest blood glucose.")
                    print ("handleBloodGlucoseViewOnTapGesture")
                    
                }
            }
        }

    }
    
    
}


func handleBloodGlucoseViewOnTapGesture(view: BloodGlucoseView, doubleTapForSugah: Bool, bloodGlucoseData: BloodGlucoseData) {
    
    if doubleTapForSugah {
      //  bloodGlucoseData.thePlayer.speakTimeNow(sampleTime: Date(timeIntervalSince1970: Double(bloodGlucoseData.manySweetnesses.sweetnesses?.last?.startTimestamp ?? rodisBirthdayTimeStamp)))
        triggerHaptic(binaryPattern: "10100100010000100001", timeUnit: 1)
        
        if bloodGlucoseData.manySweetnesses.sugahNow {
                
            bloodGlucoseData.fetchLatestBloodGlucoseAndSpeak(whoCalledTheFunction: .bloodGlucoseView_on2Tap) { success in
                if success {
                    print("👄Latest blood glucose fetched and spoken successfully! \(WhoCalledTheFunction.bloodGlucoseView_on2Tap.rawValue)")
                } else {
                    print("Failed to fetch or speak latest blood glucose.")
                    print ("handleBloodGlucoseViewOnTapGesture")
                    
                }
            }
        }

    }
    
    
}



func handleBloodGlucoseViewOnChange(view: BloodGlucoseView, newPhase: ScenePhase, bloodGlucoseData: BloodGlucoseData) {
    
    @AppStorage("warnGoingToBackground ")  var warnGoingToBackground = false
    @AppStorage("showLockButton")  var showLockButton =                     false

    var speech = Speech.shared

    
    
    switch newPhase {
    case .active:
        print("\nNEW PHASE: Active ==================================")
//                                    bloodGlucoseData.appScenePhase = .active
//                                    bloodGlucoseData.fetchLatestBloodGlucose()
 //       checkForBGTaskScheduler()

       // bloodGlucoseData.setMainSugarTimerInterval()
//                                    bloodGlucoseData.speakBloodGlucose(whoCalledTheFunction: WhoCalledTheFunction.foregroundScenePhase)
     
    case .inactive:
        print("\nNEW PHASE: Inactive ================================")
        bloodGlucoseData.appScenePhase = .inactive
//        checkForBGTaskScheduler()
        
    case .background:
        print("\nNEW PHASE: Background ==============================")
        
        if (showLockButton && warnGoingToBackground) {
            
            speech.speakAnything(speechString: goneToBackgroundWarningString, typesOfSpeech: .goneToBackgroundWarning)
            
        }
      //  checkForBGTaskScheduler()
       // bloodGlucoseData.stopMainSugahTimer()

                                   // bloodGlucoseData.appScenePhase = .background
//
//                                    bloodGlucoseData.fetchLatestBloodGlucose()
//                                           sleep (UInt32(5))
//
//                                    bloodGlucoseData.speakBloodGlucose(whoCalledTheFunction: WhoCalledTheFunction.backgroundScenePhase)

        
    @unknown default:
        print("\nNEW PHASE: Unknown =================================") // 'ScenePhase' may have additional unknown values, possibly added in future versions
        
    }
    
}


func handleBloodGlucoseViewOnAppear(view: BloodGlucoseView, bloodGlucoseData: BloodGlucoseData) {
    
    if bloodGlucoseData.manySweetnesses.sugahNow {
        //                                    DispatchQueue.global(qos: .userInteractive).async {     bloodGlucoseData.fetchLatestBloodGlucose(limit: 1, whoCalledTheFunction: .bloodGlucoseView_onAppear)
        //                                                                                            bloodGlucoseData.speakBloodGlucose(whoCalledTheFunction: .bloodGlucoseView_onAppear) } }
        
    }
}
