//
//  EnumsAndConstants.swift
//  Sugah
//
//  Created by Rodi on 9/30/22.
//

import Foundation
import AVFoundation
import SwiftUI
import BackgroundTasks
import HealthKit



let pauseShuggaDefault_min = 30

let shuggaRed = Color(red: 151/255, green: 21/255, blue: 42/255)
//color="#97152a"
enum TypesOfSpeech {
    case bloodGlucoseValue
    case backgroundBloodGlucoseValue
    case notSoFreshWarning
    case carbReminder
    
    case other
    case error
    
    case off
}

let dateTooOldPeriod_min_default = 6
enum TheAppState: String {
    
    case appStarted = "App started"
    case appIdle = "App idling..."
    
    case foundCGM = "CGM identified"
    case aboutToFetchBloodGlucose = "About to fetch blood glucose"
    case fetchingBloodGlucose = "🩸Fetching blood glucose from Health"
    case finishedFetchingBloodGlucose = "Finished fetching blood glucose"
    
    case encounteredErrorWhileFetchingBloodGlucose = "Encountered error(s) while trying to fetch blood glucose ❌"
    case queryResultedInEmptyResult = "queryResultedInEmptyResult"
    
    case shuggaInProgress = "Shugga in progress"
    case finishedShugga = "Finished Shugga"

    case preparingToShugga = "Preparing Shugga"
    case stoppingExistingShugga = "Stopping existing Shugga"
    case encounteredErrorWhileShugga = "Encountered error(s) while Shugga"
    
    case hkBackgroundDelivery = "HK background delivery 🏥"
    
}




enum CGM_sampleFrequencies: Double { // in seconds
    
    case dexcom_G6 =            300
    case dexcom_G7 =            60
    
}


let bloodGlucoseHKSampleType = HKObjectType.quantityType(forIdentifier: .bloodGlucose)!
let bloodGlucoseMgDlUnit = HKUnit.gramUnit(with: .milli).unitDivided(by: HKUnit.literUnit(with: .deci))




let stepCountCheckInterval: Double = 25


let rodisBirthday = Date(timeIntervalSince1970: 86400) // February 2, 1970 00:00:00 UTC, just a "long time ago" constant
let rodisBirthdayTimeStamp = rodisBirthday.timeIntervalSince1970


let outputOptionsDefault = "Bluetooth"

enum OutputOptions: String {
    
    case iPhone =      "iPhone speaker"
    case bluetooth =   "Bluetooth"
    case automagic =   "Automagic"
    case both =        "Both"
}

let outputOptions = [    OutputOptions.iPhone.rawValue,
                         OutputOptions.bluetooth.rawValue,
                         OutputOptions.automagic.rawValue,
                         OutputOptions.both.rawValue ]

let oneTimeBloodGlucoseFetchCountLimit = 48
let oneTimeBloodGlucoseFetchSecondsAgo: Double = Double(SecondsIn.oneHour.rawValue)

let defaultFirstScheduleTaskEarliestInSeconds: Double = Double(SecondsIn.sixtyOneSeconds.rawValue)
let deBugMode = true

// settings
let castAlarmInterval_inMinutes:  [Int] =   [5, 10, 20, 30, 45, 60, 120, 300, 600]
let announcementInterval: [Int] =           [10, 20, 30, 60, 120, 300, 600, 900, 1200, 1800, 3600]
let pauseInterval: [Int] =                  [5, 10, 20, 30, 60, 120, 300, 600, 900, 1200]


let bloodGlucoseUnit : [String] = ["mg/dL", "mmol/L"]



let mainBloodGlucoseDisplayFontSizeChoices: [Int] = [8, 12, 14, 16, 18, 24, 36, 72, 100, 125, 150, 175, 200]
let dataTooOldPeriod: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 15, 20, 30, 60, 120]
    
let announcementGender: [String] = ["Female" , "Nonbinary", "Male"]


let howSugahBehavesWithOtherAudio : [String] = ["Stops playing", "Plays over"]
// ---



let logoTypeColor = Color(red: 0.530, green: 0.0, blue: 0.12)

let settingSymbolName = "gearshape.fill"

let thisIsBeta = false

let settingsSFSymbolName = "gearshape.fill"

enum LanguageNamesInEnglish: String {
    
    case english = "English"
}


let defaultSugahVoice =  "Samantha"
let defaultSugahLanguage = "English"
let defaultShuggaLanguageCode = "en"
let defaultShuggaLanguageRegionCode = "US"
let defaultShuggaLanguageCombinedCode = "en-US"

