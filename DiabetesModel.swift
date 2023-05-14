//
//  DiabetesModel.swift
//  Shugga
//
//  Created by Rodi on 3/17/23.
//

import Foundation
import SwiftUI









struct Diabetes {
    
    @AppStorage("demoMode")                             public var demoMode =                           false


    @AppStorage("voiceVolume")                          public var voiceVolume: Double =                1.0
    
    @AppStorage("threeSpeechSpeed")                     public var threeSpeechSpeed =                   defaultThreeSpeechSpeed
    @AppStorage("speakInterval_seconds")                public var speakInterval_seconds:               Int =  10 // this is going to be multiples of 10 seconds
    @AppStorage("includeUnit")                          public var includeUnit =                        true
    @AppStorage("userBloodGlucoseUnit")                 public var userBloodGlucoseUnit =               defaultBloodGlucoseUnit
    @AppStorage("speakElapsedTime")                     public var speakElapsedTime =                   true
    @AppStorage("warnNoFreshData")                      public var warnNoFreshData =                    false
    @AppStorage("dataTooOldPeriod_min")                 public var dataTooOldPeriod_min =               dateTooOldPeriod_min_default
    @AppStorage("speechGender")                         public var speechGender =                       "Female"
    @AppStorage("sugahLanguageChosen")                  public var sugahLanguageChosen =                defaultSugahLanguage
    @AppStorage("skipHundredth")                        public var skipHundredth =                      false
    @AppStorage("mixToTelephone")                       public var mixToTelephone =                     false
    @AppStorage("usesApplicationAudioSession")          public var usesApplicationAudioSession =        false
    @AppStorage("sugahVoiceChosen")                     public var sugahVoiceChosen =                   defaultSugahVoice
    @AppStorage("sugahLanguageCombinedCodeChosen")      public var sugahLanguageCombinedCodeChosen =    "en-US"
    
    @AppStorage("shuggaGlucoseTrend")               public var shuggaGlucoseTrend =           false
    @AppStorage("multiplyTrendByTen")               public var multiplyTrendByTen =           false
    @AppStorage("removeTimeUnit")                   public var removeTimeUnit =                        false

    
    
    func mmolPerLiterTomgPerdL (mmolPerLiter: Double) -> Double
    {
        
        return (mmolPerLiter/0.05556)
        
    }
    
    func mgPerdLTommolPerLiter (mgPerdL: Double) -> Double
    {
        return (mgPerdL * 0.05556)
        
    }
    
    
 
    
    

