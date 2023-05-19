//
//  AudioModel.swift
//  sugar me high
//
//  Created by Rodi on 9/21/22.
//

import Foundation
import AVFoundation
import SwiftUI
import BackgroundTasks

class PlaySoundFile {

   static var audioPlayer:AVAudioPlayer?

   static func playSounds(soundfile: String) {
       print ("playing...")
       if let path = Bundle.main.path(forResource: soundfile, ofType: nil){

           do {

               audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
               audioPlayer?.prepareToPlay()
               audioPlayer?.play()

           }catch {
               print("Error")
           }
       }
    }
 }


func elapsedTimeFormatter (timeSinceUpdateInSeconds: Int, recordingDevice: String, language: String, demoMode: Bool) -> String {
    
    // eg, language = "English"
    var recordingDeviceFinal = ""
    
    if recordingDevice == "-"  {recordingDeviceFinal = "an unknown device"}
    else
    {recordingDeviceFinal = recordingDevice}
    
    if demoMode {
        
        return ("a demo device was less than X minutes ago.")
    }
    else {
        if timeSinceUpdateInSeconds < SecondsIn.twoHours.rawValue {
            let timeSinceUpdateInMinutes = Int(timeSinceUpdateInSeconds / SecondsIn.oneMinute.rawValue + 1)
            return "\(recordingDeviceFinal) was less than \(timeSinceUpdateInMinutes) minutes ago."
            
        }
        else if  timeSinceUpdateInSeconds > (SecondsIn.twoHours.rawValue + 10) && timeSinceUpdateInSeconds < SecondsIn.oneDay.rawValue {
            
            let timeSinceUpdateInMinutes = Int(timeSinceUpdateInSeconds / SecondsIn.oneMinute.rawValue)
            return "\(recordingDeviceFinal) was more than \(timeSinceUpdateInMinutes) minutes ago."
        }
        else {
            
            let timeSinceUpdateInDays = Int(timeSinceUpdateInSeconds / SecondsIn.oneDay.rawValue)
            return "\(recordingDeviceFinal) was more than 24 hours ago."
            
        }
        // return "\(recordingDeviceFinal) was \(timeSinceUpdateInSeconds) seconds ago."
    }
    
    
    
    
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


func returnSpeakableGlucoseValue(
    
        rawValue: Double,                   userBloodGlucoseUnit: String,               speakElapsedTime: Bool,             elapsedTime: Int,
        includeUnit: Bool,                  warnNoFreshData: Bool,                      dataTooOldPeriod_min: Int,          speechSpeed : Double,
        speechGender: String,               demoMode: Bool,                             skipHundredth: Bool,                recordingDevice: String,
        mixToTelephone: Bool,               usesApplicationAudioSession: Bool,          speechLanguage: String,             speechVoiceName: String,
        speechVoiceVolume: Double,          appScenePhase: ScenePhase
        
    )  -> String {
    
        
    let bloodGlucoseData = BloodGlucoseData.shared

    var letHundredSkip: Bool
//    print ("warnNoFreshData: \(warnNoFreshData) ")
//    print ("dataTooOldPeriod_min: \(dataTooOldPeriod_min)")
//    print ("elapsedTime: \(elapsedTime)")
//
    let dataTooOldPeriod_sec = dataTooOldPeriod_min * SecondsIn.oneMinute.rawValue
    
    let warningMargin_sec = 30 // seconds to pad before warning
    
        
    if skipHundredth && returnLanguageCodeFromCombinedCode(combinedCode: speechLanguage).lowercased() == "en"  { letHundredSkip  = true }
    else {letHundredSkip  = false }
        
    let theRawValue_double = returnCorrectValueForUnit_string (rawValue : rawValue, userBloodGlucoseUnit :userBloodGlucoseUnit, skipHundredth: letHundredSkip)
    
    var theRawValue_string: String
    
    var theSpeakableString: String = ""
    
    var theSpeakableUnit: String = ""
    
    var theDifferenceString: String
    
         
    theSpeakableUnit = returnUnitInTheLanguage(languageCode: returnLanguageCodeFromCombinedCode(combinedCode: speechLanguage), unit: BloodGlucoseUnitByCountries(rawValue: userBloodGlucoseUnit) ?? BloodGlucoseUnitByCountries.mgdL)
            
//            print ("Unit the chosen unit for the language = \(theSpeakableUnit)")
    
 //print (speechLanguage)
    
    if demoMode {
        
        switch returnLanguageCodeFromCombinedCode(combinedCode: speechLanguage).lowercased() {
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
        
        switch returnLanguageCodeFromCombinedCode(combinedCode: speechLanguage).lowercased() {
                    
                case "en":  theSpeakableString = theSpeakableString + ".This is a demo value "
                case "de":  theSpeakableString = theSpeakableString + ".Dies ist ein Demo-Wert."
                case "ja":  theSpeakableString = theSpeakableString + "。この値はサンプルです。"
                case "ko":  theSpeakableString = theSpeakableString + ".이것은 데모 값입니다."
                case "it":  theSpeakableString = theSpeakableString + ".Questo è un valore di dimostrazione."
                case "es":  theSpeakableString = theSpeakableString + ".Este es un valor de demostración."
                case "fr":  theSpeakableString = theSpeakableString + ".Il s'agit d'une valeur de démonstration."
                case "zh":  theSpeakableString = theSpeakableString + ".這是一個演示值"

        default:    theSpeakableString = theSpeakableString + ".This is a demo value."

        }
        
    }
    
    
    if speakElapsedTime {
        
        
        switch returnLanguageCodeFromCombinedCode(combinedCode: speechLanguage).lowercased() {
          case "en":
            theSpeakableString = theSpeakableString + ",. " + "The last blood glucose entry by " + elapsedTimeFormatter (timeSinceUpdateInSeconds: elapsedTime, recordingDevice: recordingDevice, language: speechLanguage, demoMode: demoMode)
            
          case "de":
            theSpeakableString = theSpeakableString + ",. " + "Der letzte Blutzuckereintrag von " + elapsedTimeFormatter (timeSinceUpdateInSeconds: elapsedTime, recordingDevice: recordingDevice, language: speechLanguage, demoMode: demoMode)
            
          case "ja":
            theSpeakableString = "\(theSpeakableString),。最新の血糖ちの記録は　\(elapsedTimeFormatter (timeSinceUpdateInSeconds: elapsedTime, recordingDevice: recordingDevice, language: speechLanguage, demoMode: demoMode)) 前です。"
            
            
          case "ko":
            theSpeakableString = theSpeakableString + ",. " + "최근 혈당 입력은 " + elapsedTimeFormatter (timeSinceUpdateInSeconds: elapsedTime, recordingDevice: recordingDevice, language: speechLanguage, demoMode: demoMode) + " 일때 입력되었습니다"
          case "it":
            theSpeakableString = theSpeakableString + ",. " + "L'ultimo valore di glicemia è stato inserito " + elapsedTimeFormatter (timeSinceUpdateInSeconds: elapsedTime, recordingDevice: recordingDevice, language: speechLanguage, demoMode: demoMode)
          case "es":
            theSpeakableString = theSpeakableString + ",. " + "La última entrada de glucemia fue " + elapsedTimeFormatter (timeSinceUpdateInSeconds: elapsedTime, recordingDevice: recordingDevice, language: speechLanguage, demoMode: demoMode)
          case "fr":
            theSpeakableString = theSpeakableString + ",. " + "La dernière entrée de glycémie a été effectuée " + elapsedTimeFormatter (timeSinceUpdateInSeconds: elapsedTime, recordingDevice: recordingDevice, language: speechLanguage, demoMode: demoMode)
            
                        
          default:
            theSpeakableString = theSpeakableString +  ",. " + "The last blood glucose entry by " + elapsedTimeFormatter (timeSinceUpdateInSeconds: elapsedTime, recordingDevice: recordingDevice, language: speechLanguage, demoMode: demoMode)
        }
        
        
    }
    
//    print ("dataTooOldPeriod_min:  \(dataTooOldPeriod_min)")
//    print ("dataTooOldPeriod_sec:  \(dataTooOldPeriod_min * SecondsIn.oneMinute.rawValue * 2)")
//
        
//        let glucoseSamplePeriodInSeconds = bloodGlucoseData.returnGlucoseMonitor
        
    if warnNoFreshData && elapsedTime > ((dataTooOldPeriod_min * SecondsIn.oneMinute.rawValue) + warningMargin_sec )  {
        
        print ("elapsedTime: \(elapsedTime)")
        
        let theDifference = elapsedTime - ((dataTooOldPeriod_min * SecondsIn.oneMinute.rawValue))
        
        //        print ("theDifference \(theDifference)")
        
        if (theDifference > SecondsIn.twoMinutes.rawValue) && (theDifference < SecondsIn.twoHours.rawValue) {    print ("between 2 minutes and two hour")
            
            theDifferenceString = "over \(theDifference / SecondsIn.oneMinute.rawValue) minutes"
        }
        
        else if (theDifference > SecondsIn.twoHours.rawValue)  &&  (theDifference < SecondsIn.oneDay.rawValue) {
            
            print ("between two hours and one day")
            theDifferenceString = "over \(theDifference / SecondsIn.oneHour.rawValue) hours"
        }
        
        else if (theDifference > SecondsIn.oneDay.rawValue) { // over one day
            
            theDifferenceString = "more than one day."
        }
        
        else { theDifferenceString = "\(theDifference + 1) seconds" }
        
        
        
        theSpeakableString = theSpeakableString + ",. Data is too old by \(theDifferenceString). There may be some issues with your HealthKit data or the devices."
    }
    
        
        if rawValue == TheAppErrorCodes.userNotAgreedToAgreement.rawValue {
        
        theSpeakableString = "You need to agree to the User Agreement in Settings before you can use this app."
    }
    
    return theSpeakableString
    
}




//class BackGroundSpeechSynthesizer {
//    let synthesizer = AVSpeechSynthesizer()
//    var timer: Timer?
//    var glucoseManager: BloodGlucoseManager?
//
//
//
//
//
//
//    func startSpeaking(_ text: String, interval: TimeInterval = 10, rate: Float = AVSpeechUtteranceDefaultSpeechRate, pitchMultiplier: Float = 1.0, volume: Float = 1.0, language: String = "en-US") {
//        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
//            let utterance = AVSpeechUtterance(string: text)
//            utterance.rate = rate
//            utterance.pitchMultiplier = pitchMultiplier
//            utterance.volume = volume
//            utterance.voice = AVSpeechSynthesisVoice(language: language)
//
//
//            self?.synthesizer.speak(utterance)
//        }
//    }
//
//
//    func stopSpeaking() {
//        timer?.invalidate()
//        timer = nil
//    }
//
//
//
//
//
//}
//
//
//
//
//
//
//
//class SpeechCoordinator: ObservableObject {
//    private let speech = BackGroundSpeechSynthesizer()
//    func startSpeaking() {
//        speech.startSpeaking("test")
//    }
//}

enum OutputPort {
    case builtInSpeaker
    case bluetooth
    
    // Computed property to get the AVAudioSession.Port for each output
    var port: AVAudioSession.Port {
        switch self {
        case .builtInSpeaker:
            return .builtInSpeaker
        case .bluetooth:
            return .bluetoothHFP
        }
    }
}


/*

class TTS: NSObject, AVSpeechSynthesizerDelegate {


    
    let synth = AVSpeechSynthesizer()
    let audioSession = AVAudioSession.sharedInstance()
    var outputPort: AVAudioSession.Port = .builtInSpeaker

    @AppStorage("announcementOn")               public var announcementOn =                     true

    
    
    @AppStorage("outputSelectionOption")            public var outputSelectionOption =              outputOptionsDefault
 
    @AppStorage("deBugModeToggle") public var deBugModeToggle = true

    
    
    
    
    
    var speechCompletionHandler: (() -> Void)?
    
    
    
    
    
    
    
    override init() {
           super.init()

           do {
               try audioSession.setCategory(AVAudioSession.Category.playAndRecord)
           } catch let error {
               print("Error setting up audio session: \(error.localizedDescription)")
           }

           synth.delegate = self
       }
    
    
    
    
    
    
    
    
    
    
    
    

       func speakAnything(toBeSpoken: String, language: String? = nil, completion: (() -> Void)? = nil) {
           
           let audioSession = AVAudioSession.sharedInstance()
           
           let utterance = AVSpeechUtterance(string: toBeSpoken)
           if let language = language {
               utterance.voice = AVSpeechSynthesisVoice(language: language)
           } else {
               utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
           }

           
           
           //synth.stopSpeaking(at: .word)
           synth.speak(utterance)
           
           // Store the completion handler
           if let completion = completion {
               self.speechCompletionHandler = completion
           }
       }
    
    
    
    
    
    
    
    
    
    
    
    

       func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
           // Call the completion handler
           if let speechCompletionHandler = speechCompletionHandler {
               speechCompletionHandler()
           }
       }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func switchToBluetooth() {
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(.playAndRecord, options: [.allowBluetoothA2DP, .allowBluetooth])
            try session.setActive(true)
        } catch {
            print("Error switching to Bluetooth: \(error.localizedDescription)")
        }
    }
    
    func switchToSpeaker() {
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(.playAndRecord, options: .defaultToSpeaker)
            try session.setActive(true)
        } catch {
            print("Error switching to speaker: \(error.localizedDescription)")
        }
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*
    
    
    
    
    
    func speakTimeNow (sampleTime: Date) {
        
        
        
//        var  finalSpeak =  formatTime_HH_mm_ss_Spaces()

        let timeInterval = Int(Date().timeIntervalSince(sampleTime))
        
        if timeInterval > Int(rodisBirthdayTimeStamp) {return}
        
        let timeIntervalString = formatSecondsToTimeString(timeInterval) + "  ago."
        //================================================
        //================================================
        //================================================

        if timeInterval < SecondsIn.tenSeconds.rawValue { return }
    
        let utterance = AVSpeechUtterance(string: timeIntervalString)
        
        
      
        
        synth.usesApplicationAudioSession = true
        
        
        
        //synth.stopSpeaking(at: .word)

        
       // print (utterance)
        printTimestamp(description: "speakTimeNow", content: timeIntervalString, label: "🔊 ")

        
        let result = synth.stopSpeaking(at: .word)

        
        
        if announcementOn {synth.speak(utterance)}
        
        
        
        
        else { print ("\n\n**!!**!! announcementOn = FALSE\n\n ")}
        
        print ("synth.speak(utterance) ended")
        
    }
    
    
    
    */
    
    
    
    
    
    
    
    /*
    
    
    func speak(theSpeak: Double,
               sampleTime: Date,
               includeUnit: Bool,
               userBloodGlucoseUnit: String,
               speakElapsedTime : Bool,
               elapsedTime: Int,
               warnNoFreshData: Bool,
               dataTooOldPeriod_min: Int,
               speechSpeed : String,
               speechGender: String,
               speechLanguage: String,
               demoMode: Bool,
               skipHundredth: Bool,
               recordingDevice: String,
               mixToTelephone: Bool,
               usesApplicationAudioSession: Bool,
               voiceName: String,
               voiceID: String,
               combinedLanguageCode: String,
               speechVoiceVolume: Double,
               appScenePhase: ScenePhase,
               whoCalledTheFunction: WhoCalledTheFunction,
               theGlucoseMayBeTooOld: Bool = false
        ) {
        
//     printTimestamp(description: "TTS: fun speak", content: String(theSpeak), label: "SP ")
//        print ("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$")
//        print ("we are on .speak: \(speechLanguage)")
//        print ("for voice: \(voiceName)")
//
        let theAvailableLanguages = Locale.preferredLanguages
        
//        for theVoices in availableVoices  {
//            print( "#### theAvailableLanguages \(theVoices)")
//        }
        
        var threeSpeechSpeed: Float
        //var theSpeechLanguage: String
        
        if speechSpeed == "tortoise" {threeSpeechSpeed = 0.4 }
        else if speechSpeed == "Normal" {threeSpeechSpeed = 0.5 }
        else  {threeSpeechSpeed = 0.6 }
        
//synth.stopSpeaking(at: .word)
        
//        print ("")
//        print ("************ TTS")
//        print ("************ speechLanguage: \(speechLanguage)")
////        print ("************ voiceID: \(voiceID)")
//        print ("************ voiceID: \(voiceName)")
//        print ("************ TTS")
//        print ("")
        
//        theSpeechLanguage = speechLanguage
        
      //  print ("theSpeechLanguage ***: \(speechLanguage)")
        
        var finalSpeak = returnSpeakableGlucoseValue(       rawValue: theSpeak,                             userBloodGlucoseUnit: userBloodGlucoseUnit,
                                                            speakElapsedTime : speakElapsedTime,            elapsedTime : elapsedTime,
                                                            includeUnit: includeUnit,                       warnNoFreshData: warnNoFreshData,
                                                            dataTooOldPeriod_min: dataTooOldPeriod_min,     speechSpeed : Double(threeSpeechSpeed),
                                                            speechGender: speechGender,                     demoMode: demoMode,
                                                            skipHundredth: skipHundredth,                   recordingDevice: recordingDevice,
                                                            mixToTelephone: mixToTelephone, usesApplicationAudioSession: usesApplicationAudioSession,                 speechLanguage: combinedLanguageCode, speechVoiceName: voiceName,
                                                            speechVoiceVolume: speechVoiceVolume,           appScenePhase: appScenePhase
                                                            )

        
        
        
        
        //================================================
        //==================debug section=================
        //================================================

        
        
        if deBugMode && deBugModeToggle {
            
            
            
            
            print ("12345.67")
            
//            finalSpeak = "From " + whoCalledTheFunction.rawValue + ".  " + finalSpeak
        }
        
        if thisIsBeta && theSpeak == TheAppErrorCodes.SweetnessesLastError.rawValue {
                
              //  finalSpeak = finalSpeak + " Many sweetness is empty."
            
             print ("12345.6")

            }
        else
        if !thisIsBeta &&  theSpeak == TheAppErrorCodes.SweetnessesLastError.rawValue {
            return
        }
        
        
//       / finalSpeak = finalSpeak  + ". " +  formatTime_HH_mm_ss_Spaces()

        //================================================
        //================================================
        //================================================

        let timeInterval = Int(Date().timeIntervalSince(sampleTime))
        
        if timeInterval > Int(rodisBirthdayTimeStamp) {return}
        
        let timeIntervalString = formatSecondsToTimeString(timeInterval) + "  ago."
        
        finalSpeak = timeIntervalString + finalSpeak
        
        
        
        
        /*
        if theGlucoseMayBeTooOld {
            print (" the data may be too old.")
            finalSpeak = finalSpeak + ". The data may be old."
        } else {
            print (" the data may be fresh.")

            finalSpeak = finalSpeak + ". The data should be fresh."
              }
        */
        
//        print ("UUUUUU speechLanguage: \(combinedLanguageCode)")
//        print ("UUUUUU voiceID: \(voiceID)")
        if demoMode {print ("Demo Mode")}
        
        let utterance = AVSpeechUtterance(string: finalSpeak)
        
        utterance.voice = AVSpeechSynthesisVoice(language: combinedLanguageCode)

//        print ("!@!@!@ \(combinedLanguageCode)")
        utterance.rate = threeSpeechSpeed
        utterance.volume = Float(speechVoiceVolume)  // Set the volume to speechVoiceVolume (0-1)


        
      //  utterance.voice = AVSpeechSynthesisVoice(language: speechLanguage)
        
        
        
  //     let voice = AVSpeechSynthesisVoice(identifier: voiceID)
        
        
        //utterance.voice = AVSpeechSynthesisVoice(identifier: voiceID)
        
        
        
//        utterance.voice = voice
        
        
        if mixToTelephone  {synth.mixToTelephonyUplink = true}
        else {synth.mixToTelephonyUplink = false}
        
        if usesApplicationAudioSession  {synth.usesApplicationAudioSession = true}
        else {synth.usesApplicationAudioSession = false}
        
        
        
       // print (utterance)
        printTimestamp(description: "finalSpeak", content: finalSpeak, label: "🔊 ")

        
  
        if announcementOn {
            DispatchQueue.main.async {
                
                
                self.speakAnything(toBeSpoken: finalSpeak) {
                   // print("utterance finished.")
                }
            
                
                
                //self.synth.speak(utterance)
            }
            
        }
        
        
        
        
        else { print ("\n\n**!!**!! announcementOn = FALSE\n\n ")}
        
        print ("synth.speak(utterance) ended")
    }
 
    
    */
    
    
    
    
    
    
    
    
    /*
    
    
    func stopSpeakingNow () {
        
        let result = synth.stopSpeaking(at: .immediate)
        
        print("synth.stopSpeaking(at: .immediate)               ***")
        if result {(print ("success"))}
    }
    
  
    
    */
    
    
    
    
}


 
 
 */



