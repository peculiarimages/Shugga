//
//  Language.model.swift
//  Sugah
//
//  Created by Rodi on 12/21/22.
//

import SwiftUI
import AVFoundation
import HealthKit
import BackgroundTasks


//https://stackoverflow.com/questions/24591167/how-to-get-current-language-code-with-swift

//
//Locale.current returns the current locale, that is, the value set by Settings > General > Language & Region > Region Formats. It has nothing to do with the language that your app is running in. It's perfectly reasonable, and in fact quite common, for users in the field to have their locale and language set to 'conflicting' values. For example, a native English speaker living in France would have the language set to English but might choose to set the locale to French (so they get metric weights and measures, 24 time, and so on).
//The language that your app runs in is determined by the language setting, that is, Settings > General > Language & Region > Preferred Language Order. When the system runs your app it takes this list of languages (the preferred list) and matches it against the list of languages that your app is localized into (the app list). The first language in the preferred list that exists in the app list is the language chosen for the app. This is what you'll find in the first entry of the main bundle's preferredLocalizations array.

func returnElapsedTime(timeSinceUpdateInSeconds: Int, languageCode: String, demoMode: Bool) -> String {
    
        
        
        if demoMode {
            
            return ("a demo device was less than X minutes ago.")
        }
    
//        else if languageCode == "en"

//        {
//            if timeSinceUpdateInSeconds < SecondsIn.twoHours.rawValue {
//                let timeSinceUpdateInMinutes = Int(timeSinceUpdateInSeconds / SecondsIn.oneMinute.rawValue + 1)
//                return "\(recordingDeviceFinal) was less than \(timeSinceUpdateInMinutes) minutes ago."
//                
//            }
//            else if  timeSinceUpdateInSeconds > (SecondsIn.twoHours.rawValue + 10) && timeSinceUpdateInSeconds < SecondsIn.oneDay.rawValue {
//                
//                let timeSinceUpdateInMinutes = Int(timeSinceUpdateInSeconds / SecondsIn.oneMinute.rawValue)
//                return "\(recordingDeviceFinal) was more than \(timeSinceUpdateInMinutes) minutes ago."
//            }
//            else
//            {
//                
//                let timeSinceUpdateInDays = Int(timeSinceUpdateInSeconds / SecondsIn.oneDay.rawValue)
//                return "\(recordingDeviceFinal) was more than 24 hours ago."
//                
//            }
//            // return "\(recordingDeviceFinal) was \(timeSinceUpdateInSeconds) seconds ago."
//            
//        }
        
        
        
        
       // return "en"

        
    
        
        
        
        
        
        return "Error. Something happened in returnElapsedTime function."
    
    
    
    
}






func skipHundrethInEnglish (glucoseValue: Double) -> String
{
    let rawValue_Int = Int(glucoseValue)

    var theValueInString: String
    var theValueInInt_String: [String] = ["#", "$", "%"]
    
    let theValueInInt_Array = rawValue_Int.digits(base: 10)
    
    theValueInInt_String[0] = String(theValueInInt_Array[0])
    
    if rawValue_Int > 100 {
        
        theValueInInt_String[1] = String(theValueInInt_Array[1])
        
        theValueInInt_String[2] = String(theValueInInt_Array[2])
        
        if theValueInInt_String[1] != "0" &&  theValueInInt_String[2]  != "0" {
            
            // print ("String(rawValue_Int):  \(rawValue_Int)")
            String(rawValue_Int)
            
        }
        if theValueInInt_String[2]  == "0"  && theValueInInt_String[1] == "0" {
            
            // print ("String(rawValue_Int):  \(rawValue_Int)")
            return String(rawValue_Int)
            
        }
        if theValueInInt_String[2]  == "0" {
            
            theValueInString = theValueInInt_String[0] + " " + theValueInInt_String[1]  + theValueInInt_String[2]
            // print ("theValueInString:  \(theValueInString)")
            return theValueInString
        }
        else if theValueInInt_String[1] == "0"  {
            
            theValueInString = theValueInInt_String[0] + "O"  + theValueInInt_String[2]
            //print ("theValueInString:  \(theValueInString)")
            return theValueInString
        }
        else
        {
            theValueInString = theValueInInt_String[0] + " " + theValueInInt_String[1]  + theValueInInt_String[2]
            // print ("theValueInString:  \(theValueInString)")
            return theValueInString
        }
    }
    //print ("String(rawValue_Int):  \(rawValue_Int)")
    return String(rawValue_Int)
    
    
    
    
    
    
}

