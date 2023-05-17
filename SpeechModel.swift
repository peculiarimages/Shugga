//
//  SpeechModel.swift
//  Shugga
//
//  Created by Rodi on 3/9/23.
//

import Foundation
import AVFoundation
import SwiftUI
import BackgroundTasks

enum AudioOutputPort: String, CaseIterable {
    
    case automagical =      "Automagical"
    
    case builtInSpeaker =   "Built-in Speaker"
    
    case builtInReceiver =  "Built-in Receiver"
    
    case builtInMic =       "Built-in Mic"
    
    case bluetoothA2DP =    "Bluetooth A2DP"
    
    case bluetoothLE =      "Bluetooth LE"
    
    case headphones =       "Headphones"
    
    case lineOut =          "Line Out"
    
    case airPlay =          "AirPlay"
    
    case usbAudio =         "USB Audio"
    
    case displayPort =      "DisplayPort"
    
    case carAudio =         "Car Audio"
    
    
    var audioSessionPort: AVAudioSession.Port {
        switch self {
        case .automagical:
            return .builtInSpeaker
            
        case .builtInSpeaker:
            return .builtInSpeaker
            
        case .builtInReceiver:
            return .builtInReceiver
            
        case .builtInMic:
            return .builtInMic
            
        case .bluetoothA2DP:
            return .bluetoothA2DP
            
        case .bluetoothLE:
            return .bluetoothLE
            
        case .headphones:
            return .headphones
            
        case .lineOut:
            return .lineOut
            
        case .airPlay:
            return .airPlay
            
        case .usbAudio:
            return .usbAudio
            
        case .displayPort:
            return .displayPort
            
        case .carAudio:
            return .carAudio
        }
    }
    
    static var allCasesAsStrings: [String] {
        return AudioOutputPort.allCases.map({ $0.rawValue })
    }
    
}



struct SynthSpeechParameters {
    @AppStorage("demoMode")                             public var demoMode =                           false

    @AppStorage("voiceVolume")                          public var voiceVolume: Double =                1.0
    @AppStorage("threeSpeechSpeed")                     public var threeSpeechSpeed =                   defaultThreeSpeechSpeed
    @AppStorage("speakInterval_seconds")                public var speakInterval_seconds:               Int =  defaultShuggaInterval // this is going to be multiples of 10 seconds
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
    
    
    let speechString: String? = ""
    
    let port: AudioOutputPort? = .automagical
    
    var volume: Float { return Float(voiceVolume)  }

    var rate: Float {
        let speed = SugahSpeed(rawValue: threeSpeechSpeed) ?? .normal
        
        return Float(speed.speedValue)
    }
     
    let pitchMultiplier: Float? =               1.0
    
    let preUtteranceDelay: Double? =            1.0
    let postUtteranceDelay: Double? =           1.0
    
    let willSpeakRange: AVSpeechBoundary? =     .word
    
    let languageCode:           String? =       defaultShuggaLanguageCode // en
    let regionCode:             String? =       defaultShuggaLanguageRegionCode // US
    var combinedLanguageCode:   String? =       defaultShuggaLanguageCombinedCode

    // glucose related
    
    
    
   // let voice: AVSpeechSynthesisVoice? = AVSpeechSynthesisVoice(language: AVSpeechSynthesisVoice.currentLanguageCode())
    
    
    
    var voice: AVSpeechSynthesisVoice {
        if let voiceName = AVSpeechSynthesisVoice(language: sugahLanguageCombinedCodeChosen) {
            return voiceName
        }
        
        /*
        else if let defaultVoiceName = AVSpeechSynthesisVoice(language: AVSpeechSynthesisVoice.currentLanguageCode()) {
            return defaultVoiceName
        }
        */
        else {
//            combinedLanguageCode = defaultShuggaLanguageCombinedCode
            return AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.Samantha-compact")!
        }
    }

    
    
    
    
    
    
    let audioSessionCategory: AVAudioSession.Category? = .playback //
//        .playback: Used for playing recorded music or other sounds that are central to the successful use of your app.
//        .record: Used for recording audio, either alone or in conjunction with audio playback.
//        .playAndRecord: Used for apps that need to both play and record audio simultaneously, like a Voice over IP (VoIP) app.
//        .ambient: Used for apps that provide non-primary audio, like a game with background music.
    
