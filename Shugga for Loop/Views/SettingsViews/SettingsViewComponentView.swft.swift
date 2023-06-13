//
//  SettingsViewComponentView.swft.swift
//  sugah
//
//  Created by Rodi on 2/10/23.
//

import SwiftUI
import AVFAudio
import BackgroundTasks

// --------------------- func ------------------------
func GetVoices() -> [String]
{
    var voiceNames : [String] = []
    AVSpeechSynthesisVoice.speechVoices().forEach({
        voiceNames.append("\($0.name)")
    } )
    
    return voiceNames
}

// ---------------------------------------------------
struct NavigationForSettingsView: View {
    
        let bloodGlucoseData = BloodGlucoseData.shared
    
    @AppStorage("userBloodGlucoseUnit")             public var userBloodGlucoseUnit =               defaultBloodGlucoseUnit
    @AppStorage("displayBothUnits")                   public var displayBothUnits =                        false
    @AppStorage("doubleTapForSugah")                public var doubleTapForSugah =                  false

    var body: some View {
        
        HStack {
           
            
            Spacer()
            
            
                  

                        VStack {
                            Image("logo 3")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .padding([.top, .leading, .trailing], 10)
                                .accessibilityLabel(_: "This is the logo of this app. It' a red rounded rectangle with a white speech bubble inside with a tiny red blood droplet inside it. This takes you to the settings.")
                            
                            Text ("ShuggaShugga")
                                .foregroundColor(logoTypeColor)
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                .accessibilityLabel(_: "\"S U G G A H\" is how we spell this app's name. This accessibility label reader says Shugga")
                                .lineLimit(1)
                                 .truncationMode(.tail)
                        }
                        .frame (width: 200)
                        .padding([.leading, .trailing], 5)
            
                        .onTapGesture(count: 2) {
                            
//                                        triggerHaptic(binaryPattern: "10101", timeUnit: 0.1)

                            handleSettingsLogoTapGesture(
                             doubleTapForSugah: doubleTapForSugah, bloodGlucoseData: bloodGlucoseData)
                            

                      
                        
                    }
            
          

            Spacer()
            
        

        }
        
        
        
        
    }
}







// ---------------------------------------------------

struct DeBugModeForSettingsView: View {
    
    @AppStorage("showConsole")        public var showConsole =              false

    @AppStorage("deBugModeToggle") public var deBugModeToggle =             false
    @AppStorage("appEarliestBeginDate") public var appEarliestBeginDate = SecondsIn.fiveMinutesPlusOneSec
    @AppStorage("backgroundTaskIsOn") public var backgroundTaskIsOn = true
    @AppStorage("backgroundAppRefreshIsOn") public var backgroundAppRefreshIsOn = true
    
    @State private var isTaskSubmitted = false
    
    @State private var earliestBeginDateTask: Date?
    @State private var earliestBeginDateRefresh: Date?



    let secondsInCases: [SecondsIn] = [.tenSeconds, .oneMinute, .sixtyOneSeconds, .twoMinutes, .fiveMinutes, .fiveMinutesPlusOneSec, .twentyMinutes, .oneHour, .twoHours, .halfDay, .oneDay]
    
