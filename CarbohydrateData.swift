//
//  CarbohydrateData.swift
//  Shugga
//
//  Created by Rodi on 3/27/23.
//

import Foundation
import HealthKit
import SwiftUI

struct Carb: Equatable, Hashable {
    var id = UUID()
    var amount: Double?
    var date: Date?
    var source: String?
    var foodType: String?

    var reminderExpectationAresMet: Bool = false
    
    static func == (lhs: Carb, rhs: Carb) -> Bool {
        return lhs.id == rhs.id
            && lhs.amount == rhs.amount
            && lhs.date == rhs.date
            && lhs.source == rhs.source
            && lhs.foodType == rhs.foodType
    }
}


class CarbohydrateData: ObservableObject {
    
//    @ObservedObject var bloodGlucoseData =  BloodGlucoseData.shared

    @AppStorage("reminderAfterFood_30Min")         public var reminderAfterFood_30Min =  false
    @AppStorage("reminderAfterFood_60Min")         public var reminderAfterFood_60Min =  false
    @AppStorage("reminderAfterFood_90Min")         public var reminderAfterFood_90Min =  true
    @AppStorage("reminderAfterFood_120Min")        public var reminderAfterFood_120Min = false
    @AppStorage("reminderAfterFood_150Min")        public var reminderAfterFood_150Min = false
    @AppStorage("reminderAfterFood_180Min")        public var reminderAfterFood_180Min = false
    @AppStorage("reminderAfterFood_210Min")        public var reminderAfterFood_210Min = false
    @AppStorage("reminderAfterFood_240Min")        public var reminderAfterFood_240Min = false

    let healthStore = HKHealthStore()
    let carbohydrateConsumptionType = HKQuantityType.quantityType(forIdentifier: .dietaryCarbohydrates)!
    
    @Published  var carbs: [Carb] = []
    @Published var carbHistoryPermissionsNoticeView: Bool = false
    
    static let shared = CarbohydrateData()
    
    var timer: Timer?
    var speech = Speech.shared
    
//    @ObservedObject var bloodGlucoseData =  BloodGlucoseData.shared

//    var diabetes = Diabetes()
    
    

    init() {
        // Initialize all stored properties first
        self.carbs = []
        // Then call the instance method
        askForHealthKitCarbohydrateConsumptionPermission()
        startMainCarbTimer()
    }
    
    
    
    
    
    /*
     
     let date1 = Date()
     let date2 = Date().addingTimeInterval(60) // Adds 60 seconds to the current date

     let timeInterval = date1.timeIntervalSince(date2)
     
     */
    
    func accessParentData() {
           let bloodGlucoseData = BloodGlucoseData.shared
       }
    
    func speakCarbReminder(carb: Carb, completion: @escaping (Result<Void, BloodGlucoseError>) -> Void) {
     

        // Define the speech string based on the carb parameter
        let carbAmount = carb.amount ?? 0
        let carbDate = carb.date ?? Date()
        let timeInterval = Int(Date().timeIntervalSince(carbDate))
                

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("hmma")

        let dateString = dateFormatter.string(from: carb.date ?? Date()).lowercased()
        
        var finalSpeak =  formatSecondsToTimeString(seconds: Int(timeInterval), cutOffAt: CutOffAt.none) + "  ago."
 // one hour and five minutes ago

        finalSpeak += ", \(Int(carb.amount ?? 0)) " //58
        finalSpeak += (carb.amount ?? 0) > 1 ? "grams" : "gram" // grams
        finalSpeak += " of carb was consumed at"
        finalSpeak += dateString // five thirty nine
        finalSpeak += ". No new blood glucose data is available since the consumption."
       
        self.speech.speakAnything(speechString: finalSpeak, typesOfSpeech: .carbReminder, completion: { result in
        DispatchQueue.main.async {
            self.speech.speakingImportantShugga = true
        }
            switch result {
            case .success:
                print("Speech finished successfully")
                DispatchQueue.main.async {
                    self.speech.speakingImportantShugga = false
                    
                }
            case .failure(let error):
                print("Speech failed with error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    
                    self.speech.speakingImportantShugga = false
                }

            }
        })
    }

    