func returnUnitInTheLanguage (languageCode: String, unit: BloodGlucoseUnitByCountries ) -> String
{
//    print ("yyyyyy: \(languageCode.lowercased())")
    switch unit {
    
        case .mgdL:
            
        switch languageCode.prefix(2).lowercased() {
                case "en":  return  BloodGlucoseUnitsInLocalWordsMgdL.en.rawValue
                case "de":  return  BloodGlucoseUnitsInLocalWordsMgdL.de.rawValue
                    
                case "ja":  return  BloodGlucoseUnitsInLocalWordsMgdL.ja.rawValue
                case "ko":  return  BloodGlucoseUnitsInLocalWordsMgdL.ko.rawValue
                    
                case "it":  return  BloodGlucoseUnitsInLocalWordsMgdL.it.rawValue
                case "es":  return  BloodGlucoseUnitsInLocalWordsMgdL.es.rawValue
                    
                case "fr":  return  BloodGlucoseUnitsInLocalWordsMgdL.fr.rawValue
                case "zh": return   BloodGlucoseUnitsInLocalWordsMgdL.zh.rawValue
            
                default: return     BloodGlucoseUnitByCountries.mgdL.rawValue
                
            }
        
        case .mmolL:
            
        switch languageCode.prefix(2).lowercased() {
                case "en":  return  BloodGlucoseUnitsInLocalWordsMMolL.en.rawValue
                case "de":  return  BloodGlucoseUnitsInLocalWordsMMolL.de.rawValue
                    
                case "ja":  return  BloodGlucoseUnitsInLocalWordsMMolL.ja.rawValue
                case "ko":  return  BloodGlucoseUnitsInLocalWordsMMolL.ko.rawValue
                    
                case "it":  return  BloodGlucoseUnitsInLocalWordsMMolL.it.rawValue
                case "es":  return  BloodGlucoseUnitsInLocalWordsMMolL.es.rawValue
                    
                case "fr":  return  BloodGlucoseUnitsInLocalWordsMMolL.fr.rawValue
                case "zh":  return  BloodGlucoseUnitsInLocalWordsMMolL.zh.rawValue

        default: return BloodGlucoseUnitByCountries.mgdL.rawValue
                
            }
        
        
    default: return BloodGlucoseUnitByCountries.mgdL.rawValue

        
    }

}


func getCurrentAppUserLanguage () -> String
{
    
    
    
    let langCode = Bundle.main.preferredLocalizations[0]
    let usLocale = Locale(identifier: "en-US")
    var langName = ""
    if let languageName = usLocale.localizedString(forLanguageCode: langCode) {
        langName = languageName
    }
            
    
    return langName
    
    
}

func returnLocaleCodeFromCombinedLanguageCode (combinedLanguageCode: String) -> String {
    
    print ("**$*$")

    print ("**$*$: \(String(combinedLanguageCode.dropFirst(3)))")
    
    return (String(combinedLanguageCode.dropFirst(3)))
    
}

func returnLanguageCodeFromEnglishName (englishName: String) -> String {
    
    
    for (key, value) in languageNamePairs {
        if value.englishName == englishName {
            print(key)  // prints "ae"
            return key
           // break
        }
        
    }
    return "en"

}

func returnCombinedLanguageCodeFromVoiceName (availableVoices: [OneSpeechVoice],  voiceName: String) -> String {
    //  "Samantha" -> "en-US"
    
    if let voiceForSelectedLanguage = availableVoices.first(where: { thisCheck in
        
        voiceName ==  thisCheck.voiceName
        
    }) {
        
        
        print ("#################################444: \(voiceForSelectedLanguage.combinedCode)")
        return voiceForSelectedLanguage.combinedCode
    }
    return "en-US"
    
    
    
}

func returnVoiceIDfromVoiceName (availableVoices: [OneSpeechVoice],  voiceName: String, voiceLocale: String) -> String

{
//
//    print ("UUUUUU U voiceName: \(voiceName)")
//    print ("UUUUUU U voiceLocale: \(voiceLocale)")

    if let firstVoiceForSelectedLanguage = availableVoices.first(where: { thisCheck in
        
        voiceName.dropFirst(2) ==  thisCheck.voiceName && voiceLocale.lowercased() == thisCheck.languageLocaleCode.lowercased()
        
    }) {
        return firstVoiceForSelectedLanguage.identifier
//        print ("UUUUUU defaultVoiceIdentifier /(firstVoiceForSelectedLanguage)")
    }
    return defaultVoiceIdentifier
}