    func returnSpeakableGlucoseFetchTime (sweetness: Sweetness) -> String {
        
        @Environment(\.scenePhase)  var scenePhase

        
        if !self.speakElapsedTime && scenePhase == .active { return ("")}

        
        var sampleTime: Date
        var shuggaUtterance: String = ""
        
        sampleTime = Date(timeIntervalSince1970: sweetness.startTimestamp)
        
        let timeInterval = Int(Date().timeIntervalSince(sampleTime))
        
        if timeInterval < Int(rodisBirthdayTimeStamp) {
            shuggaUtterance = formatSecondsToTimeString(seconds: timeInterval, cutOffAt: CutOffAt.none)// colon makes for a longer pause
        }
        
        
        
        
        
        return (shuggaUtterance)
    }
    
    
 
    
    
    
    func returnSpeakableGlucoseTrendValue (sweetness: Sweetness, synthSpeechParameters: SynthSpeechParameters) -> String {
        // this reads the recorded glucose trend unit. ignores the user set glucose unit
        var isSteady = false
        var speakableGlucoseTrendString = ""
        if shuggaGlucoseTrend {
            
            let theSweetness = sweetness
            
            if let glucoseTrendRateValue = theSweetness.glucoseTrendRateValue, let glucoseTrendRateUnit = theSweetness.glucoseTrendRateUnit {
                
                printTimestamp(description: "theSweetness.glucoseTrendRateValue", content: "\(glucoseTrendRateValue) \(glucoseTrendRateUnit)", label: "↓↑ ")
                
                
                if glucoseTrendRateValue < 0 { // negative trend
                    
                    
                    if multiplyTrendByTen   {
                        if userBloodGlucoseUnit == BloodGlucoseUnit.milligramsPerDeciliter.rawValue { // mg/dL
                            let absoluteGlucoseTrendRateValue = Int(glucoseTrendRateValue * -10)
                            speakableGlucoseTrendString += ": Down \(absoluteGlucoseTrendRateValue)"
                        } else if userBloodGlucoseUnit == BloodGlucoseUnit.millimolesPerLiter.rawValue { // mmol/L
                            let absoluteGlucoseTrendRateValue = mgPerdLTommolPerLiter(mgPerdL: glucoseTrendRateValue * -10).roundTo(places: 2)
                            speakableGlucoseTrendString += ": Down \(absoluteGlucoseTrendRateValue)"
                        }
                    }
                    else { // NOT multiply by ten
                        if userBloodGlucoseUnit == BloodGlucoseUnit.milligramsPerDeciliter.rawValue { // mg/dL
                            let absoluteGlucoseTrendRateValue = glucoseTrendRateValue
                            speakableGlucoseTrendString += ": Down \(absoluteGlucoseTrendRateValue)"
                        } else if userBloodGlucoseUnit == BloodGlucoseUnit.millimolesPerLiter.rawValue { // mmol/dL
                            let absoluteGlucoseTrendRateValue = mgPerdLTommolPerLiter(mgPerdL: glucoseTrendRateValue).roundTo(places: 2)
                            speakableGlucoseTrendString += ": Down \(absoluteGlucoseTrendRateValue)"
                        }
                    }
                }
                
                else if glucoseTrendRateValue > 0 { // positive trend
                    
                    if multiplyTrendByTen   {
                        if userBloodGlucoseUnit == BloodGlucoseUnit.milligramsPerDeciliter.rawValue { // mg/dL
                            let absoluteGlucoseTrendRateValue = Int(glucoseTrendRateValue * 10)
                            speakableGlucoseTrendString += ": Up \(absoluteGlucoseTrendRateValue)"
                        } else if userBloodGlucoseUnit == BloodGlucoseUnit.millimolesPerLiter.rawValue { // mmol/L
                            let absoluteGlucoseTrendRateValue = mgPerdLTommolPerLiter(mgPerdL: glucoseTrendRateValue * 10).roundTo(places: multiplyTrendByTen ? 1 : 2)
                            speakableGlucoseTrendString += ": Up \(absoluteGlucoseTrendRateValue)"
                        }
                    }
                    else { // NOT multiply by ten
                        if userBloodGlucoseUnit == BloodGlucoseUnit.milligramsPerDeciliter.rawValue { // mg/dL
                            let absoluteGlucoseTrendRateValue = glucoseTrendRateValue
                            speakableGlucoseTrendString += ": Up \(absoluteGlucoseTrendRateValue)"
                        } else if userBloodGlucoseUnit == BloodGlucoseUnit.millimolesPerLiter.rawValue { // mmol/dL
                            let absoluteGlucoseTrendRateValue = mgPerdLTommolPerLiter(mgPerdL: glucoseTrendRateValue).roundTo(places: multiplyTrendByTen ? 1 : 2)
                            speakableGlucoseTrendString += ": Up \(absoluteGlucoseTrendRateValue)"
                        }
                    }
                }
                
                else { //  a steady trend
                    
                    speakableGlucoseTrendString += ": Is steady."
                    isSteady = true
                }
                
                if !isSteady && !removeTimeUnit{
                    if let _ = theSweetness.glucoseTrendRateValue, let glucoseTrendRateUnit = theSweetness.glucoseTrendRateUnit {
                        
                        
                        // ================== mg/min·dL
                        
                        if glucoseTrendRateUnit == "mg/min·dL" && userBloodGlucoseUnit == BloodGlucoseUnit.milligramsPerDeciliter.rawValue {
                            
                            if multiplyTrendByTen {                      // per ten minutes
                                if !includeUnit {
                                    speakableGlucoseTrendString += " per ten minutes."
                                } else {
                                    speakableGlucoseTrendString += " milligrams per deciliter per ten minutes."
                                }
                            }
                            
                            else {                                       // per minute
                                if !includeUnit {
                                    speakableGlucoseTrendString += " per minute."
                                } else {
                                    speakableGlucoseTrendString += " milligrams per deciliter per minute."
                                }
                            }
                            
                            
                            // ================== mMoles/min·L  <<== this may not be the accurate assignment
                            
                            
                        } else  { // milliMoles
                            
                            if multiplyTrendByTen  {                       // per ten minutes
                                if !includeUnit {
                                    speakableGlucoseTrendString += " per ten minutes."
                                }
                                else {
                                    speakableGlucoseTrendString += " millimoles per liter per ten minutes."
                                }
                                
                            }
                            else {                                       // per minute
                                
                                if !includeUnit {
                                    speakableGlucoseTrendString += " per minute."
                                }
                                else {
                                    speakableGlucoseTrendString += " millimoles per liter per minute."
                                }
                            }
                        }
                        
                    }
                }
                else {
                    speakableGlucoseTrendString += "."

                }
                
            }
        }
        return (speakableGlucoseTrendString)

    }

    
    