    func isItTimeToRemindAboutBloodGlucose() -> Void {
        
        let bloodGlucoseData = BloodGlucoseData.shared

        let timeNow = Date()
        
        var mainViewBloodDropletWarningFlag = false
        for carb in self.carbs {
            
            let newestBloodGlucoseInterval =  Int(Date().timeIntervalSince1970) - Int(bloodGlucoseData.manySweetnesses.sweetnesses?.last?.startTimestamp ?? 0)
            
            let timeInterval = timeNow.timeIntervalSince(carb.date ?? Date())
            
            print ("\(newestBloodGlucoseInterval) >  \(Int(timeInterval)) ???")

            if newestBloodGlucoseInterval > Int(timeInterval) { // SHOULD BE GREATER THAN (in case ive been testing)
                
                switch timeInterval {
                    
                    
                case (SecondsIn.thirtyMinutes.asDouble)...(SecondsIn.oneHour.asDouble):
                    if  self.reminderAfterFood_30Min {
                        mainViewBloodDropletWarningFlag = true
                        self.speakCarbReminder(carb: carb, completion: { result in
                            switch result {
                            case .success:
                                print("30 min carb Speech finished.")
                            case .failure(let error):
                                print("❌ 1643 carb failed with error: \(error)")
                            }
                        })
                        print ("reminderAfterFood_30Min✅")
                    }
                    print("30-60 min since carb but not to be reminded...")
                    
                    
                    
                case (SecondsIn.oneHour.asDouble)...(SecondsIn.ninetyMinutes.asDouble):
                    if  self.reminderAfterFood_60Min {
                        mainViewBloodDropletWarningFlag = true

                        self.speakCarbReminder(carb: carb, completion: { result in
                            switch result {
                            case .success:
                                print("60 min carb Speech finished.")
                            case .failure(let error):
                                print("❌ 1646 carb failed with error: \(error)")
                            }
                        })
                        print ("reminderAfterFood_60Min✅")
                    }
                    print("60-90 min since carb but not to be reminded...")
                    
                    
                    
                case (SecondsIn.ninetyMinutes.asDouble)...(SecondsIn.twoHours.asDouble):
                    if  self.reminderAfterFood_90Min {
                        mainViewBloodDropletWarningFlag = true

                        self.speakCarbReminder(carb: carb, completion: { result in
                            switch result {
                            case .success:
                                print("90 min carb Speech finished.")
                            case .failure(let error):
                                print("❌ 1649 carb failed with error: \(error)")
                            }
                        })
                        print ("reminderAfterFood_90Min✅")
                    }
                    print("90-120 min since carb but not to be reminded...")

                    
                    
                case (SecondsIn.twoHours.asDouble)...(SecondsIn.twoAndHalfHours.asDouble):
                    if  self.reminderAfterFood_120Min {
                        mainViewBloodDropletWarningFlag = true

                        self.speakCarbReminder(carb: carb, completion: { result in
                            switch result {
                            case .success:
                                print("120 min carb Speech finished.")
                            case .failure(let error):
                                print("❌ 16412 carb failed with error: \(error)")
                            }
                        })
                        print ("reminderAfterFood_150Min✅")
                    }
                    print("120-150 min since carb but not to be reminded...")
                    
                    
                case (SecondsIn.twoAndHalfHours.asDouble)...(SecondsIn.threeHours.asDouble):
                    if  self.reminderAfterFood_150Min {
                        mainViewBloodDropletWarningFlag = true

                        self.speakCarbReminder(carb: carb, completion: { result in
                            switch result {
                            case .success:
                                print("150 min carb Speech finished.")
                            case .failure(let error):
                                print("❌ 16415 carb failed with error: \(error)")
                            }
                        })
                        print ("reminderAfterFood_150Min✅")
                    }
                    print("150-180 min since carb but not to be reminded...")
                    
                    
                    
                case (SecondsIn.threeHours.asDouble)...(SecondsIn.fourHours.asDouble):
                    if  self.reminderAfterFood_180Min {
                        mainViewBloodDropletWarningFlag = true

                        self.speakCarbReminder(carb: carb, completion: { result in
                            switch result {
                            case .success:
                                print("180 min carb Speech finished.")
                            case .failure(let error):
                                print("❌ 16418 carb failed with error: \(error)")
                            }
                        })
                        print ("reminderAfterFood_180Min✅")
                    }
                    print("180-210 min since carb but not to be reminded...")
                    
                    
                case (SecondsIn.fourHours.asDouble)...(SecondsIn.fourAndHalfHours.asDouble):
                    if  self.reminderAfterFood_210Min {
                        mainViewBloodDropletWarningFlag = true

                        self.speakCarbReminder(carb: carb, completion: { result in
                            switch result {
                            case .success:
                                print("210 min carb Speech finished.")
                            case .failure(let error):
                                print("❌ 16421 carb failed with error: \(error)")
                            }
                        })
                        print ("reminderAfterFood_240Min✅")
                    }
                    print("210-240 min since carb but not to be reminded...")
                    
                    
                    
                    
                    
                default:
//
//                    let carbInstance = Carb(amount: 50.0, date: Date(timeIntervalSinceNow: -SecondsIn.thirtyMinutes.asDouble), source: "test", foodType: "test food type")
//
//                    self.speakCarbReminder(carb: carbInstance, completion: { result in
//                        switch result {
//                        case .success:
//                            print("60 min carb Speech finished.")
//                        case .failure(let error):
//                            print("❌ 1646 Speech failed with error: \(error)")
//                        }
//                    })
                    print("default")
                }
            } // switch
            
            
            
            if  mainViewBloodDropletWarningFlag == true {
                
                DispatchQueue.main.async {
                    
                    bloodGlucoseData.mainViewBloodDropletWarningFlag = true
                }
            }
            else {
                DispatchQueue.main.async {
                    
                    bloodGlucoseData.mainViewBloodDropletWarningFlag = false
                }
            }

            
            
        }
    }


    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func askForHealthKitCarbohydrateConsumptionPermission() {
        let carbohydrateConsumptionType = HKQuantityType.quantityType(forIdentifier: .dietaryCarbohydrates)!
        healthStore.requestAuthorization(toShare: nil, read: [carbohydrateConsumptionType]) { success, error in
            if success {
                print("User granted permission to read carbohydrate consumption data")
                DispatchQueue.main.async { self.carbHistoryPermissionsNoticeView = true }
            } else {
                print("User denied permission to read carbohydrate consumption data, or an error occurred")
                DispatchQueue.main.async {  self.carbHistoryPermissionsNoticeView = false }
            }
        }
    }
    
    
    
