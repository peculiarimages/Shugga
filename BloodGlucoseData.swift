//
//  BloodGlucoseData.swift
//  sugah
//
//  Created by Rodi on 1/23/23.
//

import SwiftUI
import HealthKit
import Foundation
import AVFoundation
import UIKit
import BackgroundTasks
import Combine



enum BloodGlucoseDataError: Error {
    case emptySweetness

}


class BloodGlucoseData: ObservableObject {
    
    
    @AppStorage("deBugModeToggle") public var deBugModeToggle =             false

    @AppStorage("speakInterval_seconds")           public var speakInterval_seconds:               Int =  10 // this is going to be multiples
        // of 10 seconds

    @AppStorage("includeUnit")                     public var includeUnit =                        true
    @AppStorage("userBloodGlucoseUnit")            public var userBloodGlucoseUnit =               BloodGlucoseUnit.milligramsPerDeciliter
    @AppStorage("speakElapsedTime")                public var speakElapsedTime =                   true
    @AppStorage("warnNoFreshData")                 public var warnNoFreshData =                    false
    @AppStorage("$dataTooOldPeriod_min")           public var dataTooOldPeriod_min =               dateTooOldPeriod_min_default
    @AppStorage("threeSpeechSpeed")                public var threeSpeechSpeed =                   defaultThreeSpeechSpeed
    
    @AppStorage("speechVoiceName")                 public var speechVoiceName =                    "Sandy: com.apple.eloquence.en-US.Sandy"
    @AppStorage("sugahLanguageCombinedCodeChosen") public var sugahLanguageCombinedCodeChosen =   "en-US"
    @AppStorage("speechGender")                    public var speechGender =                       "Female"
    @AppStorage("demoMode")                        public var demoMode =                           false
    @AppStorage("skipHundredth")                   public var skipHundredth =                      false
    @AppStorage("mainGlucoseValueDisplaySize")     public var mainGlucoseValueDisplaySize =        200
    @AppStorage("mixToTelephone")                  public var mixToTelephone =                     false
    
    @AppStorage("usesApplicationAudioSession")     public var usesApplicationAudioSession =       false
    @AppStorage("sugahVoiceChosen")                public var sugahVoiceChosen =                   defaultSugahVoice
    @AppStorage("voiceVolume")                     public var voiceVolume: Double =                1.0
    @AppStorage("voiceRate")                       public var voiceRate: Double =                  1.0
    @AppStorage("voicePitch")                      public var voicePitch: Double =                 1.0


    @AppStorage("userAgreedToAgreement")           public var userAgreedToAgreement =              false

    @AppStorage("outputSelectionOption")           public var outputSelectionOption =              outputOptionsDefault

    @AppStorage("shuggaGlucoseTrend")               public var shuggaGlucoseTrend =           false
    @AppStorage("multiplyTrendByTen")               public var multiplyTrendByTen =           false

    @AppStorage("tellMeItsFromBackground")               public var tellMeItsFromBackground =                 true
    @AppStorage("sugahLanguageChosen")     public var sugahLanguageChosen =         defaultSugahLanguage

    
    @AppStorage("shuggaRepeats")          public var shuggaRepeats =                     true

   
    static let shared = BloodGlucoseData()
    
    
    
    
    internal init() {
        // self.startDebugTimer()
//        checkForPermission()
        
        checkForPermission_old()
        
        checkForPermission { [self] result in
            switch result {
            case .success(let isAuthorized):
                if isAuthorized {
                    print("Permission granted")
                    // You can proceed with fetching or using HealthKit data here
                } else {
                    print("Permission denied")
                    // Handle the case where the user hasn't granted permission
                }
            case .failure(let error):
                print("Error occurred: \(error)")
                // Handle the error case here
            }
            DispatchQueue.main.async {

            self.remainingPauseTime = Double(pauseForX_min * SecondsIn.oneMinute.rawValue)
        }
            if self.as_pauseStartTime > 0 {
                self.startPauseSugahTimer()
                
            }
        }

        
        requestBloodGlucoseAuthorization()
        
        requestStepsAuthorization()
        
        startMainSugahTimer()
        
//        startMonitoringBloodGlucose()
        //enableHKBackgroundDelivery()
        
        fetchLatestBloodGlucoseAndSpeak(whoCalledTheFunction: .healthKitBackgroundDelivery) { success in
            if success {
                print("HKBackgroundDelivery Init: Latest blood glucose fetched and spoken successfully! 654 \(WhoCalledTheFunction.healthKitBackgroundDelivery.rawValue)")
            } else {
                print("Failed to fetch or speak latest blood glucose.443")
            }
        }

       // startMonitoringStepCount()
        
    } // init()
    
     
    
    
    
    
    
    
    
    let theTranslator = TheTranslator()
    let theAppVoices = TheAppVoices()
  //  let thePlayer = TTS()
    
 //   let stepCountData = StepCountData()
        
    let healthStore = HKHealthStore()
    
    @Published var glucoseMonitorModel = GlucoseMonitorModel()
    
    @Published var numberOfTimesBackgroundTaskCalledThis =              0
    
//    @Published var glucoseValue: Double = 0
    
    @Published var manySweetnesses = ManySweetnesses(){
        didSet {
            updateNextBloodGlucoseCheckInUnixTimestamp()
            
        }
        
    }
    
    @Published var appScenePhase: ScenePhase = .inactive
    
    @Published var lastTimeBloodGlucoseWasAnnounced: Double? // timeIntervalSince1970 timestamp
    @Published var lastSweetnessThatWasAnnounced: Sweetness?
    
    @Published var isFetching = false
    
    @Published var theIntervalOfCGM: Double =                           300 // seconds
    
    @Published var theLastBackGroundAppRefreshRequested:                Double?  // unix 1970 time in seconds when it was last requested. return Jan 1 1970  16:00:00 if nil
    
    @Published var nextBloodGlucoseCheckInUnixTimestamp:                Double?
    
    @Published var nextBloodGlucoseCheckInUnixTimestampHumanReadable:   String = ""

    @Published var theHealthKitIsAvailableOnThisDevice: Bool =          false
    
    @Published var userApprovedHealthKitBloodGlucose_Read: Bool =          false
    
    @Published var mainViewBloodDropletWarningFlag = false
    
    let healthStoreWrapper = HealthStoreWrapper()
    
    var timer: Timer?
    
    
    
    
    
    
    
    
    
    @AppStorage("pauseForX_min")                   public var pauseForX_min =                     pauseShuggaDefault_min
    @AppStorage("pauseNow")                   public var pauseNow =                     false
    @Published var pauseTimer: Timer?
    @Published var remainingPauseTime: TimeInterval = 0
    private var cancellables: Set<AnyCancellable> = []
    