    func returnSpeakableGlucoseValue (
        sweetness: Sweetness,
        synthSpeechParameters: SynthSpeechParameters,
        skipHundredth: Bool
        
        )  -> String {
        
            let elapsedTime: TimeInterval = Date().timeIntervalSince(Date(timeIntervalSince1970: sweetness.startTimestamp))
            
            if Int(elapsedTime) > Int(rodisBirthdayTimeStamp) {return ""}
            
            let timeIntervalString = formatSecondsToTimeString(seconds: Int(elapsedTime), cutOffAt: CutOffAt.none) + "  ago."
            
        var letHundredSkip: Bool
        let dataTooOldPeriod_sec = dataTooOldPeriod_min * SecondsIn.oneMinute.rawValue
        
            let warningMargin_sec: Double = 30 // seconds to pad before warning
        
        let rawValue = sweetness.sweetness
        
        if skipHundredth && returnLanguageCodeFromCombinedCode(combinedCode: synthSpeechParameters.languageCode ?? "").lowercased() == "en"  { letHundredSkip  = true } // ?? "" so if unknown no skip100
            
            else {letHundredSkip  = false }
            
        let theRawValue_double = returnCorrectValueForUnit_string (rawValue : rawValue, userBloodGlucoseUnit: userBloodGlucoseUnit, skipHundredth: letHundredSkip)
        
        var theRawValue_string: String
        
        var theSpeakableString: String = ""
        
        var theSpeakableUnit: String = ""
        
        var theDifferenceString: String
        
            theSpeakableUnit = returnUnitInTheLanguage(languageCode: returnLanguageCodeFromCombinedCode(combinedCode: synthSpeechParameters.combinedLanguageCode ?? defaultSugahLanguageCombinedCode), unit: BloodGlucoseUnitByCountries(rawValue: userBloodGlucoseUnit) ?? BloodGlucoseUnitByCountries.mgdL)
                
    //            print ("Unit the chosen unit for the language = \(theSpeakableUnit)")
        
     //print (speechLanguage)
        
        if demoMode {
            
            switch returnLanguageCodeFromCombinedCode(combinedCode: sugahLanguageChosen).lowercased() {
            case "en": theRawValue_string = "XYZ "
            case "de": theRawValue_string = "XYZ "
            case "ja": theRawValue_string = "イロハ "
            case "ko": theRawValue_string = "XYZ "
            case "it": theRawValue_string = "XYZ "
            case "es": theRawValue_string = "XYZ "
            case "fr": theRawValue_string = "XYZ "
            default:   theRawValue_string = "XYZ "

            }
            
        }
        
        
        else {
            theRawValue_string = String(theRawValue_double)
        }
        
        theSpeakableString = "\(theRawValue_string) \(includeUnit ? theSpeakableUnit : "")"
        
        if demoMode {
            
            switch returnLanguageCodeFromCombinedCode(combinedCode: sugahLanguageChosen).lowercased() {
                        
                    case "en":  theSpeakableString = theSpeakableString + ". This is a demo value "
                    case "de":  theSpeakableString = theSpeakableString + ". Dies ist ein Demo-Wert."
                    case "ja":  theSpeakableString = theSpeakableString + "。この値はサンプルです。"
                    case "ko":  theSpeakableString = theSpeakableString + ". 이것은 데모 값입니다."
                    case "it":  theSpeakableString = theSpeakableString + ". Questo è un valore di dimostrazione."
                    case "es":  theSpeakableString = theSpeakableString + ". Este es un valor de demostración."
                    case "fr":  theSpeakableString = theSpeakableString + ". Il s'agit d'une valeur de démonstration."
                    case "zh":  theSpeakableString = theSpeakableString + ". 這是一個演示值"

            default:    theSpeakableString = theSpeakableString + ". This is a demo value."

            }
            
        }
        
        /*
         
        if speakElapsedTime {
            
            
            switch returnLanguageCodeFromCombinedCode(combinedCode: sugahLanguageChosen).lowercased() {
              case "en":
                theSpeakableString = theSpeakableString + ",. " + "The last blood glucose entry by " + elapsedTimeFormatter (timeSinceUpdateInSeconds: Int(elapsedTime), recordingDevice: recordingDevice, language: sugahLanguageChosen, demoMode: demoMode)
                
              case "de":
                theSpeakableString = theSpeakableString + ",. " + "Der letzte Blutzuckereintrag von " + elapsedTimeFormatter (timeSinceUpdateInSeconds: Int(elapsedTime), recordingDevice: recordingDevice, language: sugahLanguageChosen, demoMode: demoMode)
                
              case "ja":
                theSpeakableString = "\(theSpeakableString),。最新の血糖ちの記録は　\(elapsedTimeFormatter (timeSinceUpdateInSeconds: Int(elapsedTime), recordingDevice: recordingDevice, language: sugahLanguageChosen, demoMode: demoMode)) 前です。"
                
                
              case "ko":
                theSpeakableString = theSpeakableString + ",. " + "최근 혈당 입력은 " + elapsedTimeFormatter (timeSinceUpdateInSeconds: Int(elapsedTime), recordingDevice: recordingDevice, language: sugahLanguageChosen, demoMode: demoMode) + " 일때 입력되었습니다"
              case "it":
                theSpeakableString = theSpeakableString + ",. " + "L'ultimo valore di glicemia è stato inserito " + elapsedTimeFormatter (timeSinceUpdateInSeconds: Int(elapsedTime), recordingDevice: recordingDevice, language: sugahLanguageChosen, demoMode: demoMode)
              case "es":
                theSpeakableString = theSpeakableString + ",. " + "La última entrada de glucemia fue " + elapsedTimeFormatter (timeSinceUpdateInSeconds: Int(elapsedTime), recordingDevice: recordingDevice, language: sugahLanguageChosen, demoMode: demoMode)
              case "fr":
                theSpeakableString = theSpeakableString + ",. " + "La dernière entrée de glycémie a été effectuée " + elapsedTimeFormatter (timeSinceUpdateInSeconds: Int(elapsedTime), recordingDevice: recordingDevice, language: sugahLanguageChosen, demoMode: demoMode)
                
                            
              default:
                theSpeakableString = theSpeakableString +  ",. " + "The last blood glucose entry by " + elapsedTimeFormatter (timeSinceUpdateInSeconds: Int(elapsedTime), recordingDevice: recordingDevice, language: sugahLanguageChosen, demoMode: demoMode)
            }
            
            
        }
         
        */
  
            
            
            
            
            
        if warnNoFreshData && elapsedTime > (Double(dataTooOldPeriod_min * SecondsIn.oneMinute.rawValue) + warningMargin_sec )  {
            
            print ("elapsedTime: \(elapsedTime)")
            
            let theDifference = elapsedTime - (Double(dataTooOldPeriod_min * SecondsIn.oneMinute.rawValue))
            
            //        print ("theDifference \(theDifference)")
            
            if (theDifference > Double(SecondsIn.twoMinutes.rawValue)) && (theDifference < Double(SecondsIn.twoHours.rawValue)) {    print ("between 2 minutes and two hour")
                
                theDifferenceString = "over \(Int(theDifference / Double(SecondsIn.oneMinute.rawValue))) minutes"
            }
            
            else if (theDifference > Double(SecondsIn.twoHours.rawValue))  &&  (theDifference < Double(SecondsIn.oneDay.rawValue)) {
                
                print ("between two hours and one day")
                theDifferenceString = "over \(Int(theDifference / Double(SecondsIn.oneHour.rawValue))) hours"
            }
            
            else if (theDifference > Double(SecondsIn.oneDay.rawValue)) { // over one day
                
                theDifferenceString = "more than one day."
            }
            
            else { theDifferenceString = "\(Int(theDifference + 1)) seconds" }
            
            
            
            theSpeakableString = theSpeakableString + ",. Data is too old by \(theDifferenceString). There may be some issues with your HealthKit data or the devices."
        }
        
            
            if rawValue == TheAppErrorCodes.userNotAgreedToAgreement.rawValue {
            
            theSpeakableString = "You need to agree to the User Agreement in Settings before you can use this app."
        }
        
        return theSpeakableString
        
    }
    
    
    
    
    
    
    func returnCorrectValueForUnit_string (rawValue: Double, userBloodGlucoseUnit: String, skipHundredth : Bool) -> String {
        
        let rawValue_Int = Int(rawValue)
        
        if rawValue_Int  <= 0 {
            
            return "Error. \(rawValue_Int)"
        }
        
        //    print ("rawValue: \(rawValue)")
        //    print ("rawValue mmol/L: \(rawValue * 0.0555)")
        
        if userBloodGlucoseUnit == BloodGlucoseUnit.millimolesPerLiter.rawValue  {
            
            print (String((rawValue * 0.0555).roundTo(places: 1) ))
            return String((rawValue * 0.0555).roundTo(places: 1) )
            
        }
        
        
        
        if rawValue_Int < 10 {
            print ("String(rawValue_Int):  \(String(rawValue_Int))")
            return String(rawValue_Int)
        }
        
        if skipHundredth {
            
        
            //print ("String(rawValue_Int):  \(rawValue_Int)")
            return skipHundrethInEnglish (glucoseValue: rawValue)
        }
        //print ("String(rawValue_Int):  \(rawValue_Int)")
        return String(rawValue_Int)
    }

    
    
    
    
    

}