let defaultSugahLanguageCombinedCode = "en-US"
let defaultSugahVoiceName = "Sandy"
let defaultVoiceIdentifier = "com.apple.ttsbundle.siri_female_en-US_compact"
let defaultBloodGlucoseUnit = BloodGlucoseUnit.milligramsPerDeciliter.rawValue

let defaultThreeSpeechSpeed =  SugahSpeed.normal.rawValue


//https://gist.github.com/Koze/d1de49c24fc28375a9e314c72f7fdae4#file-speechvoices-tsv

let languageChoices: [String] = ["US English", "UK English", "Deutsch", "日本語", "Italiano", "Français (France)",  "한글", "Español"]

//let languageCodeCurrentlyAvailable: [String] = ["en" /*, "ja", "de", "it", "fr", "ko", "es", "zh"]  *// this is the order in the settings menu
let languageCodeCurrentlyAvailable: [String] = ["en", "ja", "de", "ko", "it", "fr", "ko", "es", "zh"] // this is the order in the settings menu


let old_test_unix_timestamp = 100_000_0000
let december_1_2022 = 166_991_0400
let january_1_2023  = 167_264_6396
let february_1_2023 = 167_520_9600
let march_1_2023    = 167_773_9282
let april_1_2023    = 168_033_2400
let may_1_2023      = 168_296_8332


enum BloodGlucoseUnit: String {
    
    case milligramsPerDeciliter =    "mg/dL"
    case millimolesPerLiter =        "mmol/L"
    case both =                      "both"
}

enum SugahSpeed: String {
    case tortoise = "tortoise"
    case normal = "Normal"
    case hare = "hare"
    
    var speedValue: Float {
           switch self {
           case .tortoise:
               return 0.4
           case .normal:
               return 0.5
           case .hare:
               return 0.57
           }
       }
}


let threeSpeeds = ["tortoise", "Normal", "hare"]

//let languageAvaialbeOnToSugah: [String] =  // this is the order in the settings menu
//        ["English", "Japanese", "German"]



enum voiceLanguages: String, CaseIterable, Identifiable{
    
    case usEnglish =    "US English"
    case ukEnglish =    "UK English"
    case japanese =     "日本語"
    case german =       "Deutsch"
    case italian =      "Italiano"
    case frFrench =     "Français (France)"
    case korean =       "한글"
    case esSpanishF =    "Spanish (Spain)"
    
    var id: String {
        return self.rawValue
        //   case esSpanishM =   "Spanish (Spain)"
    }
}



//enum availableVoiceLanguageCodes: String, CaseIterable, Identifiable{
//
//    case enUS =     "en-US"
//    case enUK =     "en-UK"
//    case japanese = "ja"
//    case german =   "de"
//    case italian =  "it"
//    case frFrench = "fr-FR"
//    case korean =   "ko-KR"
//    case esMX =      "es-US"
//
//    var id: String {
//        return self.rawValue
//    }
//}







enum SecondsIn: Int {
    case oneSecond              =       1
    case fiveSeconds            =       5
    case tenSeconds             =      10
    case thirtySeconds          =      30
    case oneMinute              =      60
    case sixtyOneSeconds        =      61
    case twoMinutes             =     120
    case twoMinutesAndOneSec    =     121
    case fiveMinutes            =     300
    case fiveMinutesPlusOneSec  =     301
    case tenMinutes             =     600
    case twentyMinutes          =    1200
    case thirtyMinutes          =    1800
    case oneHour                =    3600
    case ninetyMinutes          =    5400
    case twoHours               =   7_200
    case twoAndHalfHours        =   9_000
    case threeHours             =  10_800
    case fourHours              =  14_400
    case fourAndHalfHours       =  16_200
    case halfDay                =  43_200
    case oneDay                 =  86_400
    case oneWeek                = 604_800
    
    var timeInterval: TimeInterval {
        return TimeInterval(self.rawValue)
    }
    var ago: Date {
        let now = Date()
        return now.addingTimeInterval(-self.timeInterval)
    }
    
    var fromNow: Date {
        let now = Date()
        return now.addingTimeInterval(self.timeInterval)
    }
    
    var asDouble: Double {
         return Double(self.rawValue)
     }
    
//    examples:
    
//    let fiveMinutesAgo = SecondsIn.fiveMinutes.ago
//    let fiveMinutesFromNow = SecondsIn.fiveMinutes.fromNow
//    let fiveMinutesAsDouble = SecondsIn.fiveMinutes.asDouble

}