    @AppStorage("as_pauseStartTime") public var as_pauseStartTime: Double = 0
    @AppStorage("as_pauseDuration") public var as_pauseDuration: TimeInterval = 0

    
    
    
    
    
    
    
    
    
    
    
    var anchor = HKQueryAnchor(fromValue: 0)
    
    
    //var debugTimer: Timer?
    
    var backgroundDebugTask: UIBackgroundTaskIdentifier?
    
    var appIsInForeground = true
    var lastKnownForegroundEntryDate:  Date = rodisBirthday
    var lastBloodGlucoseFetchDate: Date = rodisBirthday
    
    var theDataMayBeTooOldBecauseOfHealthQueryError: Date = rodisBirthday
    // the last known system time before it went to background
    // Date.init() // date and time using the current time zone
    
    @Published var theNextBackgroundTaskEarliestBeginDate: Date?
    
    
    var shuggaStatus =  ShuggaStatus.shared
    
    var speech = Speech.shared
    let carbohydrateData = CarbohydrateData.shared

    
    
    
    //  END OF VAR =====================================================================
    
    
    
    
    
    
    
    //  METHODS =====================================================================

    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    private func enableHKBackgroundDelivery () {
        
        healthStore.enableBackgroundDelivery(
            for: bloodGlucoseHKSampleType,
            frequency: .immediate) { (success, error) in
                if let error = error {
                    printTimestamp(description: "KBackgroundDelivery", content: "❌ Error enabling background delivery: \(error.localizedDescription)", label: "🏥❌ ",  passedError: error)
                } else {
                    printTimestamp(description: "KBackgroundDelivery", content: "✅🏥 Background delivery for blood glucose enabled", label: "🏥🏥 ")
                }
            }
    }
    // ####################################################################################################################

    
    func startBloodGlucoseObserverQuery(withCompletion completion: @escaping () -> Void) {
        
        printTimestamp(description: "startBloodGlucoseObserverQuery", content: "method started", label: "🏥M ")

        
        let limit = 5 // latest only, but want to explore getting a larger set
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let startDate = Date().addingTimeInterval(-1 * Double(SecondsIn.halfDay.rawValue))
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: [])

        
        DispatchQueue.main.async {
            self.shuggaStatus.theAppState = .hkBackgroundDelivery
        }
        
        let query = HKObserverQuery(
            sampleType: bloodGlucoseHKSampleType,
            predicate: predicate,
            updateHandler: { (query, completionHandler, error) in
                defer {
                    
                    
                    
                    printTimestamp(description: "✅🏥 ヘルス call", content: "startBloodGlucoseObserverQuery", label: "🏥　")
                    
                    self.fetchLatestBloodGlucoseAndSpeak(whoCalledTheFunction: .HKObserverQuery) { success in
                        if success {
                            print("Latest blood glucose fetched and spoken successfully!")
                        } else {
                            print("Failed to fetch or speak latest blood glucose.")
                        }
                    }
                    completionHandler()
                }
                
                guard error == nil else {
                    print("An error occurred while observing blood glucose samples: \(error!)")
                    return
                }
                
                
                
                let sortDescriptors = [sortDescriptor]
                
              
            }
        )
        
