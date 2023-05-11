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
                    
                    Text ("These \"help pop-ups\" will be very verbose to keep the settings simple and uncluttered.")
                        .foregroundColor(Color.primary)
                        .padding(.bottom)

                    Text ("Turning off \"Shugga Me\" switch will turn off all voice features of the app immediately. The last known blood glucose and ancillary data will remain displayed and updated on the main screen.")
                        .foregroundColor(Color.primary)
                        .padding(.bottom)
                    
                    Text ("Lock the main blood glucose screen now: Turning this on will pop you right back to the main blood glucose screen. The two buttons on the top, the Shugga logo and the gear icons, will be disabled until you slide the lock to the right. You cannot engage the lock from this \"help pop-ups\". Once you close this, you can engage the lock if you so wish.")
                        .foregroundColor(Color.primary)
                        .padding(.bottom)
                    
                    VStack{Text("*")
                            .foregroundColor(shuggaRed) // Change the color of the "*" here
                        +
                        Text(" Please note that if you are using a CGM, it may take some time for the data to get recorded into your Health. The app relies on the data on Health for the latest blood glucose value.")
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

                Text("When this app comes back from being in the foreground, the app will check in Health how long ago the last known blood glucose entry was. If that is older than the value you set above, then the app will Shugga.")
                    .foregroundColor(Color.primary)
                    .padding(.bottom)

                Text("Otherwise, the app will Shugga with the next timer interval you've chosen here.")
                    .foregroundColor(Color.primary)
                    .padding(.bottom)

                Text("Note: The Nitpicky Details found in the next section can be modified to provide a more detailed Shugga. However, if have a short interval selected here, the current Shugga may be cut off by the next readout if it's too verbose.")
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


struct UnitSettingsDescriptionView: View {
    @Binding public var userBloodGlucoseUnit: String
    @Binding public var shuggaGlucoseTrend: Bool
    @Binding public var multiplyTrendByTen: Bool
    @Binding public var includeUnit: Bool

    @ObservedObject var bloodGlucoseData =  BloodGlucoseData.shared
    
    var body: some View {
        VStack () {
            ScrollView {
                Text ("Example:\n\nIn the USA, it's typically mg/dL.\n\nThe rate is usually in \"per min\" format. When \"Multiply glucose trend rate by 10\" is selected, it will be \"per 10 min.\" and it will only give you in integers")
                    .foregroundColor(Color.primary)
                    .padding(.bottom)

                Text ("The app tries to read the glucose trend from the blood glucose data in Health and when it is available to the app, it can Shugga that as well.")
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
            Text ("This is not implemented yet")
                .foregroundColor(.orange)
            ScrollView {
                Text ("The app will try to Shugga reminders of the last known carbohydrate record at around the selected times.")
                    .foregroundColor(Color.primary)
                    .padding(.bottom)
                Text ("When the app is in the background, the app doesn't really have a whole lot of control when to Shugga.")
                    .foregroundColor(Color.primary)
                    .padding(.bottom)

                Text ("eg: If 30 minutes is selected, between 30 to 60 minutes post a carb consumption, the app will try to Shugga a reminder. When in foreground, every 5 minutes and when in background whenever the operating system allows (about every ten minute?) until a new blood glucose value is entered by the CGM or manually.")
                    .foregroundColor(Color.primary)
                    .padding([.bottom, .leading, .trailing])
                
                Text ("When the phone is unlocked and fully charged and/or being charged, it should be given a chance to Shugga about every ten minutes or so.")
                    .foregroundColor(Color.primary)
                    .padding(.bottom)
                
                Text ("But please note that background Shugga is unreliable due to the OS's constraints.")
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
                    Text ("Shugga Time Elapsed in Foreground: Time elapsed is always included when Shuggaed from the background. This option allows that from being toggled while the app is in the foreground. The actual Shugga may delay when in background so it will always Shugga the time elapsed when in background.")
                        .foregroundColor(Color.primary)
                        .padding(.bottom)
                    
                    Text ("Skip Hundred: When English is the chosen language, selecting this option will Shugga \"One twenty three\" instead of \"One hundred twenty three\" when the value is 123")
                        .foregroundColor(Color.primary)
                        .padding(.bottom)
                    
                }
                .padding([.leading, .trailing])
                
                Group{
                    
                    Text ("Double tap screen for Shugga: When this option is turned on, you can double tap the blood glucose value displayed on the main screen to manually Shugga. If Ancillary Data: Carb History is showing, double clicking on that area will trigger Shuuga to review according to your carb reminder settings. (eg: if you have 2 hours, selected, it will see if you have any new blood sugar after two hours and will let you know.")
                        .foregroundColor(Color.primary)
                        .padding(.bottom)
                    
                    Text ("Flat Background: Turn this on if you rather have no gradation in the background in the main screen.")
                        .foregroundColor(Color.primary)
                        .padding(.bottom)
                }
                .padding([.leading, .trailing])
                
                Group{
                    Text ("Glucose value font size: This sets the size of the blood glucose value displayed in the main screen. It also affects other ancillary data displayed, relative to the blood glucose font size.")
                        .foregroundColor(Color.primary)
                        .padding(.bottom)
                    
                    Text ("Gray app icon: Turn this on if you want to make the app icon on the main and settings screen to be in monochrome (no color).")
                        .foregroundColor(Color.primary)
                        .padding(.bottom)
                    
                    Text ("Background Shugga: When enabled, the app will attempt to Shugga in the background as permitted by the operating system. The app has limited control over the frequency of background Shugga, as this is determined by the OS. For optimal results, keep your phone fully charged and connected to a fast charger. The app should Shugga approximately every ten minutes under optimal conditions, although this may vary.")
                        .foregroundColor(Color.primary)
                        .padding(.bottom)
                }
                .padding([.leading, .trailing])
                
                Group{
                    
                 
                    
                    Text ("Other audio: NOT IMPLEMENTED YET")
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