func returnLanguageCodeFromCombinedCode (combinedCode: String) -> String {
    
    let index = combinedCode.index(combinedCode.startIndex, offsetBy: 2)
    
    return String(combinedCode[..<index])
}

func returnLocaleLanguageCodeFromCombinedCode (combinedCode: String) -> String {
    
    
    let start = (combinedCode.index(combinedCode.startIndex, offsetBy: 3))
    let end = combinedCode.index(combinedCode.startIndex, offsetBy: 5)
    let range = start..<end
    
    return String(combinedCode[range])
}


func returnLanguageNameInLocalLanguage(combinedCode: String) -> String {
    let languageCode = (returnLanguageCodeFromCombinedCode(combinedCode: combinedCode))
       
    let localLanguageName = languageNamesInLocaleLanguage[languageCode]
    
    return (localLanguageName ?? "English")
}

 
func returnLanguageNameInEnglish(combinedCode: String) -> String {
    let languageCode = (returnLanguageCodeFromCombinedCode(combinedCode: combinedCode))
       
    let englishName = languagesArray.first { $0[0] == languageCode }

    return (englishName![1] ?? "English")
}


func returnLanguageCodeFromLocalName(nameInLocale: String) -> String {
 
    if let (key, value) = languageNamePairs.first(where: { $0.value.nativeName == nameInLocale }) {
        print(key)  // "aa"
        return (key)

    }

    return ("en-US")
}



func returnCombinedLanguageCodeFromVoiceNameAndEnglishLanguageName (englishName: String, voiceName: String) -> String
{

    
    
    return ""
}








class OneSpeechVoice: Identifiable, Codable, Hashable, Equatable {
    
    static func == (lhs: OneSpeechVoice, rhs: OneSpeechVoice) -> Bool {
        // Compare the voiceName properties of the two OneSpeechVoice objects
        return lhs.identifier == rhs.identifier
    }

    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    var id = UUID()
    var languageCode:           String // es
    var languageLocaleCode:     String // MX
    var combinedCode:           String // es-MX
    var voiceName:              String // Paulina
    //var quality:                AVSpeechSynthesisVoiceQuality // Default
    var identifier:             String // com.apple.ttsbundle.Paulina-compact
   // var theClass:               String // AVSpeechSynthesisVoice
    var nameInEnglish:          String //
    var nameInLocalLanguage:    String //

    init () {

        self.languageCode = ""
        self.languageLocaleCode = ""
        self.combinedCode = ""
        self.voiceName = ""
        //self.quality = AVSpeechSynthesisVoiceQuality.default
        self.identifier = ""
        self.nameInEnglish =  ""
        self.nameInLocalLanguage =  ""

    }
    
}


class SpeechVoices: Identifiable, Equatable {
    
    static func == (lhs: SpeechVoices, rhs: SpeechVoices) -> Bool {
          // Compare the voiceName properties of the two SpeechVoices objects
        return lhs.identifier == rhs.identifier    }
    
    var id = UUID()
    var name: String
    var language: String
    var locale: String
    var nameInLocalLanguage: String
    var identifier: String
    
    init (name: String, language: String, locale: String, nameInLocalLanguage: String, identifier: AVSpeechSynthesisVoiceQuality) {
        
        self.name = name
        self.language = language
        self.locale = locale
        self.nameInLocalLanguage = nameInLocalLanguage
        self.identifier = "com.apple.ttsbundle.siri_female_en-US_compact"
    }
    
    
}



// ========================== BloodGlucoseManager =========================






































// ========================== TheTranslator =========================

class TheTranslator: ObservableObject   {
    
    static let shared = TheTranslator()
    

    let synth = AVSpeechSynthesizer()

    var testBG: Double = 0.0
    
    private var Sweetnesses: ManySweetnesses
    
//    
//    @ObservedObject var speechCoordinator = SpeechCoordinator()
//    private let backGroundSpeechSynthesizer = BackGroundSpeechSynthesizer()

    
    
    
    @Published var currentSugahMeStatus:        Bool = true // true is ON, false is OFF
    