        healthStore.execute(query)
    }
    // ####################################################################################################################

    
    
    
    private func checkForPermission_old() {
            let bloodGlucoseType = HKObjectType.quantityType(forIdentifier: .bloodGlucose)
            
            switch HKHealthStore.isHealthDataAvailable() {
            case true:
                healthStore.requestAuthorization(toShare: nil, read: [bloodGlucoseType!]) { (success, error) in
                    if !success {
                        DispatchQueue.main.async {
                            
                            self.userApprovedHealthKitBloodGlucose_Read = false
                        }
                        print("Error requesting authorization: \(error?.localizedDescription ?? "Unknown error")")
                    } else {
                        print("Permission granted to read blood glucose data")
                        DispatchQueue.main.async {
                            self.theHealthKitIsAvailableOnThisDevice = true
                            self.userApprovedHealthKitBloodGlucose_Read = true
                        }                    }
                }
            case false:
                self.userApprovedHealthKitBloodGlucose_Read = false

                print("Health data not available on this device")
            }
        }
        
    
    
    

    /*  OLD
    
    private func checkForPermission() {
            let bloodGlucoseType = HKObjectType.quantityType(forIdentifier: .bloodGlucose)
            
            switch HKHealthStore.isHealthDataAvailable() {
            case true:
                healthStore.requestAuthorization(toShare: nil, read: [bloodGlucoseType!]) { (success, error) in
                    if !success {
                        self.userApprovedHealthKitBloodGlucose_Read = false

                        print("Error requesting authorization: \(error?.localizedDescription ?? "Unknown error")")
                    } else {
                        print("Permission granted to read blood glucose data")
                        DispatchQueue.main.async {
                            self.theHealthKitIsAvailableOnThisDevice = true
                            self.userApprovedHealthKitBloodGlucose_Read = true
                        }                    }
                }
            case false:
                self.userApprovedHealthKitBloodGlucose_Read = false

                print("Health data not available on this device")
            }
        }
        
    
    private func checkForPermission(completion: @escaping (Result<Bool, BloodGlucoseError>) -> Void) {
        let bloodGlucoseType = HKObjectType.quantityType(forIdentifier: .bloodGlucose)
        
        switch HKHealthStore.isHealthDataAvailable() {
        case true:
            healthStore.requestAuthorization(toShare: nil, read: [bloodGlucoseType!]) { (success, error) in
                if !success {
                    DispatchQueue.main.async {
                        self.userApprovedHealthKitBloodGlucose_Read = false
                    }
                    if let error = error {
                        print("Error requesting authorization: \(error.localizedDescription)")
                        DispatchQueue.main.async {
                            self.userApprovedHealthKitBloodGlucose_Read = false
                        }
                        completion(.failure(.fetchError(error)))
                    } else {
                        DispatchQueue.main.async {
                            self.userApprovedHealthKitBloodGlucose_Read = false
                        }
                        completion(.failure(.userPermissionNotGranted))
                    }
                } else {
                    print("Permission granted to read blood glucose data")
                    DispatchQueue.main.async {
                        self.theHealthKitIsAvailableOnThisDevice = true
                        self.userApprovedHealthKitBloodGlucose_Read = true
                    }
                    completion(.success(true))
                }
            }
        case false:
            DispatchQueue.main.async {
                
                self.userApprovedHealthKitBloodGlucose_Read = false
            }
            completion(.failure(.userPermissionNotGranted))
        }
    }


    */
    
    
    private func speakBloodGlucoseError(errorMessage: String, completion: @escaping (Result<Bool, BloodGlucoseError>) -> Void) {
        
        self.speech.speakAnything(speechString: errorMessage, typesOfSpeech: .bloodGlucoseValue,   completion: { [weak self] result in
            guard let self = self else { return } // Safely unwrap self
            
            switch result {
                
            case .success:
                print("Speech finished successfully")
                
                // check for any new blood glucose while speaking:
                self.fetchLatestBloodGlucose(whoCalledTheFunction: .afterCompletingSpeaking) { result in
                    switch result {
                    case .success:
                        DispatchQueue.main.async {
                            print("error spoken:  \(errorMessage)")
                        }
                    case .failure(_):
                        print("❌ failed to speak error: \(errorMessage)")
                        self.speech.resetSynth()
                    }
                }
                
                completion(.success(true)) // Call the completion handler with a success result
                
            case .failure(let error):
                
                print("❌ 12 HK permission error Speech failed with error: \(error)")
                self.speech.resetSynth()
                completion(.failure(BloodGlucoseError.speechError(error)))
            }
        })
        
        
        
        
        
        
        completion(.success(true))

        
        
        
    }
    
    
    
    
    private func checkForPermission(completion: @escaping (Result<Bool, BloodGlucoseError>) -> Void) {
        let bloodGlucoseType = HKObjectType.quantityType(forIdentifier: .bloodGlucose)
        
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(.failure(.userPermissionNotGranted))
            return
        }
        
        healthStore.requestAuthorization(toShare: nil, read: [bloodGlucoseType!]) { (success, error) in

            if !success {
                let status = self.healthStore.authorizationStatus(for: bloodGlucoseType!)

                if status == .notDetermined || status == .sharingDenied {
                    DispatchQueue.main.async {
                        self.userApprovedHealthKitBloodGlucose_Read = false
                                                
                        self.speakBloodGlucoseError(errorMessage: "HK permission undertermined") { result in
                            switch result {
                            case .success(let value):
                                print("s\(value)")
                            case .failure(let error):
                                print("\(error)")
                            }
                        }
                    }
                    completion(.failure(.userPermissionNotGranted))
                } else if let error = error {
                    DispatchQueue.main.async {
                        self.userApprovedHealthKitBloodGlucose_Read = false
                                                
                        self.speakBloodGlucoseError(errorMessage: "HK permission not tGranted") { result in
                            switch result {
                            case .success(let value):
                                print("s\(value)")
                            case .failure(let error):
                                print("\(error)")
                            }
                        }
                    }
                    completion(.failure(.fetchError(error)))
                } else {
                    DispatchQueue.main.async {
                        self.userApprovedHealthKitBloodGlucose_Read = false
                        
                        self.speakBloodGlucoseError(errorMessage: "HK permission: fetch error") { result in
                            switch result {
                            case .success(let value):
                                print("s\(value)")
                            case .failure(let error):
                                print("\(error)")
                            }
                        }
                    }
                    completion(.failure(.userPermissionNotGranted))
                }
            } else {
                DispatchQueue.main.async {
                    //case .sharingAuthorized:
                    self.userApprovedHealthKitBloodGlucose_Read = true
                }
                completion(.success(true))
            }
        }
    }

    
    
    
    
    
    func updateLastBloodGlucoseFetchDate(completion: (() -> Void)?) {
            DispatchQueue.main.async {
                self.lastBloodGlucoseFetchDate = Date()
                
                DispatchQueue.main.async {
                    completion?()
                }
            }
        }
    
    func requestStepsAuthorization () {
        
        
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
            completionHandler()
        }

        healthStore.execute(observerQuery)
    }

    func checkStepCount(stepsToCount: Double = stepCountCheckInterval) {
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
                }
            }
        }

        healthStore.execute(query)
    }

    func userWalkedMoreThanXSteps(stepsToCount: Double) {
        print("User walked more than \(stepsToCount) steps!")
        
        fetchLatestBloodGlucoseAndSpeak(whoCalledTheFunction: .userWalkedMoreThanXsteps) { success in
            if success {
                print("Latest blood glucose fetched and spoken successfully! \(WhoCalledTheFunction.userWalkedMoreThanXsteps.rawValue)")
            } else {
                print("Failed to fetch or speak latest blood glucose.")
            }
        }
        
    }
    
    
    
    func requestBloodGlucoseAuthorization() {
        let healthStore = HKHealthStore()
        
        guard let bloodGlucoseType = HKQuantityType.quantityType(forIdentifier: .bloodGlucose) else {
            print("Blood glucose type is no longer available in HealthKit")
            return
        }
        
        let typesToShare = Set<HKSampleType>()
        let typesToRead = Set<HKObjectType>([bloodGlucoseType])
        
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (success, error) in
            if success {
                print("HK Authorization granted")
                DispatchQueue.main.async {
                    self.theHealthKitIsAvailableOnThisDevice = true
                    self.userApprovedHealthKitBloodGlucose_Read = true
                }
            } else {
                DispatchQueue.main.async {
                    
                    self.userApprovedHealthKitBloodGlucose_Read = false
                }
                print("Authorization denied")
                if let error = error {
                    DispatchQueue.main.async {
                        
                        self.userApprovedHealthKitBloodGlucose_Read = false
                    }
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    
    
    
    
    
    
    
    func startMainSugahTimer () {
        print ("startMainSugahTimer")
        self.timer = Timer.scheduledTimer(withTimeInterval: Double(speakInterval_seconds), repeats: true) { [weak self] _ in
            
            self?.fetchLatestBloodGlucoseAndSpeak(whoCalledTheFunction: .mainTimer) { success in
                if success {
                    print("Latest blood glucose fetched and spoken successfully! \(WhoCalledTheFunction.mainTimer.rawValue)")
                } else {
                    print("Failed to fetch or speak latest blood glucose.")
                }
            }
        }
    }
    
    
    
    
    
    
    func startPauseSugahTimer() {
        
        if pauseNow {
            if as_pauseStartTime == 0 { // a fresh pause timer
                
                as_pauseStartTime = Date().timeIntervalSince1970
                as_pauseDuration = Double(pauseForX_min * SecondsIn.oneMinute.rawValue)
            }
            else {
                as_pauseDuration = Double(pauseForX_min * SecondsIn.oneMinute.rawValue)
            }
            
            let timeElapsed = Date().timeIntervalSince1970 - as_pauseStartTime
            
            self.pauseTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                
                let timeElapsed = Date().timeIntervalSince1970 - as_pauseStartTime
                self.remainingPauseTime = as_pauseDuration - timeElapsed
                //  remainingPauseTime =  10,100 - 10,000 = 100
                
                if self.remainingPauseTime <= 0 {
                    self.pauseNow = false
                    self.stopPauseSugahTimer()
                    as_pauseDuration = 0
                    as_pauseStartTime = 0
                }
            }
            
            //           // Observe app state changes
            //           NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
            //               .sink { [weak self] _ in self?.stopPauseSugahTimer() }
            //               .store(in: &cancellables)
            //
            //           NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
            //               .sink { [weak self] _ in self?.startPauseSugahTimer() }
            //               .store(in: &cancellables)
        }
        else
        {return}
    }
    
    
    
    
    
    
    
    
    func stopMainSugahTimer() {
        // stop the timer if it's running
        print ("stopMainSugahTimer")
        self.timer?.invalidate()
        self.timer = nil
    }
    
    func stopPauseSugahTimer() {
        // stop the timer if it's running
        print ("stopMainSugahTimer")
        self.pauseTimer?.invalidate()
        self.pauseTimer = nil
        as_pauseDuration = 0
        as_pauseStartTime = 0
    }
    
    
    
    
    
    
    func setMainSugarTimerInterval() {
        // stop the old timer
        stopMainSugahTimer()
        
        // update the interval
        
        // start a new timer with the updated interval
        startMainSugahTimer()
    }
    
    func setPauseSugarTimerInterval() {
        // stop the old timer
        stopPauseSugahTimer()
        
        // update the interval
        
        // start a new timer with the updated interval
        startPauseSugahTimer()
    }
    
    
    
    
    
    
    
    
    func startDebugTimer() {
        backgroundDebugTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundDebugTask()
        }
        timer = Timer.scheduledTimer(withTimeInterval: 15, repeats: true) { [weak self] _ in
            printTimestamp(description: "debug timer output: next CGM Check time", content: String(self?.nextBloodGlucoseCheckInUnixTimestamp ?? -0.42), label: "CGM1")
        }
    }
    
    func endBackgroundDebugTask() {
        UIApplication.shared.endBackgroundTask(backgroundDebugTask!)
        backgroundDebugTask = UIBackgroundTaskIdentifier.invalid
    }
    
    func updateNextBloodGlucoseCheckInUnixTimestamp() {
        print ("nextBloodGlucoseCheckInUnixTimestamp")
        guard let theLastTimeFromCGM = manySweetnesses.sweetnesses?.last?.startTimestamp else {
            let date = Date()
            let returnDate = date.timeIntervalSinceReferenceDate + theIntervalOfCGM
            
            DispatchQueue.main.async {
                
                self.nextBloodGlucoseCheckInUnixTimestamp = returnDate + 1
                self.nextBloodGlucoseCheckInUnixTimestampHumanReadable = timeStampToLocal_hh_mm_ss(timestamp: self.nextBloodGlucoseCheckInUnixTimestamp ?? -0.43)
            }
            return
        }
        
        var theNextTimeToCheck = theLastTimeFromCGM + theIntervalOfCGM
        
        if theNextTimeToCheck < Date().timeIntervalSince1970 {
            
            theNextTimeToCheck = Date().timeIntervalSince1970 + theIntervalOfCGM
        }
        
        print (timeStampToLocal_hh_mm_ss(timestamp: theNextTimeToCheck))
        
        DispatchQueue.main.async {
            
            self.nextBloodGlucoseCheckInUnixTimestamp = theNextTimeToCheck + Double(SecondsIn.oneMinute.rawValue)
            self.nextBloodGlucoseCheckInUnixTimestampHumanReadable = timeStampToLocal_hh_mm_ss(timestamp: self.nextBloodGlucoseCheckInUnixTimestamp ?? -0.44)
          //  printTimestamp(description: "updateNextBloodGlucoseCheckInUnixTimestamp", content: String(self.nextBloodGlucoseCheckInUnixTimestamp ?? -0.44), label: "CGM3")
        }
    }
    
    
    
    
    func returnSecondsToCheckCGM() -> Double {
        
        return (defaultFirstScheduleTaskEarliestInSeconds)
        let paddingForNextCGMreadout: Double = 5
        
        guard let theLastTimeFromCGM = manySweetnesses.sweetnesses?.last?.startTimestamp else {
            //            return  (theIntervalOfCGM)
            return  (defaultFirstScheduleTaskEarliestInSeconds)
        }
        
        let date = Date()
        let timeStamp = date.timeIntervalSince1970
        
        return  (defaultFirstScheduleTaskEarliestInSeconds)
        return (theIntervalOfCGM - (timeStamp - theLastTimeFromCGM) + paddingForNextCGMreadout)
    }
    
    
    
    func secondsSinceTheLastSample() -> Int {
        
        var secondsSinceLastSample: Double = 60
        var theLimit: Int

        if let currentGlucoseMonitor = self.glucoseMonitorModel.currentGlucoseMonitor
        {
            secondsSinceLastSample = Date().timeIntervalSince(Date(timeIntervalSince1970: self.manySweetnesses.sweetnesses?.last?.startTimestamp ?? Date().timeIntervalSince1970 ))
                        
            theLimit = Int (secondsSinceLastSample / currentGlucoseMonitor.samplingSeconds) + 1
            return theLimit
        }
        return oneTimeBloodGlucoseFetchCountLimit
    }
    
    
    
    
    
    func fetchLatestBloodGlucoseAndSpeak(limit: Int = oneTimeBloodGlucoseFetchCountLimit, whoCalledTheFunction: WhoCalledTheFunction = .unassigned, completion: @escaping (Bool) -> Void) {
        
       var theLimit = limit
        
        var secondsSinceLastSample: Double = 60
        
        if let currentGlucoseMonitor = self.glucoseMonitorModel.currentGlucoseMonitor
        {
            
            secondsSinceLastSample = Date().timeIntervalSince(Date(timeIntervalSince1970: self.manySweetnesses.sweetnesses?.last?.startTimestamp ?? Date().timeIntervalSince1970 ))
            
            theLimit = Int (secondsSinceLastSample / currentGlucoseMonitor.samplingSeconds) + 5
        }
                
        let repeatShuggaThisManyTimes = 1...(shuggaRepeats ?  2 : 1)
        
        for _ in repeatShuggaThisManyTimes {
            fetchLatestBloodGlucose(limit: theLimit, whoCalledTheFunction: whoCalledTheFunction) { result in
                switch result {
                    
                case .success:
                    print("fetched. about to speak....")
                    
                    DispatchQueue.main.async {
                        
                        self.speakBloodGlucose(whoCalledTheFunction: whoCalledTheFunction, completion: { result in
                            
                            switch result {
                                
                            case .success:
                                print("fetchLatestBloodGlucoseAndSpeak finished successfully")
                                completion(true)
                                
                            case .failure(let error):
                                print("❌ 144 fetchLatestBloodGlucoseAndSpeak failed with error: \(error)")
                                self.speech.resetSynth()
                                
                                if thisIsBeta {self.speech.speakAnything(speechString: "fetch Latest Blood Glucose And Speak Speak portion failed ", typesOfSpeech: .bloodGlucoseValue,   completion: { [weak self] result in
                                    guard let self = self else { return } // Safely unwrap self
                                    switch result {
                                    case .success:  print ("9355")
                                        return
                                    case .failure(let error):
                                        self.speech.speakAnything(speechString: "Failed to speak fetch Latest Blood Glucose And Speak failed : 9355", typesOfSpeech: .error)
                                        print ("9355")
                                    }
                                })
                                }
                                completion(false)
                            }
                        }
                        )
                    }
                    
                case .failure(let error):
                    print("❌ 1345 fetchLatestBloodGlucose failed with error: \(error)")
                    self.speech.resetSynth()
                    
                    if thisIsBeta {self.speech.speakAnything(speechString: "1345 fetchLatestBloodGlucose failed with error: \(error)", typesOfSpeech: .bloodGlucoseValue,   completion: { [weak self] result in
                        guard let self = self else { return } // Safely unwrap self
                        switch result {
                        case .success:  print ("1345")
                            return
                        case .failure(let error):
                            self.speech.speakAnything(speechString: "Failed to speak fetch Latest Blood Glucose  failed : 1345", typesOfSpeech: .error)
                            print ("1345")
                        }
                    })
                    }
                    completion(false)
                }
            }
        }
    }
    
    /* HOW TO CALL IT
     
     fetchLatestBloodGlucoseAndSpeak(whoCalledTheFunction: .someValue) { success in
         if success {
             print("Latest blood glucose fetched and spoken successfully!")
         } else {
             print("Failed to fetch or speak latest blood glucose.")
         }
     }
     
     */
    
    
    
    
 /* i have a duplicated method below here with a new nested method to check for the latest glucose after utterance and utter again if new one is found - using weak self.
    
    func speakBloodGlucose (whoCalledTheFunction: WhoCalledTheFunction = .unassigned, completion: ((Result<Void, Error>) -> Void)? = nil) {
            
        /*
         
         call it like this:
         
         
         speakBloodGlucose(completion: { result in
             switch result {
             case .success:
                 print("Speech finished successfully")
             case .failure(let error):
                 print("Speech failed with error: \(error)")
             }
         })
         
         */
        
        
        
        
        
        var diabetes = Diabetes()
        var shuggaUtterance: String = ""
        var sampleTime: Date

        // ... rest of the method code ...

        // NEW BITS
        let synthSpeechParameters =  SynthSpeechParameters()

        if let theSweetness = self.manySweetnesses.sweetnesses?.last {
            sampleTime  = Date(timeIntervalSince1970:  theSweetness.startTimestamp )

            let timeInterval = Int(Date().timeIntervalSince(sampleTime))

            if timeInterval < Int(rodisBirthdayTimeStamp) {
                shuggaUtterance = formatSecondsToTimeString(timeInterval) + "  ago."
            }

            shuggaUtterance = shuggaUtterance + diabetes.returnSpeakableGlucoseValue(sweetness: theSweetness, synthSpeechParameters: synthSpeechParameters, skipHundredth: synthSpeechParameters.skipHundredth)
            print (shuggaUtterance)

            speech.speakAnything(speechString: shuggaUtterance, completion: { result in
                switch result {

                case .success:
                    print("Speech finished successfully")
                    
                    
                    completion?(.success(())) // Call the completion handler with a success result

                case .failure(let error):
                    print("Speech failed with error: \(error)")
                    completion?(.failure(error)) // Call the completion handler with the error
                }
            })

            // ... rest of the method code ...
        }
    }
     
     