/*
 
 
 */


/*
 
 de: DE: de-DE: Sandy: com.apple.eloquence.de-DE.Sandy
 de: DE: de-DE: Shelley: com.apple.eloquence.de-DE.Shelley
 de: DE: de-DE: Helena: com.apple.ttsbundle.siri_Helena_de-DE_compact
 de: DE: de-DE: Grandma: com.apple.eloquence.de-DE.Grandma
 de: DE: de-DE: Grandpa: com.apple.eloquence.de-DE.Grandpa
 de: DE: de-DE: Eddy: com.apple.eloquence.de-DE.Eddy
 de: DE: de-DE: Reed: com.apple.eloquence.de-DE.Reed
 de: DE: de-DE: Anna: com.apple.voice.compact.de-DE.Anna
 de: DE: de-DE: Martin: com.apple.ttsbundle.siri_Martin_de-DE_compact
 de: DE: de-DE: Rocko: com.apple.eloquence.de-DE.Rocko
 de: DE: de-DE: Flo: com.apple.eloquence.de-DE.Flo
 
 en: AU: en-AU: Gordon: com.apple.ttsbundle.siri_Gordon_en-AU_compact
 en: AU: en-AU: Karen: com.apple.voice.compact.en-AU.Karen
 en: AU: en-AU: Catherine: com.apple.ttsbundle.siri_Catherine_en-AU_compact
 en: GB: en-GB: Rocko: com.apple.eloquence.en-GB.Rocko
 en: GB: en-GB: Shelley: com.apple.eloquence.en-GB.Shelley
 en: GB: en-GB: Daniel: com.apple.voice.compact.en-GB.Daniel
 en: GB: en-GB: Martha: com.apple.ttsbundle.siri_Martha_en-GB_compact
 en: GB: en-GB: Grandma: com.apple.eloquence.en-GB.Grandma
 en: GB: en-GB: Grandpa: com.apple.eloquence.en-GB.Grandpa
 en: GB: en-GB: Flo: com.apple.eloquence.en-GB.Flo
 en: GB: en-GB: Eddy: com.apple.eloquence.en-GB.Eddy
 en: GB: en-GB: Reed: com.apple.eloquence.en-GB.Reed
 en: GB: en-GB: Sandy: com.apple.eloquence.en-GB.Sandy
 en: GB: en-GB: Arthur: com.apple.ttsbundle.siri_Arthur_en-GB_compact
 en: IE: en-IE: Moira: com.apple.voice.compact.en-IE.Moira
 en: IN: en-IN: Rishi: com.apple.voice.compact.en-IN.Rishi
 en: US: en-US: Flo: com.apple.eloquence.en-US.Flo
 en: US: en-US: Bahh: com.apple.speech.synthesis.voice.Bahh
 en: US: en-US: Albert: com.apple.speech.synthesis.voice.Albert
 en: US: en-US: Fred: com.apple.speech.synthesis.voice.Fred
 en: US: en-US: Jester: com.apple.speech.synthesis.voice.Hysterical
 en: US: en-US: Organ: com.apple.speech.synthesis.voice.Organ
 en: US: en-US: Cellos: com.apple.speech.synthesis.voice.Cellos
 en: US: en-US: Zarvox: com.apple.speech.synthesis.voice.Zarvox
 en: US: en-US: Rocko: com.apple.eloquence.en-US.Rocko
 en: US: en-US: Shelley: com.apple.eloquence.en-US.Shelley
 en: US: en-US: Superstar: com.apple.speech.synthesis.voice.Princess
 en: US: en-US: Grandma: com.apple.eloquence.en-US.Grandma
 en: US: en-US: Eddy: com.apple.eloquence.en-US.Eddy
 en: US: en-US: Bells: com.apple.speech.synthesis.voice.Bells
 en: US: en-US: Grandpa: com.apple.eloquence.en-US.Grandpa
 en: US: en-US: Trinoids: com.apple.speech.synthesis.voice.Trinoids
 en: US: en-US: Kathy: com.apple.speech.synthesis.voice.Kathy
 en: US: en-US: Reed: com.apple.eloquence.en-US.Reed
 en: US: en-US: Boing: com.apple.speech.synthesis.voice.Boing
 en: US: en-US: Whisper: com.apple.speech.synthesis.voice.Whisper
 en: US: en-US: Wobble: com.apple.speech.synthesis.voice.Deranged
 en: US: en-US: Good News: com.apple.speech.synthesis.voice.GoodNews
 en: US: en-US: Nicky: com.apple.ttsbundle.siri_Nicky_en-US_compact
 en: US: en-US: Bad News: com.apple.speech.synthesis.voice.BadNews
 en: US: en-US: Aaron: com.apple.ttsbundle.siri_Aaron_en-US_compact
 en: US: en-US: Bubbles: com.apple.speech.synthesis.voice.Bubbles
 en: US: en-US: Samantha: com.apple.voice.compact.en-US.Samantha
 en: US: en-US: Sandy: com.apple.eloquence.en-US.Sandy
 en: US: en-US: Junior: com.apple.speech.synthesis.voice.Junior
 en: US: en-US: Ralph: com.apple.speech.synthesis.voice.Ralph
 en: ZA: en-ZA: Tessa: com.apple.voice.compact.en-ZA.Tessa

 es: ES: es-ES: Shelley: com.apple.eloquence.es-ES.Shelley
 es: ES: es-ES: Grandma: com.apple.eloquence.es-ES.Grandma
 es: ES: es-ES: Rocko: com.apple.eloquence.es-ES.Rocko
 es: ES: es-ES: Grandpa: com.apple.eloquence.es-ES.Grandpa
 es: ES: es-ES: Mónica: com.apple.voice.compact.es-ES.Monica
 es: ES: es-ES: Sandy: com.apple.eloquence.es-ES.Sandy
 es: ES: es-ES: Flo: com.apple.eloquence.es-ES.Flo
 es: ES: es-ES: Eddy: com.apple.eloquence.es-ES.Eddy
 es: ES: es-ES: Reed: com.apple.eloquence.es-ES.Reed
 es: MX: es-MX: Rocko: com.apple.eloquence.es-MX.Rocko
 es: MX: es-MX: Paulina: com.apple.voice.compact.es-MX.Paulina
 es: MX: es-MX: Flo: com.apple.eloquence.es-MX.Flo
 es: MX: es-MX: Sandy: com.apple.eloquence.es-MX.Sandy
 es: MX: es-MX: Eddy: com.apple.eloquence.es-MX.Eddy
 es: MX: es-MX: Shelley: com.apple.eloquence.es-MX.Shelley
 es: MX: es-MX: Grandma: com.apple.eloquence.es-MX.Grandma
 es: MX: es-MX: Reed: com.apple.eloquence.es-MX.Reed
 es: MX: es-MX: Grandpa: com.apple.eloquence.es-MX.Grandpa
 
 fr: CA: fr-CA: Shelley: com.apple.eloquence.fr-CA.Shelley
 fr: CA: fr-CA: Grandma: com.apple.eloquence.fr-CA.Grandma
 fr: CA: fr-CA: Grandpa: com.apple.eloquence.fr-CA.Grandpa
 fr: CA: fr-CA: Rocko: com.apple.eloquence.fr-CA.Rocko
 fr: CA: fr-CA: Eddy: com.apple.eloquence.fr-CA.Eddy
 fr: CA: fr-CA: Reed: com.apple.eloquence.fr-CA.Reed
 fr: CA: fr-CA: Amélie: com.apple.voice.compact.fr-CA.Amelie
 fr: CA: fr-CA: Flo: com.apple.eloquence.fr-CA.Flo
 fr: CA: fr-CA: Sandy: com.apple.eloquence.fr-CA.Sandy
 fr: FR: fr-FR: Grandma: com.apple.eloquence.fr-FR.Grandma
 fr: FR: fr-FR: Flo: com.apple.eloquence.fr-FR.Flo
 fr: FR: fr-FR: Rocko: com.apple.eloquence.fr-FR.Rocko
 fr: FR: fr-FR: Grandpa: com.apple.eloquence.fr-FR.Grandpa
 fr: FR: fr-FR: Sandy: com.apple.eloquence.fr-FR.Sandy
 fr: FR: fr-FR: Eddy: com.apple.eloquence.fr-FR.Eddy
 fr: FR: fr-FR: Daniel: com.apple.ttsbundle.siri_Daniel_fr-FR_compact
 fr: FR: fr-FR: Thomas: com.apple.voice.compact.fr-FR.Thomas
 fr: FR: fr-FR: Jacques: com.apple.eloquence.fr-FR.Jacques
 fr: FR: fr-FR: Marie: com.apple.ttsbundle.siri_Marie_fr-FR_compact
 fr: FR: fr-FR: Shelley: com.apple.eloquence.fr-FR.Shelley

 it: IT: it-IT: Eddy: com.apple.eloquence.it-IT.Eddy
 it: IT: it-IT: Sandy: com.apple.eloquence.it-IT.Sandy
 it: IT: it-IT: Reed: com.apple.eloquence.it-IT.Reed
 it: IT: it-IT: Shelley: com.apple.eloquence.it-IT.Shelley
 it: IT: it-IT: Grandma: com.apple.eloquence.it-IT.Grandma
 it: IT: it-IT: Grandpa: com.apple.eloquence.it-IT.Grandpa
 it: IT: it-IT: Flo: com.apple.eloquence.it-IT.Flo
 it: IT: it-IT: Rocko: com.apple.eloquence.it-IT.Rocko
 it: IT: it-IT: Alice: com.apple.voice.compact.it-IT.Alice
 
 ja: JP: ja-JP: O-ren: com.apple.ttsbundle.siri_O-ren_ja-JP_compact
 ja: JP: ja-JP: Kyoko: com.apple.voice.compact.ja-JP.Kyoko
 ja: JP: ja-JP: Hattori: com.apple.ttsbundle.siri_Hattori_ja-JP_compact

 ko: KR: ko-KR: Yuna: com.apple.voice.compact.ko-KR.Yuna
 
 zh: CN: zh-CN: Li-mu: com.apple.ttsbundle.siri_Li-mu_zh-CN_compact
 zh: CN: zh-CN: Tingting: com.apple.voice.compact.zh-CN.Tingting
 zh: CN: zh-CN: Yu-shu: com.apple.ttsbundle.siri_Yu-shu_zh-CN_compact
 zh: HK: zh-HK: Sinji: com.apple.voice.compact.zh-HK.Sinji
 zh: TW: zh-TW: Meijia: com.apple.voice.compact.zh-TW.Meijia
 
 
 
 
 */