    @Published var currentSugahSpeed:           SugahSpeed = .normal
    @Published var currentUserBloodGlucoseUnit: BloodGlucoseUnit = .milligramsPerDeciliter
    @Published var currentWarnNoFreshData:      Bool =   false    // true if demo mode is turned on
    @Published var currentDataTooOldPeriod_min: Int =    0
    
    @Published var speakUnit:                   Bool =   false
    @Published var announceElapsedTime:         Bool =   false
    @Published var skipHundredths:              Bool =   false
    @Published var announceWithDoubleTap:       Bool =   false
    @Published var isWhiteBackground:           Bool =   false
    @Published var mainBGDisplayFontSize:       Int =    200
    @Published var isSetToGrayAppIcon:          Bool =   false
    @Published var usesAppAudioSession:         Bool =   false
    
    @Published var thisThisDemo:                Bool =   false    // true if demo mode is turned on
    @Published var mixToPhone:                  Bool =   false
    @Published var currentLanguageName:         String = "English" // "English" or "Japanese" not "日本語"
    @Published var currentVoiceName:            String = "Samantha" // "Samantha"
    @Published var currentLanguageCodeCombined: String = "en-US" // "English" or "Japanese" not "日本語"

    @Published var currentDeviceName:           String = "-"// "Dexcom"
    
    // =================== APP Storages ==================================
    
    @AppStorage("announcementOn")                   public var announcementOn =                       defaultShuggaIsOn
    @AppStorage("threeSpeechSpeed")                 public var threeSpeechSpeed =                     defaultThreeSpeechSpeed
    @AppStorage("userBloodGlucoseUnit")             public var userBloodGlucoseUnit =                 defaultBloodGlucoseUnit

    @AppStorage("warnNoFreshData")                  public var warnNoFreshData =                      false
    @AppStorage("$dataTooOldPeriod_min")            public var dataTooOldPeriod_min =                 dateTooOldPeriod_min_default

    @AppStorage("includeUnit")                      public var includeUnit =                          true

    @AppStorage("speakElapsedTime")                 public var speakElapsedTime =                     true
    @AppStorage("skipHundredth")                    public var skipHundredth =                        false
    @AppStorage("doubleTapForSugah")                public var doubleTapForSugah =                    false
    @AppStorage("whiteBackground")                  public var whiteBackground =                      false //nov 1 2022 0:00:00
    @AppStorage("mainBloodGlucoseDisplayFontSize")  public var mainBloodGlucoseDisplayFontSize:       Int = 200
    @AppStorage("grayAppIcon")                      public var grayAppIcon =                          false
    @AppStorage("usesApplicationAudioSession")      public var usesApplicationAudioSession =          false

    @AppStorage("demoMode")                         public var demoMode =                             false

    
    @AppStorage("mixToTelephone")                   public var mixToTelephone =                       false

    @AppStorage("sugahLanguageChosen")              public var sugahLanguageChosen =                  defaultSugahLanguage
    @AppStorage("sugahVoiceChosen")                 public var sugahVoiceChosen =                     defaultSugahVoice
    
    init()
    {

        let sweetness = Sweetness()
        
        self.Sweetnesses =                 ManySweetnesses()
        self.currentDeviceName =            "-"
        
        self.currentSugahMeStatus =         announcementOn
        
        self.currentSugahSpeed =            .normal
        
        self.currentUserBloodGlucoseUnit =  BloodGlucoseUnit.milligramsPerDeciliter
        
        self.currentWarnNoFreshData =       warnNoFreshData
        self.currentDataTooOldPeriod_min =  dataTooOldPeriod_min
        
        self.speakUnit =                    speakUnit
        
        self.announceElapsedTime =          announceElapsedTime
        self.skipHundredths =               skipHundredth
        self.announceWithDoubleTap =        doubleTapForSugah
        self.isWhiteBackground =            whiteBackground
        self.mainBGDisplayFontSize =        mainBloodGlucoseDisplayFontSize
        self.isSetToGrayAppIcon =           grayAppIcon
        self.usesAppAudioSession =          usesApplicationAudioSession
        
        self.thisThisDemo =                 demoMode

        self.currentLanguageName =          sugahLanguageChosen
        self.currentVoiceName =             sugahVoiceChosen
        self.mixToPhone =                   mixToTelephone
        
        //getBG()
    }
    
    
    // speak it baby!
    