*/
    
    
    
    
    
    
    
    
//    func speakBloodGlucose(completion: @escaping (Result<Void, BloodGlucoseError>) -> Void) {

    func speakBloodGlucose(whoCalledTheFunction: WhoCalledTheFunction = .unassigned, completion: @escaping (Result<Void, BloodGlucoseError>) -> Void) {
        var aBackGroundCalledTheFunction = false
        
        if speech.synth.isSpeaking {
            
            speech.stopSpeakingNow()
            speech.resetSynth()
        }
        
        if userAgreedToAgreement {
            let diabetes = Diabetes()
            var shuggaUtterance: String = ""
            
            if   tellMeItsFromBackground &&
                    (   whoCalledTheFunction == .HKObserverQuery
                     || whoCalledTheFunction == .backgroundFetch
                     || whoCalledTheFunction == .backgroundRefresh
                     || whoCalledTheFunction == .aRetryFromBackground
                    )
            {
                aBackGroundCalledTheFunction = true
                switch sugahLanguageChosen {
                    
                case "en":   shuggaUtterance += "From the background, "
                case "ja":   shuggaUtterance += "バックグラウンドより、"
                    
                default:     shuggaUtterance += "From the background, "

                }
            }
            else if thisIsBeta && tellMeItsFromBackground
            {
                shuggaUtterance += whoCalledTheFunction.rawValue
            }
            
            printTimestamp(description: "whoCalledTheFunction#", content: "\(whoCalledTheFunction.rawValue)$", label: "who? ")
            
            if thisIsBeta && deBugModeToggle &&  whoCalledTheFunction != .unassigned {
                shuggaUtterance += " \(whoCalledTheFunction.rawValue). "
            }
            
            let synthSpeechParameters = SynthSpeechParameters()
            
            
           // let letItSettleDelay = 0.5
            
            // Delay execution of code by one second
//            DispatchQueue.main.asyncAfter(deadline: .now() + letItSettleDelay) {
            DispatchQueue.main.async {

                // Add any code that needs to be delayed here
                
             //   print ("delaying \(letItSettleDelay) second(s)...")
            
                if let theSweetness = self.manySweetnesses.sweetnesses?.last {
                
                    if !self.appIsInForeground || self.speakElapsedTime {
                    shuggaUtterance += diabetes.returnSpeakableGlucoseFetchTime(sweetness: theSweetness)
                    shuggaUtterance += " ago: " }
                //
                shuggaUtterance += diabetes.returnSpeakableGlucoseValue(sweetness: theSweetness, synthSpeechParameters: synthSpeechParameters, skipHundredth: synthSpeechParameters.skipHundredth)
                
                shuggaUtterance += diabetes.returnSpeakableGlucoseTrendValue(sweetness: theSweetness, synthSpeechParameters: synthSpeechParameters)
                                
                    self.speech.speakAnything(speechString: shuggaUtterance, typesOfSpeech: .bloodGlucoseValue,   completion: { [weak self] result in
                    guard let self = self else { return } // Safely unwrap self
                    
                    switch result {
                        
                    case .success:
                        print("Speech finished successfully")
                        
            
                        
                        
                        
                            // check for any new blood glucose after speaking:
                        self.fetchLatestBloodGlucose(whoCalledTheFunction: aBackGroundCalledTheFunction ? .aRetryFromBackground : .afterCompletingSpeaking) { result in
                            switch result {
                            case .success:
                                DispatchQueue.main.async {
                                    if self.manySweetnesses.sweetnesses?.last?.assignedID != theSweetness.assignedID { // a new blood glucose
                                        
                                        self.speakBloodGlucose(whoCalledTheFunction: whoCalledTheFunction, completion: { result in
                                            
                                            switch result {
                                            case .success:
                                                print("Speech finished. it's a sequential output since a new value was found after the first utterance ended.")
                                            case .failure(let error):
                                                print("❌ 166 Speech failed with error: \(error)")
                                                self.speech.resetSynth()
                                            }
                                        })
                                    }
                                    print("Latest blood glucose fetched and spoken successfully!412 \(WhoCalledTheFunction.healthKitBackgroundDelivery.rawValue)")
                                }
                            case .failure(_):
                                print("❌ 177Failed to fetch or speak latest blood glucose.")
                                self.speech.resetSynth()
                            }
                        }
                        DispatchQueue.main.async {
                            self.shuggaStatus.shuggaState = .finishedShugga
                        }
                        completion(.success(())) // Call the completion handler with a success result
                        
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self.shuggaStatus.shuggaState = .encounteredErrorWhileShugga
                        }
                        print("❌ 12 Speech failed with error: \(error)")
                        self.speech.resetSynth()
                        completion(.failure(BloodGlucoseError.speechError(error)))
                    }
                })
            }
        }
    }
    }
    
    
    
    
    
    
    
    
    