    let audioSessionMode: AVAudioSession.Mode? = .spokenAudio
//        .default: This is the default mode for the audio session category. When no other mode is specified,
//                  this mode is used. It provides the standard audio behavior for the chosen category, without
//                  any additional refinements.
//        .spokenAudio: This mode is specifically designed for spoken content, such as voice prompts, audiobooks,
//                  podcasts, or any other voice-based media. When this mode is active, the system prioritizes the
//                  playback of spoken content and may adjust the audio processing accordingly. For example, it can
//                  pause background music when the spoken content starts and resume it when the spoken content ends.
//        .voiceChat: This mode is tailored for real-time voice chat applications, such as VoIP (Voice over IP) or
//                  multiplayer games with voice communication. When active, the system optimizes the audio processing
//                  for low-latency, bi-directional communication. This may involve using echo cancellation, noise
//                  reduction, and automatic gain control to improve the clarity of the voice chat.
//        .videoChat: Similar to .voiceChat, this mode is designed for real-time video chat applications. In addition
//                  to optimizing audio processing for low-latency communication, this mode also synchronizes the
//                  audio with the video stream to ensure a smooth and coherent user experience.
    
    let mixWithOthers: Bool? = true
    
//    let gender: String? // may be pitchMultiplier thing
}




class CustomOperation: Operation {
    var typesOfSpeech: TypesOfSpeech
    
    // Other properties needed for speech synthesis
    let speechString: String
    let language: String?
    let synth: AVSpeechSynthesizer
    
    init(typesOfSpeech: TypesOfSpeech, speechString: String, language: String? = nil, synth: AVSpeechSynthesizer) {
        self.typesOfSpeech = typesOfSpeech
        self.speechString = speechString
        self.language = language
        self.synth = synth
    }
    
    override func main() {
        // Your speech synthesis code here
    }
}



class Speech: NSObject, AVSpeechSynthesizerDelegate, ObservableObject {
   
    @AppStorage("pauseNow")                   public var pauseNow =                     false
    @AppStorage("sugahLanguageCombinedCodeChosen")      public var sugahLanguageCombinedCodeChosen =    "en-US"
    @AppStorage("sugahVoiceChosen")                     public var sugahVoiceChosen =                   defaultSugahVoice

    
    static let shared = Speech()

    var shuggaStatus =  ShuggaStatus.shared

    var synth = AVSpeechSynthesizer()
    private(set) var isSpeaking: Bool = false
    var speechCompletionHandler: ((Result<Void, Error>) -> Void)?
    
    @Published var speakingImportantShugga = false
    @Published var currentAudioPortType: AVAudioSession.Port.RawValue?

    var isItSpeaking: TypesOfSpeech = .off
    

    private var speechQueue = OperationQueue()

    override init() {
        super.init()
        synth.delegate = self
        
        // Register for AVAudioSessionRouteChange notifications
             NotificationCenter.default.addObserver(self, selector: #selector(handleAudioRouteChange(notification:)), name: AVAudioSession.routeChangeNotification, object: nil)

             // Update the currentAudioPortType for the first time
             updateCurrentAudioPortType()
    }

    deinit {
         NotificationCenter.default.removeObserver(self)
     }
    
    // MARK: - AVSpeechSynthesizerDelegate methods

    
    
    
    
    
    
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        
        if self.isSpeaking && self.speakingImportantShugga == false {
            synth.stopSpeaking(at: .word)
//            DispatchQueue.main.async {
//
//                self.shuggaStatus.shuggaState = .stoppingExistingShugga
//            }
            
        }
//        isSpeaking = true
        
        DispatchQueue.main.async {
            
            self.shuggaStatus.shuggaState = .shuggaInProgress
        }
           print("Speech started")
       }

       func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
           isSpeaking = false
        
           print("Speech finished")