    func speakBG (thisBloodSweetnesses: ManySweetnesses) {
        print ("speakBG")
        let testString = String(thisBloodSweetnesses.sweetnesses?.last?.sweetness_string ?? "zero")
        
        print (testString)
        let utterance = AVSpeechUtterance(string: testString )
        //utterance.rate = currentSugahSpeed.rawValue
        utterance.voice = AVSpeechSynthesisVoice(language: currentLanguageName)

        self.synth.speak(utterance)

//        self.backGroundSpeechSynthesizer.startSpeaking(testString)
    }
    
    
    
//    func getBG() {  // unused yet
//
//        class BloodGlucoseFetcher {
//            let healthStore = HKHealthStore()   // this may need to be a single global var, that is to say, this class needs to be global class
//
//            private var Sweetnesses: ManySweetnesses
//
//
//            init () {
//
//
//                let sweetness = Sweetness()
//                self.Sweetnesses = ManySweetnesses(sweetnesses: [sweetness])
//
//
//
//            }
//
//
//
//            func fetchBloodGlucoseSamples(limit: Int, completion: @escaping ([Double], [String], [String]) -> Void) {
//                // Specify the blood glucose quantity type
//                let bloodGlucoseType = HKQuantityType.quantityType(forIdentifier: .bloodGlucose)
//
//
//                let startDate = Date(timeIntervalSinceNow: -3600 * 24 * 7) // one week ago
//                let endDate = Date()
//                let timeRangePredicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
//
//
//                // Set the sort order and the limits for the blood glucose samples
//                let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
//
////  REPLACEMENT↓
////                let sampleQuery = HKSampleQuery(sampleType: bloodGlucoseType,
////                                                predicate: timeRangePredicate,
////                                                limit: limit,
////                                                sortDescriptors: nil) { (query, samples, error) in
////  REPLACEMENT←
//
//
//                let sampleQuery = HKSampleQuery(sampleType: bloodGlucoseType!,
//                                               predicate: nil,
//                                               limit: limit,
//                                               sortDescriptors: [sortDescriptor]) { (query, samples, error) in
//                    if let error = error {
//                        print("Error fetching blood glucose samples: \(error.localizedDescription)")
//                        return
//                    }
//
//                    guard let samples = samples else {
//                        print("No blood glucose samples available")
//                        return
//                    }
//
//                    let bloodGlucoseMgDlUnit = HKUnit.gramUnit(with: .milli).unitDivided(by: HKUnit.literUnit(with: .deci))
//                    let bloodGlucoseMMolLUnit = HKUnit.moleUnit(with: .milli, molarMass: HKUnitMolarMassBloodGlucose).unitDivided(by: HKUnit.liter())
//
//                    let HKMetadataKeyDeviceModel = "model"
//                    // Extract the blood glucose values, models, and units from the samples
//                    let bloodGlucoseValues = samples.map { sample -> Double in
//                        guard let sample = sample as? HKQuantitySample else { return 0 }
//                        return sample.quantity.doubleValue(for: bloodGlucoseMgDlUnit)
//                    }
//                    let models = samples.map { sample -> String in
//                        guard let sample = sample as? HKQuantitySample else { return "" }
//                        return sample.metadata?[HKMetadataKeyDeviceModel] as? String ?? ""
//                    }
//                    let theUnit = samples.map { sample -> String in
//                        guard let sample = sample as? HKQuantitySample else { return "" }
//                        return sample.metadata?[HKMetadataKeyDeviceModel] as? String ?? ""                    }
//
//                    completion(bloodGlucoseValues, models, theUnit)
//                }
//
//                // Execute the sample query
//                healthStore.execute(sampleQuery)
//            }
//
//            func fetchMetadataKeysForLatestBloodGlucoseSample(completion: @escaping ([String]) -> Void) {
//                    // Specify the blood glucose quantity type
//                    let bloodGlucoseType = HKQuantityType.quantityType(forIdentifier: .bloodGlucose)
//
//                    // Set the sort order and the limits for the blood glucose samples
//                    let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
//                    let limit = 1
//                    let sampleQuery = HKSampleQuery(sampleType: bloodGlucoseType!,
//                                                   predicate: nil,
//                                                   limit: limit,
//                                                   sortDescriptors: [sortDescriptor]) { (query, samples, error) in
//                        if let error = error {
//                            print("Error fetching blood glucose samples: \(error.localizedDescription)")
//                            return
//                        }
//
//                        guard let samples = samples, let sample = samples.first else {
//                            print("No blood glucose samples available")
//                            return
//                        }
//
//                        guard let metadata = sample.metadata else {
//                            print("No metadata available for blood glucose sample")
//                            return
//                        }
//
//                        let metadataKeys = metadata.keys.map { key -> String in
//                            return key
//                        }
//
//                        completion(metadataKeys)
//                    }
//
//                    // Execute the sample query
//                    healthStore.execute(sampleQuery)
//                }
//
//
//        }
//
//
//
//
//
//
//
//        var bloodGlucoseFetcher = BloodGlucoseFetcher ()
//        bloodGlucoseFetcher.fetchBloodGlucoseSamples(limit: 4, completion: { (bloodGlucoseValues, theModel, theUnit) in
//            print("Last two blood glucose values: \(bloodGlucoseValues)")
//            self.testBG = bloodGlucoseValues[0]
//
//        })       // print (BloodGlucoseFetcher.fetchLastTwoBloodGlucoseSamples(<#T##self: BloodGlucoseFetcher##BloodGlucoseFetcher#>))
//
//
//        bloodGlucoseFetcher.fetchMetadataKeysForLatestBloodGlucoseSample { metadataKeys in
//
//            print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ \(metadataKeys)")
//        }
//
//    }
    
    
    // =============================== Setting Variables ====================================
    