//    func fetchLatestBloodGlucose(limit: Int, whoCalledTheFunction: WhoCalledTheFunction, completion: @escaping (Result<Void, BloodGlucoseError>) -> Void) {

    
    func fetchLatestBloodGlucose(limit: Int = oneTimeBloodGlucoseFetchCountLimit, lookFurtherBack: Bool = false, whoCalledTheFunction: WhoCalledTheFunction = WhoCalledTheFunction.unassigned, completion: @escaping (Result<Void, BloodGlucoseError>) -> Void) {
        var startDate: Date
        
        var theLimit = limit
        
        startDate =  Date(timeIntervalSinceNow:  Double(-SecondsIn.halfDay.rawValue)) // make sure the value in Double is a negative number in seconds
        // above assumes .appStarted. so just fetches the last 1/2 day of blood glucose
        
        if shuggaStatus.bloodGlucoseFetchState != .appStarted {
            startDate = Date(timeIntervalSinceNow:  -SecondsIn.thirtyMinutes.asDouble) // make sure the value in Double is a negative number in seconds
            // this is a situation during the normal running of the app. just checks the past 30 min.
        }
            
        if lookFurtherBack {
            startDate =  Date(timeIntervalSinceNow:  Double(-SecondsIn.oneDay.rawValue)) } // make sure the value in Double is a negative number in seconds }
        // this is the last resort when there appears to be no data in the past 24hrs.
        
        DispatchQueue.main.async { self.shuggaStatus.bloodGlucoseFetchState = .aboutToFetchBloodGlucose }
        
        if let theLastSweetnessTime = manySweetnesses.sweetnesses?.last?.startTimestamp {
            
            // Change the startDate if theLastSweetness is not nil, to 10 min in the past from the last startTImeStamp
            // hoping this will be quicker than asking for two hours
            if whoCalledTheFunction == .myBackgroundOperation || whoCalledTheFunction == .backgroundRefresh || whoCalledTheFunction == .backgroundTask {  // ignoring two hour regressive analysis changes made to past record
//                startDate = Date(timeIntervalSince1970: theLastSweetnessTime - Double(SecondsIn.tenMinutes.rawValue))
            }
        }
        
        // the following will make theLimit to 1 if the method is being called in the background - no need to get more than the last blood glucose (But this may result in skipped Sweetnesses but we shall see
        if  whoCalledTheFunction == .myBackgroundOperation ||
            whoCalledTheFunction == .backgroundRefresh ||
            whoCalledTheFunction == .backgroundTask ||
            whoCalledTheFunction == .backgroundFetch {  // ignoring two hour regressive analysis changes made to past record
            theLimit = 2
        } else
        { theLimit = HKObjectQueryNoLimit }
        
        //Setting end: nil in the HKQuery.predicateForSamples(withStart:end:options:) method means that the query will include samples from the startDate all the way up to the current time.
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: nil, options: [.strictStartDate])
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: true) // new last ** verified
        
        DispatchQueue.main.async { self.shuggaStatus.bloodGlucoseFetchState = .fetchingBloodGlucose }
        
        let query = HKSampleQuery(sampleType: bloodGlucoseHKSampleType, predicate: predicate, limit: theLimit, sortDescriptors: [sortDescriptor]) { [self] (query, samples, error) in // HKObjectQueryNoLimit instead of limit to get all data inside the predicate
            if let samples = samples, !samples.isEmpty {
                
                
                
       
                            
            let hkSamples = samples.compactMap { $0 as? HKQuantitySample }

                DispatchQueue.main.async {
                    self.userApprovedHealthKitBloodGlucose_Read = true
                    
                    
                    
                    
                    self.manySweetnesses.addQueryDirectly(limit: HKObjectQueryNoLimit , whoCalledTheFunction: whoCalledTheFunction, samples: hkSamples) { (success) in
                        if success {
                                    if let theLastCGM = self.manySweetnesses.sweetnesses?.last?.model {
                                        do {
                                            let glucoseMonitor = try self.glucoseMonitorModel.returnGlucoseMonitor(modelShortName: theLastCGM)
                                            self.glucoseMonitorModel.currentGlucoseMonitor = glucoseMonitor
                                        } catch GlucoseMonitorError.noMatchingGlucoseMonitorShortName(let modelShortName) {
                                            print("Error: No matching glucose monitor with short name: \(modelShortName)")
                                        } catch GlucoseMonitorError.noMatchingGlucoseMonitorFDA_ID(let fdaID) {
                                            print("Error: No matching glucose monitor with FDA ID: \(fdaID)")
                                        } catch GlucoseMonitorError.invalidInput {
                                            print("Error: Both modelShortName and universalDeviceFDA are missing")
                                        } catch {
                                            print("Unexpected error: \(error)")
                                        }
                                    }
                                    
                            
                            
                            
                            
                                        print("Query added successfully")
                                        // Add any other code that needs to be delayed by one second here
                                    
                            
                            
                            
                            
                            
                                } else {
                            print("Query failed")
                            self.speech.speakAnything(speechString: "Query failed", typesOfSpeech: .error)
                        }
                    }
                    
                    
                    
                    
                    
                    
                } // DispatchQueue.main.async
                
                DispatchQueue.main.async { self.shuggaStatus.bloodGlucoseFetchState = .finishedFetchingBloodGlucose }
                completion(.success(()))
                
                
                
            }
            else //             if let samples = samples, !samples.isEmpty {
            //there were no record
            {
                if thisIsBeta {
                    speech.speakAnything(speechString: "Error fetching blood glucose data, sample empty", typesOfSpeech: .bloodGlucoseValue,   completion: { [weak self] result in
                        guard let self = self else { return } // Safely unwrap self
                        
                        switch result {
                            case .success:  print ("6543")
                                            return
                            case .failure(let error):
                            print ("6543f")
                            self.speech.speakAnything(speechString: "Query failed: 6543f", typesOfSpeech: .error)

                        }
                    })
                }
                
                DispatchQueue.main.async { self.shuggaStatus.bloodGlucoseFetchState = .queryResultedInEmptyResult }
                // self.userApprovedHealthKitBloodGlucose_Read = false
                // nest another fetchLatestBloodGlucose a new start time further back in time -> .oneDay
                if whoCalledTheFunction != .firstAttemptToFetchFailed {
                    DispatchQueue.main.async { self.shuggaStatus.theAppState = .appIdle }
                    fetchLatestBloodGlucose(lookFurtherBack: true, whoCalledTheFunction: .firstAttemptToFetchFailed) { result in
                        
                        switch result {
                        case .success:
                            print("By going back a week: Latest blood glucose fetched and spoken successfully!143 \(WhoCalledTheFunction.healthKitBackgroundDelivery.rawValue)")
                            completion(.success(()))
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                        case .failure(_):
                            print("Failed to fetch or speak latest blood glucose.")
                           // self.speech.speakAnything(speechString: "Failed to fetch or speak latest blood glucose: 8394", typesOfSpeech: .error)
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            return
                        }
                    }
                }
                
                if let error = error {
                    
                    if thisIsBeta {self.speech.speakAnything(speechString: "General fetch error 6583", typesOfSpeech: .bloodGlucoseValue,   completion: { [weak self] result in
                        guard let self = self else { return } // Safely unwrap self
                        switch result {
                            case .success:  print ("6583")
                                            return
                            case .failure(let error):
                            self.speech.speakAnything(speechString: "Failed to speak: general fetch error 6583", typesOfSpeech: .error)
                            print ("6583")
                        }
                    })
                    }

                    
                    checkForPermission { result in
                        switch result {
                            case .success(let isAuthorized):
                                if isAuthorized {
                                    print("Permission granted")
                                    // You can proceed with fetching or using HealthKit data here
                                }
                                else {
                                    print("Permission denied")
                                    self.speech.speakAnything(speechString: "Permission denied 6676", typesOfSpeech: .error)

                                    if thisIsBeta {self.speech.speakAnything(speechString: "Permission denied", typesOfSpeech: .bloodGlucoseValue,   completion: { [weak self] result in
                                        guard let self = self else { return } // Safely unwrap self
                                        switch result {
                                            case .success:  print ("6543")
                                                            return
                                            case .failure(let error):
                                            self.speech.speakAnything(speechString: "Failed to speak: 6543", typesOfSpeech: .error)
                                            print ("6543f")
                                        }
                                    })
                                    }
                                }

                            case .failure(let error):
                                print("Error occurred: \(error)")
                                
                                if false
                                {
                                    self.speech.speakAnything(speechString: "Error fetching blood glucose data (-44) \(error)", typesOfSpeech: .bloodGlucoseValue,   completion: { [weak self] result in
                                    guard let self = self else { return } // Safely unwrap self
                                    switch result {
                                        case .success:  print ("6543")
                                                        return
                                        case .failure(let error):
                                        self.speech.speakAnything(speechString: "Failed to speak fetch error code: 6565", typesOfSpeech: .error)
                                        print ("6565")
                                    }
                                })
                            }
                        }
                    }

                    DispatchQueue.main.async { self.shuggaStatus.bloodGlucoseFetchState = .encounteredErrorWhileFetchingBloodGlucose }
                    
                    self.theDataMayBeTooOldBecauseOfHealthQueryError = Date()
                    
                    print("Error fetching blood glucose data: \(error.localizedDescription)")
                    
                    if thisIsBeta  {
                        speech.speakAnything(speechString: "Error fetching blood glucose data: \(error.localizedDescription)", typesOfSpeech: .bloodGlucoseValue,   completion: { [weak self] result in
                            guard let self = self else { return } // Safely unwrap self
                            switch result {
                                case .success: print ("6543")
                                case .failure(let error):
                                print ("6543f")
                                if thisIsBeta {self.speech.speakAnything(speechString: "error 6543", typesOfSpeech: .bloodGlucoseValue,   completion: { [weak self] result in
                                    guard let self = self else { return } // Safely unwrap self
                                    switch result {
                                        case .success:  print ("6543")
                                                        return
                                        case .failure(let error):
                                        self.speech.speakAnything(speechString: "Failed to speak: 6543", typesOfSpeech: .error)
                                        print ("6543f")
                                    }
                                })
                                }

                            }
                        })
                    }
                    completion(.failure(BloodGlucoseError.fetchError(error)))
                    return
                }
            }
        }
        healthStoreWrapper.healthStore.execute(query)
        self.updateNextBloodGlucoseCheckInUnixTimestamp()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    /* deprecated??
     
    func startMonitoringBloodGlucose() {
        guard let bloodGlucoseType = HKQuantityType.quantityType(forIdentifier: .bloodGlucose) else {
            // Blood glucose type is not available on this device
            return
        }
        
        let query = HKObserverQuery(sampleType: bloodGlucoseType, predicate: nil) { query, completionHandler, error in
            if let error = error {
                
                self.theDataMayBeTooOldBecauseOfHealthQueryError = Date()
                print("❌Error monitoring blood glucose: \(error.localizedDescription)")
                return
            }
            
            self.fetchLatestBloodGlucoseAndSpeak(whoCalledTheFunction: .HKObserverQuery) { success in
                if success {
                    print("Latest blood glucose fetched and spoken successfully! \(WhoCalledTheFunction.HKObserverQuery.rawValue)")
                } else {
                    print("Failed to fetch or speak latest blood glucose.")
                }
            }
            
            
            self.healthStore.execute(query)
        }
        
    }
    
    
    
    
    */

    
    
    
    
    
    
    func startBackgroundDelivery(whoCalledTheFunction: WhoCalledTheFunction = .unassigned ) {
        // ...
        
        var thisGlucoseTrendRateValue: Double?
        var thisGlucoseTrendRateUnit: String?
        
        let bloodGlucoseMgDlUnit = HKUnit.gramUnit(with: .milli).unitDivided(by: HKUnit.literUnit(with: .deci))
        let bloodGlucoseType = HKObjectType.quantityType(forIdentifier: .bloodGlucose)!
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: true) // new last
        let startDate = Date(timeIntervalSinceNow: -oneTimeBloodGlucoseFetchSecondsAgo) // don't forget minus (-) sign
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: nil, options: [.strictStartDate])
        // end: nil means that the predicate will retrieve samples up to the current date and time. This is useful if you want to retrieve all the samples that have been recorded up to the point in time when the query is executed.
        // Request permission to read blood glucose data
        healthStoreWrapper.healthStore.requestAuthorization(toShare: nil, read: [bloodGlucoseType]) { (success, error) in
            if success {
                // Create anchored object query for blood glucose samples
                
                
                let query = HKAnchoredObjectQuery(type: bloodGlucoseType, predicate: predicate, anchor: self.anchor, limit: HKObjectQueryNoLimit ) { (query, samples, deletedObjects, newAnchor, error) in
                    
                    // Handle initial results
                    if let samples = samples, !samples.isEmpty {
                        printTimestamp()
                        print ("initial HK Background Delivery")
                        //print (samples)
                        for sample in samples {
                            let glucoseSample = sample as! HKQuantitySample
                            //                            let glucoseValue = glucoseSample.quantity.doubleValue(for: bloodGlucoseMgDlUnit)
                            //  print(glucoseValue)
                        }
                        
                        let sample = samples.last as! HKQuantitySample
//                        DispatchQueue.main.async {
//
//                            self.glucoseValue = sample.quantity.doubleValue(for: bloodGlucoseMgDlUnit)
//
//                        }
                        
                        
                        switch sample.sourceRevision.source.name {
                            
                        case "Dexcom G6":
                            _ = true
                        case "Loop":
                            _ = true
                        default:
                            _ = true

                        }
                        
                        
                        /*
                         
                         Optional(
                         [
                         "com.LoopKit.GlucoseKit.HKMetadataKey.GlucoseTrendRateValue": -0.8,
                         "HKMetadataKeySyncVersion": 1,
                         "com.LoopKit.GlucoseKit.HKMetadataKey.GlucoseTrendRateUnit": mg/min·dL,
                         "com.LoopKit.GlucoseKit.HKMetadataKey.GlucoseTrend": →,
                         "HKMetadataKeySyncIdentifier": 8DLTXK 7936874
                         ])
                         
                         
                         
                         
                         */
                        
                        let deBug = DebugStruct(
                            timeString: timeStampToLocal_hh_mm_ss(timestamp: Date().timeIntervalSince1970),
                            diagnostic: "from: fetchLatestBloodGlucose",
                            startTimestampHumanReadable: timeStampToLocal_hh_mm_ss(timestamp: sample.startDate.timeIntervalSince1970))
                        
                        let sweetness = Sweetness(sweetness: sample.quantity.doubleValue(for: bloodGlucoseMgDlUnit),
                                                  sweetness_string: String(sample.quantity.doubleValue(for: bloodGlucoseMgDlUnit)),
                                                  startTimestamp: sample.startDate.timeIntervalSince1970,
                                                  source_name: sample.sourceRevision.source.name,
                                                  manufacturer: sample.device?.manufacturer ?? "-",
                                                  model: sample.device?.model ?? "-",
                                                  glucoseTrendRateValue: sample.metadata?["com.LoopKit.GlucoseKit.HKMetadataKey.GlucoseTrendRateValue"] as? Double,
                                                  glucoseTrendRateUnit: thisGlucoseTrendRateUnit,
                                                  unit: "mg/dL",
                                                  whoRecorded: whoCalledTheFunction,
                                                  timeRecordedHere: Date().timeIntervalSince1970,
                                                  deBug: deBug

                        )
                        
                        // print ("hkbgDeliv:/nnew: \(sweetness.startTimestamp)    vs     current: \( self.manySweetnesses.sweetnesses?.last?.startTimestamp ?? 0)")
                        
                        _ = self.manySweetnesses.addSweetness(sweetness: sweetness)
                        self.updateNextBloodGlucoseCheckInUnixTimestamp()
                        
                        
//                        printTimestamp(description: "HK BG Delivery: \(whoCalledTheFunction.rawValue)", content: String(self.glucoseValue), label: "HK ")
                        
                    }
                    else
                    {
                        printTimestamp(description: "HK BG Delivery: \(whoCalledTheFunction.rawValue)", content: "sample is empty", label: "HK ")
                    }
                }
                query.updateHandler = { (query, samples, deletedObjects, newAnchor, error) in
                    // Handle updates
                    printTimestamp()
                    print ("--------------------------- updateHandler")
                    
                    if let deletedObjects = deletedObjects, !deletedObjects.isEmpty {
                        // Handle deleted objects
                        // printTimestamp(description: "updateHandler deletedObjects", label: "d ", object: deletedObjects )
                        //printTimestamp(description: "updateHandler samples?.last", label: "d ", object: samples?.last )
                        
                        
                    }
                    
                    if let samples = samples, !samples.isEmpty {
                        // Handle new samples
                        
                        printTimestamp()
                        print ("update")
                        print (samples.last as Any)
                        print ("---------------------------")
        
                    }
                    else
                    {
                        printTimestamp(description: "HK BG delivery", content: "sample is empty", label: "HK")
                    }
                }
                // Start the query
                
                
                self.healthStoreWrapper.healthStore.execute(query)
              /*  self.timer = Timer.scheduledTimer( withTimeInterval: self.theIntervalOfCGM, repeats: true) { _ in
                    //                    self.healthStoreWrapper.healthStore.stop(query)
                    self.healthStoreWrapper.healthStore.execute(query)
                } */
            }
        }
    }
}