           // Call the completion handler if it exists
           speechCompletionHandler?(.success(()))
       }

       func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
           isSpeaking = false
           print("Speech canceled")

           // Call the completion handler if it exists, with an appropriate error
           speechCompletionHandler?(.failure(SpeechError.unknown))
       }
    
    
    func resetSynth() {
        if isSpeaking {
            // Stop any ongoing speech
            synth.stopSpeaking(at: .immediate)
        }
        
        // Create a new AVSpeechSynthesizer instance and set its delegate
        synth = AVSpeechSynthesizer()
        synth.delegate = self
    }
    
    func stopSpeakingNow () {
        
        let result = synth.stopSpeaking(at: .word)
        
        print("synth.stopSpeaking(at: .immediate)               ***")
//        speakAnything(speechString: "A newer value found.")
        
        
        if result {
            (print ("success"))
            isSpeaking = false
        }
    }
    
    
    func prepareSpeechSynthesizer() {
         let silentUtterance = AVSpeechUtterance(string: "")
         silentUtterance.volume = 0
         synth.speak(silentUtterance)
     }
    
    
    
    
    
    
    
    
    
    
    
    func speakAnything(speechString: String, typesOfSpeech: TypesOfSpeech, language: String? = nil, completion: ((Result<Void, Error>) -> Void)? = nil) {
        
        
        if typesOfSpeech == .bloodGlucoseValue ||  typesOfSpeech == .carbReminder {
               // Iterate through existing operations in the queue and cancel specific ones
            
            if synth.isSpeaking {
                
                 //   stopSpeakingNow()
                
            }
            
            }
        
        
        var importantShugga = false
        
        let speechRequest: () -> Void = { [weak self] in
            guard let self = self else { return }
            
            
            //self.prepareSpeechSynthesizer()
            
//            DispatchQueue.main.async {
//
//                self?.updateCurrentAudioPortType()
//                if ((self?.isSpeaking) != nil) {
//                    self?.stopSpeakingNow()
//                }
//            }
            
            //            let synthSpeechParameters = SynthSpeechParameters()
            let audioSession = AVAudioSession.sharedInstance()
            let utterance = AVSpeechUtterance(string: speechString)
            
            if let language = language {
                utterance.voice = AVSpeechSynthesisVoice(language: language)
            } else {
                utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            }
            
            let synthSpeechParameters = SynthSpeechParameters()
            
            // Apply SynthSpeechParameters if available
            utterance.volume = synthSpeechParameters.volume
            utterance.pitchMultiplier = synthSpeechParameters.pitchMultiplier ?? 1.0
            utterance.preUtteranceDelay = synthSpeechParameters.preUtteranceDelay ?? 0.0
            utterance.postUtteranceDelay = synthSpeechParameters.postUtteranceDelay ?? 0.0
            utterance.rate  = synthSpeechParameters.rate
//            utterance.voice = synthSpeechParameters.voice

//            printTimestamp(description: "Speech voice name", content: String(synthSpeechParameters.voice), label: "声")
           
           
            
            
            
            
            
            
            
            
            let desiredVoiceName = sugahVoiceChosen.dropFirst(2)
            
            printTimestamp(description: "desiredVoiceName", content: String(desiredVoiceName), label: "声")
            var selectedVoice: AVSpeechSynthesisVoice?

            
            
            
            for voice in AVSpeechSynthesisVoice.speechVoices() {
                print ("\(voice.name) : \(voice.language.prefix(2))")
                if voice.name == desiredVoiceName && voice.language.prefix(2) == "en"
                {
                    selectedVoice = voice
                    break
                }
            }

            if let voice = selectedVoice {
                // Set the voice for the utterance
                utterance.voice = voice
            } else {
                // The desired voice is not available
                
                
                print("Desired voice '\(desiredVoiceName)' not found")
            }

            
            
            
            
            
            
            
            
            
            
            
            
            // Speak the utterance
            if !pauseNow {
                self.synth.speak(utterance)
            }else {
                if let completion = completion {
                    completion(.failure(SpeechError.shuggaPaused))
                }
            }
            
            // Store the completion handler
            printTimestamp(description: "Speech.SpeakAnything() - completed", content: "\"\(speechString)\"", label: "🔊🔊 ")
            
            if let completion = completion {
                self.speechCompletionHandler = { result in
                    switch result {
                    case .success:
                        completion(.success(()))
                    case .failure(let error):
                        self.resetSynth()
                        
                        completion(.failure(error))
                    }
                }
            }
        }
        
        
                
      
            
           
        
        speechQueue.addOperation(speechRequest)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func purgeQueue() {
        // Cancel all currently scheduled tasks
        speechQueue.cancelAllOperations()
        
        // Create a new instance of the queue to ensure it's empty
        speechQueue = OperationQueue()
        speechQueue.name = "com.yourapp.speechQueue"
        speechQueue.qualityOfService = .userInitiated
    }
    
    
    
    
    

        @objc func handleAudioRouteChange(notification: Notification) {
            updateCurrentAudioPortType()
        }

        private func updateCurrentAudioPortType() {
            let audioSession = AVAudioSession.sharedInstance()
            if let currentRoute = audioSession.currentRoute.outputs.first {
                currentAudioPortType = currentRoute.portType.rawValue
            }
        }





}
/*
 
 how to call speakAnything:
 
 
 
 speech.speakAnything(speechString: "Hello, this is an example.", language: "en-US") { result in
     switch result {
     case .success:
         print("Speech ended successfully.")
     case .failure(let error):
         print("Speech ended with an error: \(error)")
     }
 }
 
 or
 
 speech.speakAnything(speechString: "Hello, this is an example without a completion closure.", language: "en-US")

 
 */
