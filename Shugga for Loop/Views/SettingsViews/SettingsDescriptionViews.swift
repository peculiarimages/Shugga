//
//  SettingsDescriptionViews.swift
//  Shugga
//
//  Created by Rodi on 3/29/23.
//

import Foundation
import SwiftUI



var endOfDescriptionScrollView: some View {
    Text("--- End of Help ---")
        .padding(.top, 25)
        .padding(.bottom, 50)
}



extension View {
    func scrollOverlayOnTheBottom() -> some View {
        self.modifier(ScrollOverlayOnTheBottom())
    }
}



struct ArrowShape: Shape {
    let arrowHeadWidth: CGFloat
    let arrowHeadHeight: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY - arrowHeadHeight))
        path.addLine(to: CGPoint(x: rect.midX - arrowHeadWidth / 2, y: rect.maxY - arrowHeadHeight))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX + arrowHeadWidth / 2, y: rect.maxY - arrowHeadHeight))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY - arrowHeadHeight))

        return path
    }
}






struct MainSwitchDescriptionView: View {
    @Binding public var announcementOn: Bool
    
    @ObservedObject var bloodGlucoseData =  BloodGlucoseData.shared

    var body: some View {
        
     
        
        VStack(alignment: .leading) {
                
            VStack {
                
                ScrollView {
                    VStack{
                    Text ("Throughout this app, \"Shugga\" is used as a verb to make utterances about your latest known blood glucose value")
                            .foregroundColor(Color.primary)
                    + Text("*")
                        .foregroundColor(shuggaRed) // Change the color of the "*" here
                    
                    + Text(" and ancillary informations.")
                        .foregroundColor(Color.primary)
                }
                        .padding(.bottom)
                    
                    
                    Text("This app is designed as a companion to Loop.app. Although it can function as a reminder for carb intake and finger-prick tests, it is most useful when used in conjunction with Loop.")
                        .foregroundColor(Color.primary)
                        .padding([.bottom, .leading, .trailing])
                        .foregroundColor(shuggaRed)
                        .padding(.bottom)
                    
                    Text("We also recommend not enabling the lock screen in the Display & Brightness settings of your phone, especially during extended periods of activity. This ensures that you continue to receive Shugga notifications during those hard-to-manage times.\(shuggaBackgroundWarning)")
                        .foregroundColor(Color.primary)
                        .padding([.bottom, .leading, .trailing])
                        .foregroundColor(shuggaRed)
                        .padding(.bottom)
                    
                    
                    
                    Text ("These \"help pop-ups\" will be very verbose to keep the settings simple and uncluttered.")
                        .foregroundColor(Color.primary)
                        .padding(.bottom)

                    Text ("Turning off the \"Shugga Me\"  switch will immediately deactivate all voice features of the app. However, the last known blood glucose and ancillary data will continue to be displayed and updated on the main screen.")
                        .foregroundColor(Color.primary)
                        .padding(.bottom)
                    
                    Text ("Lock the main blood glucose screen now: Turning this on will take you directly back to the main blood glucose screen. The two buttons at the top, the Shugga logo and the gear icons, will be disabled until you slide the lock to the right. You cannot activate the lock from these 'help pop-ups'. Once you close this, you can activate the lock if desired.")
                                            .foregroundColor(Color.primary)
                                            .padding(.bottom)
                    
                    VStack{Text("*")
                            .foregroundColor(shuggaRed) // Change the color of the "*" here
                        +
                        Text(" Please note that it may take some time for the data to get recorded into your Health. The app relies on the data on Health for the latest blood glucose value.")
                            .foregroundColor(Color.primary)
                            .italic()

                        }
                    .padding([.bottom, .leading, .trailing])


                    endOfDescriptionScrollView
                    Spacer() // for over-scroll
                }
                .padding()
                .scrollOverlayOnTheBottom()

            }                        .textCase(.none)

        }
    }
}


struct DetailedSettingsDescriptionView: View {
    
    @ObservedObject var bloodGlucoseData =  BloodGlucoseData.shared

    @Binding public var voiceVolume: Double
    @Binding public var threeSpeechSpeed: String
    @Binding public var speakInterval_seconds: Int
    
    
    var body: some View {
            
            VStack() {
               
                ScrollView {

                    Text("When this app returns to the foreground, it will check the last known blood glucose entry in Health. If the entry is older than the value you've set above, the app will initiate Shugga.")
                        .foregroundColor(Color.primary)
                        .padding(.bottom)


                    Text("If not, the app will initiate Shugga at the next timer interval you've selected here.")
                    .foregroundColor(Color.primary)
                    .padding(.bottom)

                    Text("Note: You can modify the 'Fussy Details' found in the next section for a more detailed Shugga. However, if you've selected a short interval here, a verbose Shugga might be cut off by the next readout.")
                        .italic()
                        .foregroundColor(Color.primary)
                        .padding([.bottom, .leading, .trailing])

                    
                    endOfDescriptionScrollView
                    Spacer()
            }
                .scrollOverlayOnTheBottom()

        }
            .textCase(.none)
            .padding()
    }
}