/*
 
 from dexcom regression
 
 402B8B7D-A9C4-41AF-962E-1495FEC26389
 251
 mg/dL
 402B8B7D-A9C4-41AF-962E-1495FEC26389
 "Dexcom G6"
 (17375),
 "iPhone12,5"
 (16.2)
 
 metadata: {
 HKDeviceName = 10386270000221;
 HKTimeZone = "America/Los_Angeles";
 Status = "IN_RANGE";
 "Transmitter Time" = "2023-02-02 08:49:29 +0000";
 "Trend Arrow" = Flat;
 "Trend Rate" = "-0.5";
 }
 (2023-02-02 00:49:29 -0800 - 2023-02-02 00:49:29 -0800)
 
 <HKSourceRevision name:Dexcom G6, bundle:com.dexcom.G6, version:17375, productType:iPhone12,5, operatingSystemVersion:16.2>
 
 
 26C00DBB-364F-44FA-9312-296F8D05491C
 149
 mg/dL
 26C00DBB-364F-44FA-9312-296F8D05491C
 "Loop"
 (57),
 "iPhone12,5"
 (16.2)
 "CGMBLEKit"
 
 metadata: {
 HKMetadataKeySyncIdentifier = "8DLTXK 7939874";
 HKMetadataKeySyncVersion = 1;
 "com.LoopKit.GlucoseKit.HKMetadataKey.GlucoseTrend" = "\U2192";
 "com.LoopKit.GlucoseKit.HKMetadataKey.GlucoseTrendRateUnit" = "mg/min\U00b7dL";
 "com.LoopKit.GlucoseKit.HKMetadataKey.GlucoseTrendRateValue" = 0;
 
 }
 (2023-02-02 17:19:31 -0800 - 2023-02-02 17:19:31 -0800)
 
 <HKSourceRevision name:Loop, bundle:com.8GCPJMPAY8.loopkit.Loop, version:57, productType:iPhone12,5, operatingSystemVersion:16.2>
 
 
 */