    func currentCombinedLanguageCode() -> String {
        
        print ("theTranslator's currentLanguageName \(self.currentLanguageName)")
        print ("theTranslator's currentVoiceName is set to: \(self.currentVoiceName)")
        let thisCombinedCode = returnLanguageCodeFromEnglishName(englishName: self.currentLanguageName)
        print ("theTranslator's combinedLanguageCode is: \(thisCombinedCode)")
        return thisCombinedCode
        
        
    }
    
    func setCurrentVoiceName (currentVoiceName: String) {
        print ("theTranslator's currentVoiceName is changed from: \(self.currentVoiceName)")

        self.currentVoiceName = currentVoiceName
        print ("theTranslator's currentVoiceName is set to: \(self.currentVoiceName)")
        
    }
    
    func setCurrentDeviceName (newDeviceName: String) {

        if self.currentDeviceName != newDeviceName {
            print ("theTranslator's currentDeviceName is changed from: \(self.currentDeviceName)")

            self.currentDeviceName = newDeviceName
            print ("theTranslator's currentDeviceName is set to: \(self.currentDeviceName)")
        }
        else
        {
            
            print ("theTranslator's currentDeviceName is still: \(self.currentDeviceName)")

        }
    }
    
   
    
    
    func setSugahOnOrOff (sugahStatus: Bool) {
        print ("theTranslator's Sugah's On: is changed from: \(self.currentSugahMeStatus)")

        
        self.currentSugahMeStatus = sugahStatus
        
        print ("theTranslator's Sugah's On:  is set to: \(self.currentSugahMeStatus)")

    }
    
    func setSugahSpeed (sugahSpeed: SugahSpeed) {
        
        print ("theTranslator's sugahSpeed is changed from: \(self.currentSugahSpeed.rawValue)")

        
        self.currentSugahSpeed = sugahSpeed
        
        print ("theTranslator's sugahSpeed is set to: \(self.currentSugahSpeed.rawValue)")
    }

    func setCurrentUserBloodGlucoseUnit(theNewUnit: BloodGlucoseUnit) {
        print ("theTranslator's currentUserBloodGlucoseUnit is changed from: \(self.currentUserBloodGlucoseUnit.rawValue)")

        
        self.currentUserBloodGlucoseUnit = theNewUnit
        
        print ("theTranslator's currentWarnNoFreshData is set to: \(self.currentUserBloodGlucoseUnit.rawValue)")

    }
    
    func setCurrentWarnNoFreshData (warnNoFreshData: Bool) {
        print ("theTranslator's currentWarnNoFreshData is changed from: \(self.currentWarnNoFreshData)")

        self.currentWarnNoFreshData = warnNoFreshData
        
        print ("theTranslator's currentWarnNoFreshData is set to: \(self.currentWarnNoFreshData)")

    }
    