struct DisplaySettingsDescriptionView: View {
    @Binding public var doNotSleepDisplay: Bool
    @Binding public var turnBrightnessDow: Bool

    @ObservedObject var bloodGlucoseData =  BloodGlucoseData.shared
    
    var body: some View {
        VStack () {
            ScrollView {
                Text("Example:\n\nIn the USA, it's typically in mg/dL.\n\nThe rate is usually represented in a \"per min\" format. When the \"Multiply glucose trend rate by 10\" option is selected, the rate will be in \"per 10 min\" format, and will only be provided in integer values.")
                    .foregroundColor(Color.primary)
                    .padding(.bottom)

                Text("The app attempts to read the glucose trend from the blood glucose data in Health, and when this data is available, the app can include it in the Shugga notifications.")
                    .foregroundColor(Color.primary)
                    .padding([.bottom, .leading, .trailing])

                endOfDescriptionScrollView
                Spacer()
            }
            .scrollOverlayOnTheBottom()

        }
        .textCase(.none)
        .padding()
    }
}


struct UnitSettingsDescriptionView: View {
    @Binding public var userBloodGlucoseUnit: String
    @Binding public var shuggaGlucoseTrend: Bool
    @Binding public var multiplyTrendByTen: Bool
    @Binding public var includeUnit: Bool

    @ObservedObject var bloodGlucoseData =  BloodGlucoseData.shared
    
    var body: some View {
        VStack () {
            ScrollView {
                Text("Example:\n\nIn the USA, it's typically in mg/dL.\n\nThe rate is usually represented in a \"per min\" format. When the \"Multiply glucose trend rate by 10\" option is selected, the rate will be in \"per 10 min\" format, and will only be provided in integer values.")
                    .foregroundColor(Color.primary)
                    .padding(.bottom)

                Text("The app attempts to read the glucose trend from the blood glucose data in Health, and when this data is available, the app can include it in the Shugga notifications.")
                    .foregroundColor(Color.primary)
                    .padding([.bottom, .leading, .trailing])

                endOfDescriptionScrollView
                Spacer()
            }
            .scrollOverlayOnTheBottom()

        }
        .textCase(.none)
        .padding()
    }
}





struct RemindersDescriptionView: View {
    
    @Binding public var reminderIsOn: Bool
    
    @Binding public var reminderAfterFood_30Min:  Bool
    @Binding public var reminderAfterFood_60Min:  Bool
    @Binding public var reminderAfterFood_90Min:  Bool
    @Binding public var reminderAfterFood_120Min: Bool
    @Binding public var reminderAfterFood_150Min: Bool
    @Binding public var reminderAfterFood_180Min: Bool
    @Binding public var reminderAfterFood_210Min: Bool
    @Binding public var reminderAfterFood_240Min: Bool
    
    
    var body: some View {
        
        
        
        VStack () {
 
            ScrollView {
                Text ("The app will try to Shugga reminders of the last known carbohydrate record at around the selected times.")
                    .foregroundColor(Color.primary)
                    .padding(.bottom)
                Text ("When the app is in the background, the app doesn't really have a whole lot of control when to Shugga.")
                    .foregroundColor(Color.primary)
                    .padding(.bottom)

                Text("For example, if 30 minutes is selected, the app will attempt to Shugga a reminder between 30 to 60 minutes after a carb consumption (30 + 30). The reminder frequency varies based on the app's state: every 5 minutes in the foreground and as frequently as the operating system allows in the background (approximately every ten minutes, though it can sometimes be less frequent). If you want to Shugga without using your phone, we recommend keeping the app open and adjusting the Display & Brightness setting to prevent the screen from locking.")
                    .foregroundColor(Color.primary)
                    .padding([.bottom, .leading, .trailing])
                
                Text("Please note, when your phone is unlocked, fully charged, and/or being charged, it should have the best chance to Shugga approximately every ten minutes.")
                    .foregroundColor(Color.primary)
                    .padding(.bottom)
                
                Text("However, please be aware that background Shugga can be unreliable due to constraints imposed by the operating system.")
                    .foregroundColor(Color.primary)
                    .padding([.bottom, .leading, .trailing])
                
                endOfDescriptionScrollView
                Spacer()
            }
            .scrollOverlayOnTheBottom()

        }
        .textCase(.none)
        .padding()
        
        
        
    }
}



struct AncillaryDataViewSettingsDescriptionView: View {
    
    @Binding public var ancillaryDataOn: Bool
    @Binding public var showShuggaStatus: Bool
    @Binding public var showCGM_info: Bool
    @Binding public var showCarbHistory: Bool

    
    