    func checkAuthorizationAndFetchCarbohydrates(completionHandler: @escaping (Result<[Carb], Error>) -> Void) {
        let carbohydrateConsumptionType = HKQuantityType.quantityType(forIdentifier: .dietaryCarbohydrates)!

        healthStore.requestAuthorization(toShare: nil, read: Set([carbohydrateConsumptionType])) { success, error in
            if success {
                self.getCarbohydrateConsumptionRecords(completionHandler: completionHandler)
            } else {
                DispatchQueue.main.async { self.carbHistoryPermissionsNoticeView = false }
                completionHandler(.failure(error ?? NSError(domain: "CarbohydrateData", code: 2, userInfo: [NSLocalizedDescriptionKey: "Authorization failed"])))
            }
        }
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func startMainCarbTimer () {
        print ("startMainCarbTimer")
        self.timer = Timer.scheduledTimer(withTimeInterval: Double(SecondsIn.fiveMinutes.asDouble), repeats: true) { [weak self] _ in
            DispatchQueue.main.async {
                
                self?.isItTimeToRemindAboutBloodGlucose()
            }
        }
    }
    
    
    
    
    func stopMainCarbTimer() {
        // stop the timer if it's running
        print ("stopMainCarbTimer")
        self.timer?.invalidate()
        self.timer = nil
    }
    
    
    func setMainCarbTimerInterval() {
        // stop the old timer
        stopMainCarbTimer()
        // update the interval
        // start a new timer with the updated interval
        startMainCarbTimer()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func getCarbohydrateConsumptionRecords(completionHandler: @escaping (Result<[Carb], Error>) -> Void) {
        
        
        
        let carbohydrateConsumptionType = HKQuantityType.quantityType(forIdentifier: .dietaryCarbohydrates)!
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        
        let startDate = Date(timeIntervalSinceNow: -SecondsIn.oneDay.asDouble) // make sure the value in Double in a negative number in seconds
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: nil, options: [.strictStartDate])
        
        let query = HKSampleQuery(sampleType: carbohydrateConsumptionType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { query, results, error in
           
            guard let results = results else {
                completionHandler(.failure(error ?? NSError(domain: "CarbohydrateData", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])))
                
                DispatchQueue.main.async { self.carbHistoryPermissionsNoticeView = false }
                
                return
            }
            DispatchQueue.main.async {
                
                self.carbs = []
            }
            var carbs: [Carb] = []
            
            for sample in results {
                guard let carbohydrateConsumptionSample = sample as? HKQuantitySample else {
                    DispatchQueue.main.async { self.carbHistoryPermissionsNoticeView = false }
                    continue }

                let carbohydrateConsumptionValue = carbohydrateConsumptionSample.quantity.doubleValue(for: HKUnit.gram()) // Changed unit to grams
                let date = carbohydrateConsumptionSample.startDate
                let carb = Carb(amount: carbohydrateConsumptionValue, date: date, source: carbohydrateConsumptionSample.sourceRevision.source.name, foodType: nil)
                printTimestamp(description: "getCarbohydrateConsumptionRecords", content: String(self.carbs.last?.amount ?? 0), label: "🍕1 ")

                DispatchQueue.main.async {

                    self.carbs.append(carb)
                    
                }
                      }
            DispatchQueue.main.async { self.carbHistoryPermissionsNoticeView = true }

                      // Print all Carb objects in the carbs array
                      for carb in carbs {
                          print("Carb ID: \(carb.id), Amount: \(carb.amount ?? 0), Date: \(carb.date ?? Date()), Source: \(carb.source ?? "Unknown"), Food Type: \(carb.foodType ?? "Unknown")")
                      }
            completionHandler(.success(carbs))
        }
        healthStore.execute(query)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

