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
    case appTimer =                         "app Timer"
    case locationManger =                   "location Manger"
    case speakBloodGlucose =                "speak Blood Glucose"
    case bloodGlucoseView_onAppear =        "bloodGlucoseView on Appear"
    case bloodGlucoseView_on2Tap =          "blood GlucoseView on double Tap"
    case settingsView =                     "settings view"
    case backgroundScenePhase =             "background scene phase"
    case foregroundScenePhase =             "foreground scene phase"
    case foregroundViewTimer =              "foreground View Timer"
    case sceneDelegate =                    "sceneDelegate"
    case HKObserverQuery =                  "HK-ObserverQuery"
    case myBackgroundOperation =            "my Background Operation"
    case iOSBackgroundCall =                "iOS Background Call"
    case appDelegate =                      "app Delegate"
    case myBackgroundOperationMethod =      "myBackgroundOperation"
    
    case applicationConfigurationForConnecting =  "applicationConfigurationForConnecting"
    case scheduleBackgroundProcessingTaskMethod = "scheduleBackgroundProcessingTask"
    case scheduleBackgroundAppRefreshTaskMethod = "scheduleBackgroundAppRefreshTask"
    
    case healthKitBackgroundDelivery =             "HK Background Delivery 🏥"
    case bloodGlucoseDataInit   =           "blood Glucose Data Init"
    
    case userWalkedMoreThanXsteps =         "user walked more than x steps"
    
    case mainTimer =                         "main timer start"
    
    case afterCompletingSpeaking =          "afterCompletingSpeaking"
    
    case firstAttemptToFetchFailed =        "firstAttemptToFetchFailed"
    
    case deBugView =                             "debug"
    
    
    
    
    case backgroundFetch =                  "backgroundFetch"
    
}

enum TheAppErrorCodes: Double {
    
    case userNotAgreedToAgreement       = -104
    case SweetnessesLastError           = -77
}