    var body: some View {
        if thisIsBeta {
            
            Section(header: Text("Debug Settings")
                .font(.headline), footer: Text("⚠️ This should only be visible for developers & testers.\n⚠️ You will have to re-start the app to take effect.\nEBD = Earliest Begin Date")
            ) {
                
                Toggle(isOn: $deBugModeToggle) {
                    Text("Debug Mode is \(deBugModeToggle ? "on" : "off")")
                        .textCase(.none)
                        .frame(alignment: .leading)
                }
                
                if deBugModeToggle {
                    VStack {
                        
                        Toggle(isOn: $showConsole) {
                            Text("Console is \(showConsole ? "showing" : "hidden")")
                                .textCase(.none)
                                .frame(alignment: .leading)
                        }
                        
                        if showConsole {
                            ConsoleView()
                        }
                        
                        Picker("Earliest Begin Date (\(appEarliestBeginDate.rawValue))", selection: $appEarliestBeginDate) {
                            ForEach(secondsInCases, id: \.self) { secondsIn in
                                Text("\(secondsIn.rawValue)").tag(secondsIn)
                            }
                        }
                        
                        VStack {
                            Section(header: Text("Background Modes")
                                    
                            )
                            {
                                Toggle("Background Task is \(backgroundTaskIsOn ? "on" : "off")", isOn: $backgroundTaskIsOn)
                                    .onChange(of: backgroundTaskIsOn) { _ in
                                        isBGProcessingTaskSubmitted(withIdentifier: backgroundTaskID1, whoCalledTheFunction: .settingsView) { isSubmitted in
                                            isTaskSubmitted = isSubmitted
                                        }
                                    }
                                VStack {
                                    if isTaskSubmitted {
                                        Text("  The task is already submitted:").frame(maxWidth: .infinity, alignment: .leading)
                                        Text("  EBD: \(formatTime_HH_mm_ss(earliestBeginDateTask ?? rodisBirthday))").foregroundColor(.gray).frame(maxWidth: .infinity, alignment: .leading)
                                        let remainingSecondsTask = Int(max(0, earliestBeginDateTask?.timeIntervalSinceNow ?? 0))
                                        Text("  Remaining time until EBD: \(remainingSecondsTask) seconds").foregroundColor(.gray).frame(maxWidth: .infinity, alignment: .leading)
                                    } else {
                                        Text("  The task is not submitted").frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                                
                                
                                Toggle(NSLocalizedString("Background App-Refresh is \(backgroundAppRefreshIsOn ? "on" : "off")", comment: ""), isOn: $backgroundAppRefreshIsOn)
                                    .onChange(of: backgroundAppRefreshIsOn) { _ in
                                        isBGAppRefreshTaskSubmitted(withIdentifier: backgroundRefreshID1, whoCalledTheFunction: .settingsView) { isSubmitted in
                                            isTaskSubmitted = isSubmitted
                                        }
                                    }
                                if isTaskSubmitted {
                                    Text("  The app-refresh is already submitted:").frame(maxWidth: .infinity, alignment: .leading)
                                    Text("  EBD: \(formatTime_HH_mm_ss(earliestBeginDateRefresh ?? rodisBirthday))").foregroundColor(.gray).frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    
                                } else {
                                    Text("  The app-refresh is not submitted").frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                        }
                        
                        .onAppear {
                            isBGProcessingTaskSubmitted(withIdentifier: backgroundTaskID1, whoCalledTheFunction: .settingsView) { isSubmitted in
                                isTaskSubmitted = isSubmitted
                            }
                            isBGAppRefreshTaskSubmitted(withIdentifier: backgroundRefreshID1, whoCalledTheFunction: .settingsView) { isSubmitted in
                                isTaskSubmitted = isSubmitted
                            }
                        }
                        .onAppear {
                            returnEarliestBeginDate(identifier: backgroundTaskID1) { earliestBeginDate in
                                print("Earliest Begin Date: \(earliestBeginDate)")
                                // Do something with the earliestBeginDate, like update a @State variable
                                earliestBeginDateTask = earliestBeginDate
                            }
                            returnEarliestBeginDate(identifier: backgroundRefreshID1) { earliestBeginDate in
                                print("Earliest Begin Date: \(earliestBeginDate)")
                                // Do something with the earliestBeginDate, like update a @State variable
                                earliestBeginDateRefresh = earliestBeginDate
                            }                }
                        
                        
                    }
                }
            }
        }
        
    }
}




struct MainSwitchSettingsContentView: View {
    @AppStorage("demoMode")                     public var demoMode =                           false
    @AppStorage("announcementOn")               public var announcementOn =                     defaultShuggaIsOn
    
    @ObservedObject var bloodGlucoseData =  BloodGlucoseData.shared
    @State private var showDescription = false
    
    @AppStorage("showLockButton")                   public var showLockButton =                     false
    
    @Binding var theMainViewIsLocked: Bool
    @Binding var theShuggaIsPaused:   Bool

    var disableLock: Bool
    var unpauseLock: Bool
    
    @AppStorage("pauseNow")                   public var pauseNow =                     false

    @AppStorage("pauseForX_min")                   public var pauseForX_min =                     pauseShuggaDefault_min

    @AppStorage("as_pauseStartTime") public var as_pauseStartTime: Double = 0
    @AppStorage("as_pauseDuration") public var as_pauseDuration: TimeInterval = 0

    
    
    var body: some View {
        List {
            Toggle((announcementOn ? NSLocalizedString("Shugga is ON", comment: "Toggle label when Shugga is on") : NSLocalizedString("Shugga is OFF", comment: "Toggle label when Shugga is off")) + (demoMode ? NSLocalizedString(": (Demo Mode)", comment: "Demo mode indicator") : ""), isOn: $announcementOn)
                .textCase(.none)
                .accessibilityLabel(NSLocalizedString("Toggles between on and off.", comment: "Accessibility label for Shugga ME toggle"))
                .onChange(of: announcementOn) { sugahIsOn in
                    bloodGlucoseData.theTranslator.setSugahOnOrOff(sugahStatus: sugahIsOn)
                    
                    if !announcementOn {
                        
                        self.bloodGlucoseData.speech.stopSpeakingNow()
                    }
                }
            // ___________________________________ lock settings  ___________________________________
            Toggle("Lock settings access now", isOn: $showLockButton)
                .disabled(disableLock || pauseNow)
                .onChange(of: showLockButton) { showLockButton in
                    theMainViewIsLocked = showLockButton
                }
                .padding(.leading)
                .listRowSeparator(.hidden)

            // ___________________________________ Pause for ___________________________________
            
            
            
            if thisIsBeta {
                HStack{
                    Text (announcementOn ? (pauseNow ? "Paused for" : "Pause for" ): "Shugga paused by the main switch above")
                        .padding(.trailing, -20)
                    
                    
                    if !pauseNow {
                        
                        Picker(NSLocalizedString("", comment: ""), selection: $pauseForX_min)
                        {
                            ForEach(pauseInterval, id: \.self) { interval in
                                
                                if interval > 60 {
                                    Text("\(interval / 60) " + NSLocalizedString("hrs.", comment: "hrs. to pause"))
                                        .padding(.leading, -5)
                                    
                                        .lineLimit(1)
                                    
                                }
                                else {
                                    Text("\(interval) " + NSLocalizedString("min.", comment: "min to pause"))
                                    
                                        .padding(.leading, -5)
                                        .lineLimit(1)
                                }
                            }
                        }
                        .textCase(.none)
                        .pickerStyle(.menu)
                        .disabled(pauseNow)
                        .onChange(of: pauseForX_min) {  pauseInterval in
                            
                            bloodGlucoseData.remainingPauseTime = Double(pauseForX_min * SecondsIn.oneMinute.rawValue)
                        }
                        
                    } else
                    {
                        PauseTimerView()
                            .padding(.leading, 20)
                    }
                    
                    
                    Toggle("", isOn: $pauseNow)
                        .onChange(of: pauseNow) {  pauseNow in
                            theShuggaIsPaused = pauseNow
                            
                            
                            if pauseNow {
                                bloodGlucoseData.startPauseSugahTimer()
                                as_pauseDuration = 0
                                as_pauseStartTime = 0
                            }
                            else
                            {
                                bloodGlucoseData.stopPauseSugahTimer()
                                as_pauseDuration = 0
                                as_pauseStartTime = 0
                            }
                        }
                        .disabled(disableLock || !announcementOn)
                }
                .padding(.leading)
                
                
            }
            
        }
        .textCase(.none)
    }
}



struct MainSwitchSettingsView: View {
    
    @AppStorage("demoMode")                     public var demoMode =                           false
    @AppStorage("announcementOn")               public var announcementOn =                     defaultShuggaIsOn
    
    @ObservedObject var bloodGlucoseData =  BloodGlucoseData.shared
    @State private var showDescription = false
    
    @AppStorage("showLockButton")                   public var showLockButton =                     false
    
    @Binding var theMainViewIsLocked: Bool
    @Binding var theShuggaIsPaused: Bool
    
    var body: some View {
        
        Section(header:     HStack {
            //                                    Text("Shugga Me")
            //                                        .font(.headline)
            Spacer()
            HelpButton(showDescription: $showDescription, title: "Shugga Me")  {
                
                SpeechBubble {
                    VStack {
                        Form {
                            HStack {
                                Spacer()
                                
                                VStack {
                                    Image("logo 3")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .padding([.top, .leading, .trailing], 10)
                                        .accessibilityLabel(_: "This is the logo of this app. It' a red rounded rectangle with a white speech bubble inside with a tiny red blood droplet inside it. This takes you to the settings.")
                                    
                                    Text ("Shugga for Loop\n")
                                        .foregroundColor(logoTypeColor)
                                        .font(.system(size: 14, weight: .bold, design: .rounded))
                                        .accessibilityLabel(_: "\"S U G G A H\" is how we spell this app's name. This accessibility label reader says Shugga")
                                }.padding(.bottom)
                                    .background(Color.clear)
                                Spacer()
                            }
                            MainSwitchSettingsContentView(theMainViewIsLocked: $theMainViewIsLocked, theShuggaIsPaused: $theShuggaIsPaused, disableLock: true, unpauseLock: true)
                            // in the settings view users have access to these toggles
                        }
                    }
                    .background(Color.clear)
                }
                .padding(.top, 15)
                
                MainSwitchDescriptionView(announcementOn: $announcementOn)
            }
        }
            .font(.headline)
            .accessibilityLabel(NSLocalizedString("When this is turned on, the readout is turned on. If these accessibility label readouts are being cut off by the blood glucose readout, you can turn this off to explore the app first.", comment: "Accessibility label for Shugga ME toggle"))
                , footer:
                    VStack{
            if announcementOn {
                Text ("When this device is locked, Shugga will be silent. To ensure uninterrupted shugga, keep this device unlocked and ensure that this app stays in the foreground. Additionally, activate the \"Lock setting access\" while working out (eg: jogging with the phone in your pant pocket) to prevent unintentional changes to the settings.")
                    .foregroundColor(shuggaRed)
            }
        }
//                    Text(demoMode ? NSLocalizedString("The demo mode is turned on. Check the setting below.", comment: "Footer text for demo mode") : "")
            .font(.footnote)
            .font(.body )
        ) {
            MainSwitchSettingsContentView(theMainViewIsLocked: $theMainViewIsLocked, theShuggaIsPaused: $theShuggaIsPaused, disableLock: false, unpauseLock: false)
            // in the settings detailed help pop up view users don't  have access to these toggles
        }
    }
}







/*
 
 Image(systemName: "speaker.wave.2.circle.fill")
 .resizable()
 .frame(width: 40, height: 40)
 .scaledToFit()
 .foregroundColor(.green)
 .frame(maxWidth: .infinity)
 .scaleEffect(refreshIsPressed ? 1.4 : 1.0)
 .opacity(refreshIsPressed ? 0.6 : 1.0)
 
 
 
 .onTapGesture {
 bloodGlucoseData.thePlayer.speak(
 theSpeak : 0,
 sampleTime: Date(),
 includeUnit: includeUnit,
 userBloodGlucoseUnit: userBloodGlucoseUnit,
 speakElapsedTime : speakElapsedTime,
 elapsedTime: 1500,
 warnNoFreshData:
 warnNoFreshData,
 dataTooOldPeriod_min: dataTooOldPeriod_min,
 speechSpeed : threeSpeechSpeed,
 speechGender: speechGender,
 speechLanguage: sugahLanguageChosen,
 demoMode: true,
 skipHundredth: skipHundredth,
 recordingDevice: "demo device",
 mixToTelephone: mixToTelephone,
 usesApplicationAudioSession: usesApplicationAudioSession,
 voiceName: sugahVoiceChosen,
 voiceID: returnVoiceIDfromVoiceName(availableVoices: bloodGlucoseData.theAppVoices.availableVoices,
 voiceName: sugahVoiceChosen,
 voiceLocale: returnLocaleLanguageCodeFromCombinedCode(combinedCode: sugahLanguageCombinedCodeChosen)),
 combinedLanguageCode: sugahLanguageCombinedCodeChosen, speechVoiceVolume: voiceVolume, appScenePhase: bloodGlucoseData.appScenePhase, whoCalledTheFunction: .settingsView)
 }
 
 Text(NSLocalizedString("Play demo", comment: "Button label for playing a demo readout"))
 .frame(maxWidth: .infinity)
 .accessibilityLabel(NSLocalizedString("By pressing this button, you can listen to a sample readout.", comment: ""))
 */







struct DetailsSettingsView: View {
    
    @AppStorage("voiceVolume")                          public var voiceVolume: Double =                1.0
    @AppStorage("threeSpeechSpeed")                     public var threeSpeechSpeed =                   defaultThreeSpeechSpeed
    @AppStorage("speakInterval_seconds")                public var speakInterval_seconds:               Int =  defaultShuggaInterval // this is going to be
 
    @AppStorage("speakInterval_background_seconds")                public var speakInterval_background_seconds:               Int =  defaultShuggaInterval // this is going to be
    @AppStorage("shuggaInBackground")               public var shuggaInBackground =                 true

    @AppStorage("tellMeItsFromBackground")               public var tellMeItsFromBackground =                 true

    @State private var refreshIsPressed = false
    @ObservedObject var bloodGlucoseData =  BloodGlucoseData.shared
    @State private var showDescription = false
    
    var DetailedSettingsContentView: some View {
        List{
            VStack{
                // ___________________________________ Shugga every ___________________________________
                
                Picker(NSLocalizedString("Shugga", comment: "Picker label for selecting frequency of readout"), selection: $speakInterval_seconds)
                {
                    ForEach(announcementInterval, id: \.self) { interval in
                        if interval > SecondsIn.oneMinute.rawValue {
                            let minutes = Double(interval) / Double(SecondsIn.oneMinute.rawValue)
                            if minutes.truncatingRemainder(dividingBy: 1) == 0 {
                                // interval is a whole number of minutes
                                Text("every \(Int(minutes)) " + NSLocalizedString("minutes", comment: "Minutes unit for readout frequency"))
                            } else {
                                // interval is not a whole number of minutes
                                Text("every \(String(format: "%.1f ", minutes) + NSLocalizedString("minutes", comment: "Minutes unit for readout frequency"))")
                            }
                        } else {
                            Text("every \(interval) " + NSLocalizedString("seconds", comment: "Seconds unit for readout frequency"))
                        }
                    }

                }
                .textCase(.none)
                .pickerStyle(.menu)
                .onChange(of: speakInterval_seconds) {  newInterval in
                    let intervalInSeconds = Double(newInterval)
                    bloodGlucoseData.setMainSugarTimerInterval()
                }
            }
            
            
            
            VStack{
                Toggle("Shugga while in background", isOn: $shuggaInBackground)

                // ___________________________________ Background Shugga every ___________________________________
                
                Picker(NSLocalizedString("Max. background shugga frequency", comment: "Picker label for selecting maximum background frequency of readout"), selection: $speakInterval_background_seconds)
                {
                    ForEach(announcementInterval, id: \.self) { interval in
                        if interval > SecondsIn.oneMinute.rawValue {
                            let minutes = Double(interval) / Double(SecondsIn.oneMinute.rawValue)
                            if minutes.truncatingRemainder(dividingBy: 1) == 0 {
                                // interval is a whole number of minutes
                                Text("once every \(Int(minutes)) " + NSLocalizedString("minutes", comment: "Minutes unit for readout frequency"))
                            } else {
                                // interval is not a whole number of minutes
                                Text("once every \(String(format: "%.1f ", minutes) + NSLocalizedString("minutes", comment: "Minutes unit for readout frequency"))")
                            }
                        } else {
                            Text("once every \(interval) " + NSLocalizedString("seconds", comment: "Seconds unit for readout frequency"))
                        }
                    }

                }
                .padding (.leading)

                .textCase(.none)
                .pickerStyle(.menu)
                .disabled(!shuggaInBackground)
                .onChange(of: speakInterval_seconds) {  newInterval in
                    let intervalInSeconds = Double(newInterval)
                    bloodGlucoseData.setMainSugarTimerInterval()
                }
                
                
                Toggle("Add \"From the background...\"", isOn: $tellMeItsFromBackground)
                .disabled(!shuggaInBackground)
                .padding(.leading)
                .listRowSeparator(.hidden)
            }
          
            //___________________________________                   ___________________________________
            // ___________________________________  Shugga Volume   ___________________________________
            VStack{
                HStack {
                    Image(systemName: "speaker.wave.1.fill")
                        .font(.system(size: UIFont.labelFontSize))
                        .foregroundColor(.secondary)
                    Slider(value: $voiceVolume, in: 0...1)
                        .valueSlider(value: $voiceVolume)
                    Image(systemName: "speaker.wave.3.fill")
                        .font(.system(size: UIFont.labelFontSize))
                        .foregroundColor(.secondary)
                }
            }
            
            //___________________________________               ___________________________________
            // ___________________________________  Shugga Speed ___________________________________
            VStack {
                HStack {
//                    Text ("Speed")
                    Picker(NSLocalizedString("Three speeds",
                                             comment: "Label for speech speed picker"),
                           selection: $threeSpeechSpeed) {
                        ForEach(threeSpeeds, id: \.self) {
                            if $0 == "tortoise" {
                                Image(systemName: "tortoise.fill")
                            } else if $0 == "Normal" {
                                Text(NSLocalizedString("Normal", comment: "Normal speech speed"))
                            } else {
                                Image(systemName: "hare.fill")
                            }
                        }
                    }
                           .pickerStyle(SegmentedPickerStyle())
                           .onChange(of: threeSpeechSpeed) { sugahSpeed in
                               
                               switch sugahSpeed {
                                   
                               case "tortoise":
                                   bloodGlucoseData.theTranslator.setSugahSpeed(sugahSpeed:SugahSpeed.tortoise)
                                   print ("Shugga speed: tortoise(slow)")
                               case "Normal":
                                   bloodGlucoseData.theTranslator.setSugahSpeed(sugahSpeed:SugahSpeed.normal)
                                   print ("Shugga speed: normal(normal)")
                               case "hare":
                                   bloodGlucoseData.theTranslator.setSugahSpeed(sugahSpeed:SugahSpeed.hare)
                                   print ("Shugga speed: hare(fast)")
                               default:
                                   bloodGlucoseData.theTranslator.setSugahSpeed(sugahSpeed:SugahSpeed.normal)
                                   print ("Shugga speed: normal(default)")
                               }
                           }
                }
            }
            //___________________________________               ___________________________________
        }
    } //   ___________________________________ END OF: var DetailedSettingsContentView: some View {
    
    
    
    
    
    
    
    
    
    var body: some View {
        
        Section(header:
            HStack {
//                        Text("Shugga Details")
//                            .font(.headline)
            Spacer()
            HelpButton(showDescription: $showDescription, title: "Details") {
                
                SpeechBubble {
                    Form {
                        DetailedSettingsContentView
                    }
                }
                
                DetailedSettingsDescriptionView (voiceVolume: $voiceVolume, threeSpeechSpeed: $threeSpeechSpeed, speakInterval_seconds: $speakInterval_seconds)
            }
        }
    ){
            DetailedSettingsContentView
            
        }
    }
} // ___________________________________ END OF: struct DetailsSettingsView: View {










struct UnitSettingsContentView:  View {
    @ObservedObject var bloodGlucoseData =  BloodGlucoseData.shared
    @AppStorage("userBloodGlucoseUnit")             public var userBloodGlucoseUnit =               defaultBloodGlucoseUnit
    @AppStorage("shuggaGlucoseTrend")               public var shuggaGlucoseTrend =             false
    @AppStorage("multiplyTrendByTen")               public var multiplyTrendByTen =           false
    @AppStorage("includeUnit")                      public var includeUnit =                        true
    @AppStorage("removeTimeUnit")                   public var removeTimeUnit =                        false
    @AppStorage("displayBothUnits")                   public var displayBothUnits =                        false
    var body: some View {
        
        List{
            
            Picker(NSLocalizedString("Blood Glucose & Trend Unit", comment: ""), selection: $userBloodGlucoseUnit) {
                
                    ForEach(bloodGlucoseUnit, id: \.self) { unit in
                        
                        Text(unit)
                            .foregroundColor(.primary)
                        
                            .accessibilityLabel(NSLocalizedString("Toggles between milligrams per deciliter to millimoes per liter.", comment: "Toggles between milligrams per deciliter to millimoles per liter."))
                    }
                
            }
            
            .pickerStyle(SegmentedPickerStyle())
            .onChange(of: userBloodGlucoseUnit) { newUnit in
                
                if newUnit == BloodGlucoseUnit.milligramsPerDeciliter.rawValue {
                    
                    bloodGlucoseData.theTranslator.setCurrentUserBloodGlucoseUnit(theNewUnit: BloodGlucoseUnit.milligramsPerDeciliter)
                }
                
                if newUnit == BloodGlucoseUnit.millimolesPerLiter.rawValue {
                    
                    bloodGlucoseData.theTranslator.setCurrentUserBloodGlucoseUnit(theNewUnit: BloodGlucoseUnit.millimolesPerLiter)
                }
            }                        .textCase(.none)

            
            let includeUnitTextWithChosenUnit = "Shugga unit [\(userBloodGlucoseUnit == bloodGlucoseUnit[0] ? bloodGlucoseUnit[0] : bloodGlucoseUnit[1])]" + (shuggaGlucoseTrend ? " & [\(userBloodGlucoseUnit == bloodGlucoseUnit[0] ? bloodGlucoseUnit[0] : bloodGlucoseUnit[1])/\(multiplyTrendByTen ? "10 " : "")min]" : "")
                
                Toggle(includeUnitTextWithChosenUnit, isOn: $includeUnit)
                    .onChange(of: includeUnit) { speakUnit in
                        bloodGlucoseData.theTranslator.setSpeakUnit(speakUnit: speakUnit) }
                Toggle("Include trend when available", isOn: $shuggaGlucoseTrend)
                Toggle("Multiply trend rate by 10", isOn: $multiplyTrendByTen)
                    .disabled(!shuggaGlucoseTrend)
                    .padding (.leading)
                Toggle("Remove time unit", isOn: $removeTimeUnit)
                .disabled(!shuggaGlucoseTrend)
                .padding (.leading)

            Toggle("Display both units", isOn: $displayBothUnits)
            }  .textCase(.none)

        
    }
}



struct UnitSettingsView: View {
    
    @ObservedObject var bloodGlucoseData =  BloodGlucoseData.shared

    
    @AppStorage("userBloodGlucoseUnit")             public var userBloodGlucoseUnit =               defaultBloodGlucoseUnit
    @AppStorage("shuggaGlucoseTrend")               public var shuggaGlucoseTrend =           false
    @AppStorage("multiplyTrendByTen")               public var multiplyTrendByTen =           false
    @AppStorage("includeUnit")                      public var includeUnit =                        true
    @AppStorage("removeTimeUnit")                   public var removeTimeUnit =                        false

    @State private var showDescription = false

    var body: some View {
        
        Section(header:
                    HStack {
//                        Text("Blood Glucose & Trend Units")
//                            .font(.headline)
            Spacer()
                        HelpButton(showDescription: $showDescription, title: "Blood Glucose & Trend Units")  {
                            VStack(alignment: .leading) {
                                    SpeechBubble {
                                        Form {

                                        UnitSettingsContentView()
                                    }
                                }
                                UnitSettingsDescriptionView(userBloodGlucoseUnit: $userBloodGlucoseUnit, shuggaGlucoseTrend: $shuggaGlucoseTrend, multiplyTrendByTen: $multiplyTrendByTen, includeUnit: $includeUnit)
                            }
                        }
                    }
                
            .accessibilityLabel(NSLocalizedString("Blood Glucose Unit. This sets the blood glucose unit. Milligrams per deciliter or millimoles per liter", comment: ""))
                
            .font(.headline)
                //.fontWeight(.regular)
                , footer:
                    Text("Shugga sample: “\(shuggaGlucoseTrend ? "One minute ago," : "") \(userBloodGlucoseUnit == BloodGlucoseUnit.milligramsPerDeciliter.rawValue ? "98" : "")\(userBloodGlucoseUnit == BloodGlucoseUnit.millimolesPerLiter.rawValue ? "5.4" : "")\(userBloodGlucoseUnit == BloodGlucoseUnit.milligramsPerDeciliter.rawValue && includeUnit ? " mg/dL" : "")\(userBloodGlucoseUnit == BloodGlucoseUnit.millimolesPerLiter.rawValue && includeUnit ? " mmol/L" : "")\(shuggaGlucoseTrend ? ", down 1" : "")\(multiplyTrendByTen && shuggaGlucoseTrend ? "0" : "") \(userBloodGlucoseUnit == BloodGlucoseUnit.milligramsPerDeciliter.rawValue && includeUnit && shuggaGlucoseTrend ? " mg/dL" : "")\(userBloodGlucoseUnit == BloodGlucoseUnit.millimolesPerLiter.rawValue && includeUnit && shuggaGlucoseTrend ? " mmol/L" : "")\(multiplyTrendByTen && shuggaGlucoseTrend && !removeTimeUnit ? " per ten minutes." : "")\(!multiplyTrendByTen && shuggaGlucoseTrend && !removeTimeUnit ? " per one minute." : "")\"")
        ) { UnitSettingsContentView() }
    }
}















struct ReminderSettingsContentView:  View {
    @ObservedObject var bloodGlucoseData =  BloodGlucoseData.shared
    
    @AppStorage("reminderIsOn")                    public var reminderIsOn =  defaultReminderIsOn
    
    @AppStorage("reminderAfterFood_05Min")         public var reminderAfterFood_05Min =  false // for testing purpose

    @AppStorage("reminderAfterFood_30Min")         public var reminderAfterFood_30Min =  false
    @AppStorage("reminderAfterFood_60Min")         public var reminderAfterFood_60Min =  false
    @AppStorage("reminderAfterFood_90Min")         public var reminderAfterFood_90Min =  true
    @AppStorage("reminderAfterFood_120Min")        public var reminderAfterFood_120Min = false
    @AppStorage("reminderAfterFood_150Min")        public var reminderAfterFood_150Min = false
    @AppStorage("reminderAfterFood_180Min")        public var reminderAfterFood_180Min = false
    @AppStorage("reminderAfterFood_210Min")        public var reminderAfterFood_210Min = false
    @AppStorage("reminderAfterFood_240Min")        public var reminderAfterFood_240Min = false
    
    @Binding public var showDescription: Bool
    @Binding public var showReminders : Bool
    
    var body: some View {
            VStack{
                Toggle(NSLocalizedString(reminderIsOn ? "Carb Reminders is ON after" : "Carb Reminders is OFF", comment: ""), isOn: $reminderIsOn)
                    .onChange(of: reminderIsOn) { _ in
                        withAnimation(.easeInOut(duration: 0.8)) {
                            showReminders = reminderIsOn
                        }
                    }
            }
            .textCase(.none)
                if reminderIsOn {

                    List{
                        if thisIsBeta {
                            VStack {
                                Text ("1 min is for testing purpose only")
                                Toggle(NSLocalizedString("1 min.", comment: ""),      isOn: $reminderAfterFood_05Min)
                            }
                        }
                        Toggle(NSLocalizedString("30 min.",     comment: ""),       isOn: $reminderAfterFood_30Min)
                        Toggle(NSLocalizedString("60 min.",     comment: ""),       isOn: $reminderAfterFood_60Min)
                        Toggle(NSLocalizedString("90 min.",     comment: ""),       isOn: $reminderAfterFood_90Min)
                        Toggle(NSLocalizedString("2 hours.",    comment: ""),       isOn: $reminderAfterFood_120Min)
                        Toggle(NSLocalizedString("2.5 hours.",  comment: ""),       isOn: $reminderAfterFood_150Min)
                        Toggle(NSLocalizedString("3 hours.",    comment: ""),       isOn: $reminderAfterFood_180Min)
                        Toggle(NSLocalizedString("3.5 hours.",  comment: ""),       isOn: $reminderAfterFood_210Min)
                        Toggle(NSLocalizedString("4 hours.",    comment: ""),       isOn: $reminderAfterFood_240Min)
                    }
                    .padding(.leading)
                        .transition(.move(edge: .top))
                    
                }
            
        
    }
}



struct ReminderSettingsView: View {
    @AppStorage("reminderIsOn")                    public var reminderIsOn =  defaultReminderIsOn
    
    @AppStorage("reminderAfterFood_05Min")         public var reminderAfterFood_05Min =  false // for testing purpose

    @AppStorage("reminderAfterFood_30Min")         public var reminderAfterFood_30Min =  false
    @AppStorage("reminderAfterFood_60Min")         public var reminderAfterFood_60Min =  false
    @AppStorage("reminderAfterFood_90Min")         public var reminderAfterFood_90Min =  true
    @AppStorage("reminderAfterFood_120Min")        public var reminderAfterFood_120Min = false
    @AppStorage("reminderAfterFood_150Min")        public var reminderAfterFood_150Min = false
    @AppStorage("reminderAfterFood_180Min")        public var reminderAfterFood_180Min = false
    @AppStorage("reminderAfterFood_210Min")        public var reminderAfterFood_210Min = false
    @AppStorage("reminderAfterFood_240Min")        public var reminderAfterFood_240Min = false

    @State private var showDescription = false
    @State private var showReminders = false

    var body: some View {
           
        
           Section(header:
                       HStack {
//                           Text("Post carb reminders")
//                               .font(.headline)
               Spacer()
                           HelpButton(showDescription: $showDescription, title: "Blood Glucose Check Reminders")  {
                               VStack(alignment: .leading) {
                                       SpeechBubble{
                                           Form {

                                       ReminderSettingsContentView(showDescription: $showDescription, showReminders: $showReminders)
                                   }
                                   }
                                   RemindersDescriptionView(reminderIsOn: $reminderIsOn, reminderAfterFood_30Min: $reminderAfterFood_30Min, reminderAfterFood_60Min: $reminderAfterFood_60Min, reminderAfterFood_90Min: $reminderAfterFood_90Min, reminderAfterFood_120Min: $reminderAfterFood_120Min, reminderAfterFood_150Min: $reminderAfterFood_150Min, reminderAfterFood_180Min: $reminderAfterFood_180Min, reminderAfterFood_210Min: $reminderAfterFood_210Min, reminderAfterFood_240Min: $reminderAfterFood_240Min)
                               }
                           }
                       }
               .accessibilityLabel(NSLocalizedString("Blood Glucose Unit. This sets the blood glucose unit. Milligrams per deciliter or millimoles per liter", comment: ""))
               .font(.headline)
               .accessibilityLabel(NSLocalizedString("In the USA and Japan, it is milligrams per deciliter.", comment: ""))
                   //.fontWeight(.regular)
                   
           ){
//               Text ("Time restricted feeding: 8 hours (future option)")
               ReminderSettingsContentView(showDescription: $showDescription, showReminders: $showReminders)
        }
    }
}




struct AncillaryDataSettingsContentView:  View {
    @ObservedObject var bloodGlucoseData =  BloodGlucoseData.shared
    
    @AppStorage("ancillaryDataOn")                      public var ancillaryDataOn =  true
    
    @AppStorage("showShuggaStatus")                     public var showShuggaStatus =  true
    @AppStorage("showCGM_info")                         public var showCGM_info =  false

    @AppStorage("showCarbHistory")                      public var showCarbHistory =  false
    
    
    @Binding public var showDescription: Bool
    @Binding public var showAncillary: Bool
    
    var body: some View {
        
        List{
            Toggle(NSLocalizedString(ancillaryDataOn ? "Ancillary Data is showing" : "Ancillary Data is hidden", comment: ""), isOn: $ancillaryDataOn)
                .onChange(of: ancillaryDataOn) { _ in
                    withAnimation(.easeInOut(duration: 0.15)) {
                                        showAncillary = ancillaryDataOn
                                    }
                                }
                if ancillaryDataOn {
                 
                 List {
                     Toggle(NSLocalizedString("Status", comment: ""),       isOn: $showShuggaStatus)
                     Toggle(NSLocalizedString("Carb History", comment: ""), isOn: $showCarbHistory)
                     Toggle(NSLocalizedString("CGM Info", comment: ""),             isOn: $showCGM_info)
                 }.padding(.leading)
                 .transition(.move(edge: .top))
             }
        }
        .textCase(.none)
    }
}



struct AncillaryDataSettingsView: View {
    @AppStorage("ancillaryDataOn")                      public var ancillaryDataOn =  true
    @AppStorage("showShuggaStatus")                     public var showShuggaStatus =  true
    @AppStorage("showCGM_info")                         public var showCGM_info =  false

    @AppStorage("showCarbHistory")                      public var showCarbHistory =  false

    @State private var showDescription = false
    @State private var showAncillary = false

    var body: some View {
           
           Section(header:
                       HStack {
//                           Text("Ancillary Data")
//                               .font(.headline)
               Spacer()
                           HelpButton(showDescription: $showDescription, title: "Ancillary Data")  {
                               VStack(alignment: .leading) {
                                       SpeechBubble{
                                           Form { AncillaryDataSettingsContentView(showDescription: $showDescription, showAncillary: $ancillaryDataOn) }
                                   }
                                   AncillaryDataViewSettingsDescriptionView(ancillaryDataOn: $ancillaryDataOn, showShuggaStatus: $showShuggaStatus, showCGM_info: $showCGM_info, showCarbHistory: $showCarbHistory)
                               }
                           }
                       }
               .accessibilityLabel(NSLocalizedString("", comment: ""))
               .font(.headline)
               .accessibilityLabel(NSLocalizedString("", comment: ""))
                   //.fontWeight(.regular)
                   
           ){
                              
               AncillaryDataSettingsContentView(showDescription: $showDescription, showAncillary: $ancillaryDataOn)
        }
    }
}


struct WarningSettingsContentView:  View {
    @ObservedObject var bloodGlucoseData =  BloodGlucoseData.shared

    @Binding var dataTooOldPeriod_min: Int
    @Binding var warnNoFreshData: Bool
    
    var body: some View {
                
        List {
                     Toggle(NSLocalizedString("Warn when data is too old", comment: ""), isOn: $warnNoFreshData)
                         .onChange(of: warnNoFreshData) { newPeriod in
                             bloodGlucoseData.theTranslator.setCurrentWarnNoFreshData(warnNoFreshData: warnNoFreshData)
                         }
                     
                     Picker(NSLocalizedString("", comment: ""), selection: $dataTooOldPeriod_min)
                     {
                         ForEach(dataTooOldPeriod, id: \.self) {
                             Text(String(format: NSLocalizedString("After %d minutes", comment: ""), $0)).tag($0)
                         }
                     }
                     .pickerStyle(.menu)
                     .disabled(!warnNoFreshData)
                     .onChange(of: dataTooOldPeriod_min) { newPeriod in
                         bloodGlucoseData.theTranslator.setCurrentDataTooOldPeriod_min(dataTooOldPeriod_min: dataTooOldPeriod_min)
                     }
                }
                .textCase(.none)
//                .padding()
                .transition(.move(edge: .top))
        }
    }
    




struct WarningSettingsView: View {
    
    @AppStorage("$dataTooOldPeriod_min")        public var dataTooOldPeriod_min =               dateTooOldPeriod_min_default
    @AppStorage("warnNoFreshData")              public var warnNoFreshData =                    false
    
    @ObservedObject var bloodGlucoseData =  BloodGlucoseData.shared
    @State private var showDescription = false

    var body: some View {
        
            Section(header:
                
                HStack {
//                    Text("No Fresh Blood Glucose Data")
//                        .font(.headline)
                Spacer()
                    HelpButton(showDescription: $showDescription, title: "No Fresh Blood Glucose Data")  {
                        VStack(alignment: .leading) {
                            SpeechBubble {
                                Form { WarningSettingsContentView(dataTooOldPeriod_min: $dataTooOldPeriod_min, warnNoFreshData: $warnNoFreshData) }
                            }
                            Text("No Fresh Blood Glucose Data: If your CGM samples every 5 minutes, set this time sometime after that. This then will warn you if the latest available blood glucose data in Health is older than that, the app will try to Shugga you as such. The default value is \(dateTooOldPeriod_min_default) minutes")
                                .textCase(.none)
                            Spacer()
                        }
                    }
                }

            .accessibilityLabel(NSLocalizedString("This sets how many minutes Shugga waits until it warns that the latest available blood glucose unit is out of date.", comment: ""))
            .font(.headline)
                //                            .foregroundColor(.orange)
                , footer: Text(String(format: NSLocalizedString("Shugga will wait %d minutes and 30 seconds", comment: ""), dataTooOldPeriod_min))
        ) {
            WarningSettingsContentView(dataTooOldPeriod_min: $dataTooOldPeriod_min, warnNoFreshData: $warnNoFreshData)
        }
    }
}













struct NitPickySettingsContentView: View {
    
    @ObservedObject var bloodGlucoseData =  BloodGlucoseData.shared

    @AppStorage("speakElapsedTime")                 public var speakElapsedTime =                   true
    @AppStorage("skipHundredth")                    public var skipHundredth =                      false
    @AppStorage("usesApplicationAudioSession")      public var usesApplicationAudioSession =        false
    @AppStorage("userBloodGlucoseUnit")             public var userBloodGlucoseUnit =               defaultBloodGlucoseUnit
    @AppStorage("doubleTapForSugah")                public var doubleTapForSugah =                  false
    @AppStorage("whiteBackground")                  public var whiteBackground =                    false //nov 1 2022 0:00:00
    @AppStorage("mainBloodGlucoseDisplayFontSize")  public var mainBloodGlucoseDisplayFontSize =    200
    @AppStorage("grayAppIcon")                      public var grayAppIcon =                        false
    @AppStorage("shuggaInBackground")               public var shuggaInBackground =                 true
    @AppStorage("tellMeItsFromBackground")               public var tellMeItsFromBackground =                 true

    @AppStorage("shuggaGlucoseTrend")               public var shuggaGlucoseTrend =                 true
    @AppStorage("showAncillaryData")                public var showAncillaryData =                  true
    @AppStorage("showLockButton")                   public var showLockButton =                     false
    @AppStorage("shuggaRepeats")                    public var shuggaRepeats =                     defaultShuggaRepeats


    var body: some View {
        
        List {
            
            Toggle(NSLocalizedString("Shugga twice in a row", comment: ""), isOn: $shuggaRepeats)
                .disabled((false))
            
            Toggle(NSLocalizedString("Only when blood glucose is out of range", comment: ""), isOn: $shuggaRepeats)
                .disabled((true))
                .padding (.leading)


            Toggle(NSLocalizedString("Shugga \"time elapsed\" when in foreground", comment: ""), isOn: $speakElapsedTime)
                    .onChange(of: speakElapsedTime) { speakElapsedTime in
                        bloodGlucoseData.theTranslator.setAnnounceElapsedTime(announceElapsedTime: speakElapsedTime) }
                
                Toggle("\"Skip hundred\"\(LanguageNamesInEnglish.english.rawValue == bloodGlucoseData.theTranslator.currentLanguageName ? "" : " only works with English voices")", isOn: $skipHundredth)
                    .disabled((LanguageNamesInEnglish.english.rawValue == bloodGlucoseData.theTranslator.currentLanguageName) ? false : true)
                    .onChange(of: skipHundredth) { skipHundredthBool in
                        bloodGlucoseData.theTranslator.setSkipHundredths(skipHundredth: skipHundredthBool) }
                
                Toggle(NSLocalizedString("Double tap the main blood glucose value or app logo above for Shugga", comment: ""), isOn: $doubleTapForSugah)
                    .onChange(of: doubleTapForSugah) { doubleTapForSugah in
                        bloodGlucoseData.theTranslator.setAnnounceWithDoubleTap(doubleTapForSugah: doubleTapForSugah) }
                
                Toggle(NSLocalizedString("Flat Background", comment: ""), isOn: $whiteBackground)
                    .disabled(false)
                    .onChange(of: whiteBackground) { whiteBackground in
                        bloodGlucoseData.theTranslator.setWhiteBackground(whiteBackground: whiteBackground)}
                
                Picker(NSLocalizedString("Glucose value font size", comment: ""), selection: $mainBloodGlucoseDisplayFontSize) {
                    ForEach(mainBloodGlucoseDisplayFontSizeChoices, id: \.self) {
                        Text("\($0)")
                    } }   .pickerStyle(.menu)
                    .accessibilityLabel(_: "This is the size of the font for the main blood glucose value. The default is 200.")
                    .onChange(of: mainBloodGlucoseDisplayFontSize) { mainBloodGlucoseDisplayFontSize in
                        
                        bloodGlucoseData.theTranslator.setMainBGDisplayFontSize(mainBGDisplayFontSize: mainBloodGlucoseDisplayFontSize) }
                
                Toggle(NSLocalizedString("Gray app icon", comment: ""), isOn: $grayAppIcon)
                    .onChange(of: grayAppIcon) { grayAppIcon in
                    bloodGlucoseData.theTranslator.setToGrayAppIcon(isSetToGrayAppIcon: grayAppIcon)}
            

             

            
            
            /*
                let otherAudioStops =      NSLocalizedString("Other audio: Shugga stops", comment: "")
                let otherAudioPlaysOver =  NSLocalizedString("Other audio: Shugga plays over", comment: "")
                
                Toggle(usesApplicationAudioSession ? otherAudioStops : otherAudioPlaysOver, isOn: $usesApplicationAudioSession)
                    .disabled(true)
                    .accessibilityLabel(_: usesApplicationAudioSession ? NSLocalizedString("If other app is playing audio, Shugga will stop the other audio playback.", comment: "") : NSLocalizedString("If other app is playing audio, Shugga will lower the volume of the other audio and will play over the other audio playback.", comment: ""))
                    .onChange(of: usesApplicationAudioSession) { usesAppAudioSession in
                        bloodGlucoseData.theTranslator.setUsesAppAudioSession(usesAppAudioSession: usesAppAudioSession)}
            
            */
            
            
        }            .textCase(.none)

    }
    
    
}






struct NitPickSettingsView: View {
    @ObservedObject var bloodGlucoseData =  BloodGlucoseData.shared

    @AppStorage("skipHundredth")                    public var skipHundredth =                      false
    @AppStorage("usesApplicationAudioSession")      public var usesApplicationAudioSession =        false
    @AppStorage("userBloodGlucoseUnit")             public var userBloodGlucoseUnit =               defaultBloodGlucoseUnit
    @AppStorage("speakElapsedTime")                 public var speakElapsedTime =                   true
    @AppStorage("doubleTapForSugah")                public var doubleTapForSugah =                  false
    @AppStorage("whiteBackground")                  public var whiteBackground =                    false //nov 1 2022 0:00:00
    @AppStorage("mainBloodGlucoseDisplayFontSize")  public var mainBloodGlucoseDisplayFontSize =    200
    @AppStorage("grayAppIcon")                      public var grayAppIcon =                        false
    @AppStorage("shuggaInBackground")               public var shuggaInBackground =                 true
    @AppStorage("shuggaGlucoseTrend")               public var shuggaGlucoseTrend =                 true

    @AppStorage("shuggaRepeats")                    public var shuggaRepeats =                     defaultShuggaRepeats


    
    @State private var showDescription = false

    var body: some View {
        
        
        Section(header:
                                                HStack {
                                                    Text("Fussy Details")
                                                        .font(.headline)
            Spacer()
                                                    HelpButton(showDescription: $showDescription, title: "Fussy Details")  {
                                                        VStack(alignment: .leading) {
                                                                SpeechBubble{
                                                                    Form {

                                                                NitPickySettingsContentView()
                                                            }
                                                            }
                                                            NitPickyDescriptionView(skipHundredth: $skipHundredth, usesApplicationAudioSession: $usesApplicationAudioSession, userBloodGlucoseUnit: $userBloodGlucoseUnit, speakElapsedTime: $speakElapsedTime, doubleTapForSugah: $doubleTapForSugah, whiteBackground: $whiteBackground, mainBloodGlucoseDisplayFontSize: $mainBloodGlucoseDisplayFontSize, grayAppIcon: $grayAppIcon, shuggaInBackground: $shuggaInBackground, shuggaGlucoseTrend: $shuggaGlucoseTrend)
                                                        }
                                                    }
                                                }
            .font(.headline)
//                ,
//                footer: Text(
//                    (skipHundredth ? NSLocalizedString("\"Skip hundred\": When in English, readout omits \"hundred\" from \"one hundred thirty four.\"", comment: "") : "") + (usesApplicationAudioSession ?  NSLocalizedString("\nOther audio: Shugga will stop the other audio and the other audio will not resume. \n🐞 After changing the voice, the very first double tap may not work until the new voice is loaded to the app.", comment: "") :  NSLocalizedString("\nOther audio: Shugga will play over the other apps' audio playback. \n🐞 After changing the voice, the very first double tap may not work until the new voice is loaded to the app.", comment: ""))).font(.footnote)
        )
        { NitPickySettingsContentView() }
    }
}



struct DemoSettingsView: View {
    
    @AppStorage("demoMode")                     public var demoMode =                           false
    
    @ObservedObject var bloodGlucoseData =  BloodGlucoseData.shared
    @State private var showDescription = false
    
    var body: some View {
        
        
        let demoText1 = NSLocalizedString("This device does not have HealthKit. This app can only be used in demo mode", comment: "")
        let demoText2 = NSLocalizedString("Demo mode can be used to try this app when no blood glucose data is available on this device", comment: "")
        
        Section(header:
                    HStack {
//                                Text("Demo Setting")
//                                    .font(.headline)
                                Spacer()
                                HelpButton(showDescription: $showDescription, title: "Demo Setting")  {
                                    VStack(alignment: .leading) {
                                                                    Text("Help on Demo Setting")
                                                                    .textCase(.none)
                                        }
                                    }
                            }
                            .font(.headline)
                , footer: Text(demoMode ? (bloodGlucoseData.theHealthKitIsAvailableOnThisDevice ? "" :  demoText1) : demoText2)
            .font(.footnote)
        ) {
            
            Toggle(NSLocalizedString("Demo mode", comment: ""), isOn: $demoMode)
            //                                .font(.headline)
            //                .disabled(!theHealthKitIsAvailableOnThisDevice)
                .disabled(true)
                .onChange(of: demoMode) { demoMode in
                    
                    bloodGlucoseData.theTranslator.setDemoMode(thisThisDemo: demoMode)
                    
                }
        }
        
        
    }
    
    
}

struct VoiceSettingsContentView:  View {
    @ObservedObject var bloodGlucoseData =  BloodGlucoseData.shared

    
    var body: some View {
                
        VStack{
            
            Text ("Choose your language and available voice.")
        }
        }
    }
struct VoiceSettingsView: View {
    
    @AppStorage("sugahLanguageChosen")     public var sugahLanguageChosen =         defaultSugahLanguage
    @AppStorage("sugahVoiceChosen")     public var sugahVoiceChosen =               defaultSugahVoice
    @AppStorage("sugahLanguageCombinedCodeChosen")
    public var sugahLanguageCombinedCodeChosen =         "en-US"
    
    @ObservedObject var bloodGlucoseData =  BloodGlucoseData.shared
    
    var thisVoiceIsProblematic = false
    
    let voiceNames: [String] = GetVoices()
    @State private var showDescription = false

    var body: some View {
        
        if true {
            
            Section(header:
                        HStack {
                            Text("Voice & Language Settings")
                                .font(.headline)
                Spacer()
                            HelpButton(showDescription: $showDescription, title: "Voice & Language Setting")  {
                                VStack(alignment: .leading) {
//                                    SpeechBubble {
//                                        Form { VoiceSettingsContentView() }
//                                    }
                                    Text("Choose your language and available voice.")
                                        .textCase(.none)
                                }
                            }
                        }

                .font(.headline)
                    //                            .foregroundColor(.orange)
                    , footer: Text(" ").font(.footnote)
                    
            ) {
                //                                VStack(spacing: 0) {
                ////
                ////                                    Text (sugahLanguageChosen)
                ////                                    Text (sugahLanguageCombinedCodeChosen)
                ////                                    Text (sugahVoiceChosen)
                //                                }
                Picker(selection: $sugahLanguageChosen,
                       label: Text(NSLocalizedString("Language", comment: "")),
                       content: { ForEach (languageCodeCurrentlyAvailable, id: \.self) {
                    let thisLanguageNamePair = languageNamePairs[$0]
                    Text(thisLanguageNamePair!.nativeName).tag(thisLanguageNamePair!.englishName)
                }
                }).onChange(of: sugahLanguageChosen) { selectedLanguage in
                    // Update sugahVoiceChosen to the first available option in the second picker
                    // You can do this by finding the first voice that has a matching language code and setting sugahVoiceChosen to its voice name
                    
                    bloodGlucoseData.theTranslator.setCurrentLanguageName(currentLanguageName: selectedLanguage) // english Name "German"
                    
                    let selectedLanguageCode = returnLanguageCodeFromEnglishName(englishName: selectedLanguage) // "en"
                    
                    let firstVoiceForSelectedLanguage = bloodGlucoseData.theAppVoices.availableVoices.first(where: { thisCheck in
                        selectedLanguageCode ==  thisCheck.languageCode
                    })
                    
                    print (firstVoiceForSelectedLanguage?.voiceName ?? "error") // Optional("Shelley")
                    
                    let theNameAndCodeMatchingVoice = bloodGlucoseData.theAppVoices.availableVoices.first(where: { thisCheck in
                        (selectedLanguageCode ==  thisCheck.languageCode && firstVoiceForSelectedLanguage!.voiceName == thisCheck.voiceName)
                    })
                    
                    bloodGlucoseData.theTranslator.currentLanguageCodeCombined = theNameAndCodeMatchingVoice?.combinedCode ?? defaultSugahLanguageCombinedCode
                    
                    sugahLanguageCombinedCodeChosen = theNameAndCodeMatchingVoice?.combinedCode ?? defaultSugahLanguageCombinedCode
                    
                    sugahVoiceChosen = "\(returnLocaleCodeFromCombinedLanguageCode(combinedLanguageCode: firstVoiceForSelectedLanguage?.combinedCode ?? defaultSugahVoiceName)    )\(firstVoiceForSelectedLanguage?.voiceName ?? defaultSugahVoiceName)"
                }
            
                //  ======================== Second picker to select the voice ========================================================
                Picker(selection: $sugahVoiceChosen, label: Text(NSLocalizedString("Voice", comment: "")), content: {
                    
                    ForEach(bloodGlucoseData.theAppVoices.availableVoices, id: \.self) { voice in
                        // Use the properties of the `voice` object in your view
                        let thisLanguageCode = returnLanguageCodeFromCombinedCode(combinedCode: voice.languageCode) //es
                        let thisLanguageNamePair = languageNamePairs[thisLanguageCode]
                        
                        // Only display voices that match the selected language
                        if sugahLanguageChosen == thisLanguageNamePair?.englishName {
                            
                            if !knownProblemVoices.contains(voice.voiceName){
                                if thisIsBeta {
                                    
                                    Text("\(voice.voiceName) (\(voice.languageLocaleCode))\(quarantinedVoices.contains(voice.voiceName)  ? "*" : "")").textCase(.none).tag(voice.languageLocaleCode + voice.voiceName)
                                    
                                }
                                else if !quarantinedVoices.contains(voice.voiceName)
                                    
                                {
                                    
                                    Text("\(voice.voiceName) (\(voice.languageLocaleCode))").textCase(.none).tag(voice.languageLocaleCode + voice.voiceName)
                                }
                            }
                            
                        }
                        
                        
                    }
                })
               
                .onChange(of: sugahVoiceChosen) { selectedLanguage in
                    
                    let sugahVoiceLocal = sugahVoiceChosen.prefix(2)
                    let justVoiceNameChosen = sugahVoiceChosen.dropFirst(2)
                    let languageCode = returnLanguageCodeFromEnglishName(englishName: sugahLanguageChosen)
                    
                    sugahLanguageCombinedCodeChosen = "\(languageCode)-\(sugahVoiceLocal)"
                    
                    bloodGlucoseData.theTranslator.setCurrentVoiceName(currentVoiceName: sugahVoiceChosen)
                    
                    let theNameAndCodeMatchingVoice = bloodGlucoseData.theAppVoices.availableVoices.first(where: { thisCheck in
                        (languageCode ==  thisCheck.languageCode && sugahVoiceChosen.dropFirst(2) == thisCheck.voiceName)
                    })
                    //
                    print ("ssssssss theNameAndCodeMatchingVoice: \(String(describing: theNameAndCodeMatchingVoice?.combinedCode))")
                    //                                    sugahLanguageCombinedCodeChosen = theNameAndCodeMatchingVoice?.combinedCode ?? defaultSugahLanguageCombinedCode
                    
                    Text (sugahLanguageCombinedCodeChosen)
                }
                //  Text("sugahVoiceChosen: \(sugahVoiceChosen)")
            }
        } //thisIsBeta
    }
}

struct ExperimentSettingsView: View {
    
    @AppStorage ("dummyUnimplementedExperimentalVariable") public var dummyUnimplementedExperimentalVariable = false
    
    @AppStorage("mixToTelephone")                   public var mixToTelephone =                     false
    @AppStorage("syncWithCGM")                      public var syncWithCGM =                        false
    @AppStorage("keepsWorkingInBackground")         public var keepsWorkingInBackground =           false
    @AppStorage("backgroundHaptics")                public var backgroundHaptics =                  false
    @AppStorage("ignoreDarkMode")                   public var ignoreDarkMode =                     false
    @AppStorage("castForValueAlarmIsOn")            public var castForValueAlarmIsOn =              false
    @AppStorage("castAlarmInterval_minutes")        public var castAlarmInterval_minutes: Int =     30 // this is going to be multiples of 10 seconds
    @AppStorage("includeBloodGlucoseTrend")         public var includeBloodGlucoseTrend =           false
    
    @AppStorage("outputSelectionOption")            public var outputSelectionOption =              outputOptionsDefault
   
    @AppStorage("turnOffDuringPhoneCalls")          public var turnOffDuringPhoneCalls =                     false

    
    @AppStorage("showLockButton")                   public var showLockButton =                     false

    @Binding var theMainViewIsLocked: Bool

    @State private var showDescription = false

    
    @ObservedObject var bloodGlucoseData =  BloodGlucoseData.shared
    
    var body: some View {
        
        
        if thisIsBeta {
            
            Section(header:
                        HStack {
                            Text("Experimental Settings")
                                .font(.headline)
                Spacer()
                            HelpButton(showDescription: $showDescription, title: "Experimental Settings")  {
                                VStack(alignment: .leading) {
                                    Text("Help on Experimental Setting")
                                        .textCase(.none)
                                }
                            }
                        }

                .font(.headline).foregroundColor(.orange)
                    , footer: Text("⚠️Not all experimental settings may be available." + (mixToTelephone ? "\n🔊The person you are talking to on the phone will hear Shugga readout (you do not hear Shugga)" : "\n🔊The person you are talking to on the phone will NOT hear Shugga readout") )) {
  
               
                
//                
//                Toggle("Sync Shugga with new CGM entries", isOn: $syncWithCGM)
//                    .disabled(true)
                
                Toggle("Shugga while on phone call is turned \(turnOffDuringPhoneCalls ? "on" : "off")", isOn: $turnOffDuringPhoneCalls)
                    .disabled(true)

                Toggle("Background haptic is \(backgroundHaptics ? "on" : "off")", isOn: $backgroundHaptics)
                    .disabled(true)
                //
                //                            Toggle( (userBloodGlucoseUnit == BloodGlucoseUnit.milligramsPerDeciliter.rawValue) ? "Blood glucose displayed on app icon badge" : "Blood glucose cannot be displayed when in mmol/L", isOn: $showGlucoseInIconBadge)
                //                                .disabled(userBloodGlucoseUnit == BloodGlucoseUnit.millimolesPerLiter.rawValue ? true : false)
                //                                .accessibilityLabel(_: "Milligrams per deciliter or millimols per liter.")
                
                
                Toggle("Telephone pass-through ", isOn: $mixToTelephone)
                    .disabled(false)
                    .onChange(of: mixToTelephone) { mixToPhone in
                        bloodGlucoseData.theTranslator.setMixToPhone(mixToPhone: mixToPhone) }
                
                
//                Toggle("Ignore Dark Mode", isOn: $ignoreDarkMode)
//                    .disabled(true)

                
                
                VStack {
                    
                    Toggle("Automatic sleep detection: ", isOn: $dummyUnimplementedExperimentalVariable)
                    Text ("HKCategoryTypeIdentifier.sleepAnalysis")
                    Text ("Automagical volume reduction before going to sleep")
                    // .disabled(true)

                    Toggle("Speak when coming to foreground", isOn: $dummyUnimplementedExperimentalVariable)
                    
                    Text("Shugga shuggas if the last blood glucose entry is older than the shugga interval you set.")
                    
                    
                }
                
                Picker("Select output", selection: $outputSelectionOption) {
                    ForEach(outputOptions, id: \.self) { option in
                        Text(option)
                    }
                }
                .pickerStyle(.menu)
                //.padding()
                
                
                Text("Selected Option: \(outputSelectionOption)")
                    .padding()
                
                VStack {
                    Toggle("Cast to read blood glucose alarm is \(castForValueAlarmIsOn ? "on" : "off")", isOn: $castForValueAlarmIsOn)
                        .disabled(true)
                    
                    Picker("After ", selection: $castAlarmInterval_minutes) {
                        ForEach(castAlarmInterval_inMinutes, id: \.self) {
                            Text("\($0) minutes")
                        }
                    }            .pickerStyle(.menu)
                }
                
                
                
                // ==================================================================================
                
                
                
                
                
                
                
                // ==================================================================================
                
            }
            
                    .transition(.move(edge: .bottom))
        }
        
    }
    
    
    
    
}

struct UserAgreementView: View {
    
    @AppStorage("userAgreedToAgreement")                 public var userAgreedToAgreement =  false
    @State private var isScrolledToBottom = false
    @ObservedObject var bloodGlucoseData =  BloodGlucoseData.shared
    
    
    var body: some View {
        // ========================================== PRIVACY NOTICE =======================
        
        
        VStack {
            VStack {
                Section(header: Text(NSLocalizedString("Privacy notice", comment: ""))
                    .font(.headline)
                        
                ) {
                    
                    //                                Image (systemName: "eyes.inverse")
                    //                                    .font(.system(size: 33, weight: .regular))
                    Text (whatThisAppDoes)
                        .font(.callout)
                        .minimumScaleFactor(0.5)
                    
                }
                .accessibilityLabel(_: "Privacy notice")
            }
            
            VStack {
                Section( footer: Text(userAgreedToAgreement ? "" : "You have to agree to this before the app is functional.").foregroundColor(shuggaRed)
                ) {
                    GroupBox(label:
                                Label(NSLocalizedString("Agreement", comment: ""), systemImage: "building.columns")
                    ) {
                        Toggle(isOn: $userAgreedToAgreement) {
                            Text(NSLocalizedString("I agree to the terms below", comment: ""))
                            //                                        .font(.headline)
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                                .disabled(!isScrolledToBottom)
                        }.onChange(of: userAgreedToAgreement) { newValue in
                            if newValue {
                                // user agreed to the terms, so stop the player
                                
//                                bloodGlucoseData.thePlayer.stopSpeakingNow()
                            }
                        }
                        ScrollView(.vertical, showsIndicators: true) {
                            Text(legalText)
                                .font(.footnote)
                                .accessibilityLabel(_: "This is the agreement that you must agree by clicking the button below for the app to work.")
                        }
                        .background(shuggaRed.opacity(0.5))

                    }
                }

                //                if userAgreedToAgreement {
                //                    NavigationLink(destination: BloodGlucoseView(), isActive: $userAgreedToAgreement, label: { EmptyView() } )
                //                }
            }

            .frame(height: 400)
        }
    }
}

struct AcknowledgmentsSettingsView: View {
    
    var body: some View {
        
        Section(header: Text("Acknowledgments")) {
            VStack {
                VStack {
                    Text (acknowledgementText)
                        .foregroundColor(.secondary)
                        .padding([.leading, .trailing], 35)
                        .padding([.top, .bottom], 12)
                        .font(.system(size: 14, design: .rounded))
                    
                    Image("thePass")
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(22)
                        .padding([.top, .bottom], 12)
                        .padding([.leading, .trailing], 35)
                    
                    Text (nationalParksText)
                        .foregroundColor(.secondary)
                        .padding([.leading, .trailing], 35)
                        .padding([.top], 12)
                        .font(.system(size: 14, design: .rounded))                    //                                .font(.headline)
                }
                
            }
        }
        
    }
    
}
// ---------------------------------------------------

struct AppExpiredSettingsView: View {
    
    var body: some View {
        
        VStack {
            
            Text ("Shugga beta has expired. Thanks for your help!")
            
        }
        
        
    }
}
// ---------------------------------------------------