    var body: some View {
        
        
        
        VStack () {
            ScrollView {
                VStack {
                    Spacer()
                    
                    SpeechBubble{ VStack{ShuggaStatusInfoView()}.padding() }
                    Text ("Status: Toggles between showing and hiding status icons and output port.")
                        .foregroundColor(Color.primary)
                        .padding(.bottom)
                    
                    Spacer()

                    SpeechBubble{ VStack{CGM_InfoView()}.padding() }
                    Text ("CGM Info: Toggles between showing and hiding the basic CGM info in your recent blood glucose data.")
                        .foregroundColor(Color.primary)
                        .padding(.bottom)
                    
                    Spacer()

                    SpeechBubble{ VStack{CarbStatusView()}.padding() }
                    Text ("Carb History: When this is turned on, the main screen will show your carb history over the 24 hours.")
                        .foregroundColor(Color.primary)
                        .padding([.bottom, .leading, .trailing])
                    
                    endOfDescriptionScrollView
//                    Spacer()
                }
            }
            .scrollOverlayOnTheBottom()

        }
        .textCase(.none)
        .padding()
        
        
        
    }
}


struct NitPickyDescriptionView: View {
    
    @Binding public var skipHundredth: Bool
    @Binding public var usesApplicationAudioSession: Bool
    @Binding public var userBloodGlucoseUnit: String
    @Binding public var speakElapsedTime: Bool
    @Binding public var doubleTapForSugah: Bool
    @Binding public var whiteBackground: Bool
    @Binding public var mainBloodGlucoseDisplayFontSize: Int
    @Binding public var grayAppIcon: Bool
    @Binding public var shuggaInBackground: Bool
    @Binding public var shuggaGlucoseTrend: Bool

    
    var body: some View {
                
        VStack () {
            ScrollView {
                

                
                Group {
                    Text("Shugga Time Elapsed in Foreground: Time elapsed is always included when Shugga is triggered from the background. This option allows you to control whether this feature is enabled while the app is in the foreground. Due to potential delays in the background, the time elapsed will always be Shugga-ed when the app is in the background.")
                        .foregroundColor(Color.primary)
                        .padding(.bottom)

                    Text("Skip Hundred: When English is the selected language, enabling this option will prompt Shugga to say \"One twenty three\" instead of \"One hundred twenty three\" when the value is 123.")
                        .foregroundColor(Color.primary)
                        .padding(.bottom)
                }
                .padding([.leading, .trailing])

                Group{
                    Text("Double-tap screen for Shugga: When this option is enabled, you can double-tap the blood glucose value displayed on the main screen to manually initiate Shugga. If Ancillary Data: Carb History is showing, double-tapping in that area will trigger Shugga to review your carb intake according to your carb reminder settings. (e.g., if you have a 2-hour reminder selected, Shugga will check for any new blood sugar entries after two hours and notify you).")
                        .foregroundColor(Color.primary)
                        .padding(.bottom)

                    Text("Flat Background: Enable this if you prefer a non-gradient background on the main screen.")
                        .foregroundColor(Color.primary)
                        .padding(.bottom)
                }
                .padding([.leading, .trailing])

                Group{
                    Text("Glucose Value Font Size: This setting controls the size of the blood glucose value displayed on the main screen. It also impacts the size of other ancillary data relative to the blood glucose font size.")
                        .foregroundColor(Color.primary)
                        .padding(.bottom)

                    Text("Gray App Icon: Enable this if you prefer the app icon on the main and settings screens to be monochrome (colorless).")
                        .foregroundColor(Color.primary)
                        .padding(.bottom)

                    Text("Background Shugga: When enabled, the app will attempt to issue Shugga notifications in the background as permitted by the operating system. The frequency of background Shugga notifications is largely determined by the OS. For the best results, keep your phone fully charged and connected to a reliable power source. Under optimal conditions, the app should issue a Shugga notification approximately every ten minutes, though this can vary.")
                        .foregroundColor(Color.primary)
                        .padding(.bottom)
                }
                .padding([.leading, .trailing])

                Group{
                    Text("Other Audio: NOT IMPLEMENTED YET")
                        .foregroundColor(Color.primary)
                        .padding([.bottom, .leading, .trailing])
                }

                .padding([.leading, .trailing])
                
                endOfDescriptionScrollView
                
                
                Spacer()
            }
            .scrollOverlayOnTheBottom()
            .textCase(.none)

        }
        .textCase(.none)
        .padding()
        
        
        
    }
}




struct CarbHistoryDescriptionView: View {
    
    
    @Binding public var skipHundredth: Bool
    @Binding public var usesApplicationAudioSession: Bool
    @Binding public var userBloodGlucoseUnit: String
    @Binding public var speakElapsedTime: Bool
    @Binding public var doubleTapForSugah: Bool
    @Binding public var whiteBackground: Bool
    @Binding public var mainBloodGlucoseDisplayFontSize: Int
    @Binding public var grayAppIcon: Bool
    @Binding public var shuggaInBackground: Bool
    @Binding public var shuggaGlucoseTrend: Bool
    
    
    var body: some View {
        VStack {
            
            Text ("Carb history:")
        }
    }
}