    func setCurrentDataTooOldPeriod_min (dataTooOldPeriod_min: Int) {
        print ("theTranslator's dataTooOldPeriod_min is changed from: \(self.currentDataTooOldPeriod_min)")
        self.currentDataTooOldPeriod_min = dataTooOldPeriod_min
        print ("theTranslator's dataTooOldPeriod_min is set to: \(self.currentDataTooOldPeriod_min)")

    }

    func setSpeakUnit (speakUnit: Bool) {
        
        print ("theTranslator's speakUnit is changed from: \(self.speakUnit)")
        self.speakUnit = speakUnit
        print ("theTranslator's speakUnit is set to: \(self.speakUnit)")

    }

    func setAnnounceElapsedTime(announceElapsedTime: Bool) {
        
        print ("theTranslator's announceElapsedTime is changed from: \(self.announceElapsedTime)")
        self.announceElapsedTime = announceElapsedTime
        print ("theTranslator's announceElapsedTime is set to: \(self.announceElapsedTime)")

    }
    
    func setSkipHundredths(skipHundredth: Bool) {
        
        print ("theTranslator's skipHundredth is changed from: \(self.skipHundredths)")
        self.skipHundredths = skipHundredth
        print ("theTranslator's skipHundredth is set to: \(self.skipHundredths)")

    }
    
    func setAnnounceWithDoubleTap(doubleTapForSugah: Bool) {
    
    print ("theTranslator's setAnnounceWithDoubleTap is changed from: \(self.announceWithDoubleTap)")
    self.announceWithDoubleTap = doubleTapForSugah
    print ("theTranslator's setAnnounceWithDoubleTap is set to: \(self.announceWithDoubleTap)")

}
    
    func setWhiteBackground(whiteBackground: Bool) {
        
        print ("theTranslator's isWhiteBackground is changed from: \(self.isWhiteBackground)")
        self.isWhiteBackground = isWhiteBackground
        print ("theTranslator's isWhiteBackground is set to: \(self.isWhiteBackground)")
    }

    func setMainBGDisplayFontSize(mainBGDisplayFontSize: Int) {
    
    print ("theTranslator's mainBGDisplayFontSize is changed from: \(self.mainBGDisplayFontSize)")
    self.mainBGDisplayFontSize = mainBGDisplayFontSize
    print ("theTranslator's mainBGDisplayFontSize is set to: \(self.mainBGDisplayFontSize)")

}
    
    func setToGrayAppIcon(isSetToGrayAppIcon: Bool) {
        
        print ("theTranslator's isSetToGrayAppIcon is changed from: \(self.isSetToGrayAppIcon)")
        self.isSetToGrayAppIcon = isSetToGrayAppIcon
        print ("theTranslator's isSetToGrayAppIcon is set to: \(self.isSetToGrayAppIcon)")

    }
    
    func setUsesAppAudioSession(usesAppAudioSession: Bool) {
        
        print ("theTranslator's usesAppAudioSession is changed from: \(self.usesAppAudioSession)")
        self.usesAppAudioSession = usesAppAudioSession
        print ("theTranslator's usesAppAudioSession is set to: \(self.usesAppAudioSession)")

    }
    
    func setDemoMode (thisThisDemo: Bool) {
        print ("theTranslator's thisThisDemo is changed from: \(self.thisThisDemo)")
        self.thisThisDemo = thisThisDemo
        print ("theTranslator's thisThisDemo is set to: \(self.thisThisDemo)")
    }

    func setMixToPhone (mixToPhone: Bool) {
        print ("theTranslator's mixToPhone is changed from: \(self.mixToPhone)")
        self.mixToPhone = mixToPhone
        print ("theTranslator's mixToPhone is set to: \(self.mixToPhone)")
    }
    
    func setCurrentLanguageName (currentLanguageName: String) {
        print ("theTranslator's currentLanguageName is changed from: \(self.currentLanguageName)")
        self.currentLanguageName = currentLanguageName
        print ("theTranslator's currentLanguageName is set to: \(self.currentLanguageName)")
    }
    

    
    //  ============================ MISC
    func convertBloodGLucoseTo_mgdL (mmolL: Double) -> Int {
        return Int (mmolL / 0.0555)
    }
    
    func convertBloodGLucoseTo_mmolL (mgdL: Double) -> Double {
        return Double (mgdL * 0.0555)
    }
    
    func setSweetnessArray (sweetnesses: ManySweetnesses) {
        
        self.Sweetnesses = sweetnesses
        
        //print (self.Sweetnesses)
        
    }
}











