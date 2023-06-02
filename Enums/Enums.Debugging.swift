//
//  Enums.Debugging.swift
//  sugah
//
//  Created by Rodi on 2/14/23.
//

import Foundation
import BackgroundTasks



enum WhoCalledTheFunction: String {
    case unassigned =                       "unassigned"
    case appStart =                         "app Start"
    case user =                             "user"
    
    case backgroundTask =                   "background Task"
    case backgroundRefresh =                "background App Refresh"
    case backgroundFetch =                  "background Fetch"
    case aRetryFromBackground =             "a retry from background"
    
    case appTimer =                         "app Timer"
    case displayRefreshTimer =              "display Refresh Timer"
    case locationManger =                   "location Manger"
    case speakBloodGlucose =                "speak Blood Glucose"
    case bloodGlucoseView_onAppear =        "blood Glucose View on Appear"
    case bloodGlucoseView_on2Tap =          "blood GlucoseView on double Tap"
    case settingsView =                     "settings view"
    case backgroundScenePhase =             "background scene phase"
    case foregroundScenePhase =             "foreground scene phase"
    case foregroundViewTimer =              "foreground View Timer"
    case sceneDelegate =                    "scene Delegate"
    case HKObserverQuery =                  "HK ObserverQuery"
    case myBackgroundOperation =            "my Background Operation"
    case iOSBackgroundCall =                "iOS Background Call"
    case appDelegate =                      "app Delegate"
    case myBackgroundOperationMethod =      "myBackgroundOperation"
    
    case applicationConfigurationForConnecting =  "application Configuration For Connecting"
    case scheduleBackgroundProcessingTaskMethod = "scheduleBackgroundProcessingTask"
    case scheduleBackgroundAppRefreshTaskMethod = "scheduleBackgroundAppRefreshTask"
    
    case healthKitBackgroundDelivery =             "HK Background Delivery"
    case bloodGlucoseDataInit   =           "blood Glucose Data Init"
    
    case userWalkedMoreThanXsteps =         "user walked more than x steps"
    
    case mainTimer =                         "main timer start"
    
    case afterCompletingSpeaking =          "afterCompletingSpeaking"
    
    case firstAttemptToFetchFailed =        "firstAttemptToFetchFailed"
    
    case deBugView =                             "debug"
    
    case backgroundImmediateSecondTry = "background Immediate Second Try"
    // if there is a new bg data while speaking
    
    
}

enum TheAppErrorCodes: Double {
    
    case userNotAgreedToAgreement       = -104
    case SweetnessesLastError           = -77
}