class  TheAppVoices: ObservableObject {
    static let shared = TheAppVoices()

    //var availableLanguageCodes: [String] =  []
    @Published var availableVoices: [OneSpeechVoice]
    @Published var speechVoices:    [SpeechVoices]
    @Published var languageCombinedCodeSets: [String]
    
    //================================ INIT ===============================
    
    init () {
        
        let availableVoicesNow = AVSpeechSynthesisVoice.speechVoices()
        
        
//        print ("availableVoicesNow   00000: \(availableVoicesNow)")
        availableVoices = []
        languageCombinedCodeSets = []
        speechVoices = []
        
        
        for oneVoice in availableVoicesNow {
            //https://suragch.medium.com/how-strings-and-substrings-work-in-swift-fd4dc43ee91d
            
            
            // =====  languageCode  ======
            var index = oneVoice.language.index(oneVoice.language.startIndex, offsetBy: 2)
            let languageCode = oneVoice.language[..<index]
            //tempVoice.languageCode = String(languageCode)
            
            // =====  languageLocaleCode  ======
            let start = oneVoice.language.index(oneVoice.language.startIndex, offsetBy: 3)
            let end = oneVoice.language.index(oneVoice.language.startIndex, offsetBy: 5)
            let range = start..<end
            let languageLocaleCode = String(oneVoice.language[range])
            
            // =====  combinedCode  ======
            index = oneVoice.language.index(oneVoice.language.startIndex, offsetBy: 5)
            let combinedCode = oneVoice.language[..<index]
      
            
       
            let thisOneSpeechVoice = OneSpeechVoice()
            
            
            thisOneSpeechVoice.languageCode = String(languageCode) // en
            thisOneSpeechVoice.languageLocaleCode = languageLocaleCode // US
            thisOneSpeechVoice.combinedCode = String(combinedCode) // en-US
            thisOneSpeechVoice.voiceName = String(oneVoice.name)  // Bob
            thisOneSpeechVoice.identifier = String(oneVoice.identifier)
           // print ("thisOneSpeechVoice.voiceName \(thisOneSpeechVoice.voiceName)")
            thisOneSpeechVoice.nameInEnglish = returnLanguageNameInEnglish (combinedCode: String(combinedCode))
            thisOneSpeechVoice.nameInLocalLanguage = languageNamesInLocaleLanguage[String(languageCode)]!
            
            if languageCodeCurrentlyAvailable.contains (String(languageCode)) {
                
                availableVoices.append(thisOneSpeechVoice)
//                print ("added \(thisOneSpeechVoice.voiceName)")
//                print ("added \(thisOneSpeechVoice.languageCode)")

               // print ("\(thisOneSpeechVoice.voiceName)")

                
                if languageCombinedCodeSets.contains(String(combinedCode)) {
                    
                    languageCombinedCodeSets.append(String(combinedCode))
                    
                    
                }
                
            }
            
           
            
        }
        
        
        
//        for oneVoice in  availableVoices {
//            print ("5444444")
//            print (oneVoice.languageCode)
//            print (oneVoice.languageLocaleCode)
//            print (oneVoice.combinedCode)
//            print (oneVoice.voiceName)
//            print (oneVoice.identifier)
//
//            print ("")
//        }
    }
    
    
    
    //============================== END INIT =====================================
    
    func returnCombinedLanguageCodeFromVoiceNameAndLanguageCode (voiceName: String, languageCode: String) -> String {
       // voiceName = "Sandy"
        //voiceLanguageCode
        print ("2133333")

        //var combinedCode = ""
        
        print ("Comparing:")
        print (voiceName)
        print ("and")
        

        for oneVoice in self.availableVoices {

//            for oneVoice in  availableVoices {
//                print ("\(oneVoice.languageCode): \(oneVoice.languageLocaleCode): \(oneVoice.combinedCode): \(oneVoice.voiceName): \(oneVoice.identifier)")
//
//            }
            print ("")
            print ("\(oneVoice.voiceName) : \(oneVoice.languageCode) : \(voiceName) : \(languageCode)")
    

            if voiceName == oneVoice.voiceName && languageCode == oneVoice.languageCode{
                print ("The match found:  \(oneVoice.languageCode)")
                return (oneVoice.languageCode)
                
            }
        }
        
        
       // print ("The match NOT found")
        return ("No match found; defaulting: en-US")
        
    }
    
    
    
    
    
    
    
   
    
    
}
