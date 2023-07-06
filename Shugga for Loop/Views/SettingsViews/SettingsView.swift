//
//  SettingsView.swift
//  sugar me high
//
//  Created by Rodi on 9/21/22.
//

import SwiftUI
import AVFAudio
import Foundation
import BackgroundTasks


struct SettingsView: View {
    
    @AppStorage("appExpirationDate")            public var appExpirationDate =             july_1_2023 // 1672559996 = jan 1 2023 unix time stamp
    @AppStorage("userAgreedToAgreement")        public var userAgreedToAgreement =              false
    @AppStorage("announcementOn")               public var announcementOn =                     defaultShuggaIsOn

//    @Binding var theHealthKitIsAvailableOnThisDevice: Bool
    
    @State private var isEditingSlider =        false
    
    @State private var refreshIsPressed =       false
    
    @ObservedObject var bloodGlucoseData =      BloodGlucoseData.shared     //***
//    @EnvironmentObject var bloodGlucoseData: BloodGlucoseData.shared // Replace with your ObservableObject

    
    
    
    
    
   // @EnvironmentObject var thePlayer:            TTS

    @State private var isScrolledToBottom =     false

    let dateForExpirationPurpose =             NSDate() // current date
    
    var theAppJustOpened =                     true
        
    @Binding var theMainViewIsLocked: Bool
    @Binding var theShuggaIsPaused: Bool

    @State  var showOtherSettings: Bool = false

    var body: some View {
        
        
        let unixTimeForExpirationPurpose = dateForExpirationPurpose.timeIntervalSince1970
        // var currentAvailableLanguages = theAvailableLanguages.availableVoicesStruct
        NavigationForSettingsView()

        
        NavigationView { // Add NavigationView here
            VStack {
                HStack {
                    
                    Text ("Settings")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding(.leading)
                .padding([.bottom], -5)
                if Int(unixTimeForExpirationPurpose) < appExpirationDate {
                    
                    Form {
                        
                        if thisIsBeta { DeBugModeForSettingsView()}
                        
                        if (userAgreedToAgreement) {
                            
                            MainSwitchSettingsView(theMainViewIsLocked: $theMainViewIsLocked, theShuggaIsPaused: $theShuggaIsPaused, showOtherSettings: $showOtherSettings)
                            
                            //theMainViewIsLocked: $theMainViewIsLocked, theShuggaIsPaused: $theShuggaIsPaused, showOtherSettings: $showOtherSettings


                            if showOtherSettings {
                                withAnimation {
                                    Section {
                                        DetailsSettingsView()
                                            .transition(.opacity)
                                            .padding(.leading)
                                    }
                                }
                                withAnimation {
                                    Section {
                                        UnitSettingsView()
                                            .transition(.opacity)
                                            .padding(.leading)
                                    }
                                }
                                withAnimation {
                                    Section {
                                        VolumeAndSpeedSettingsView()
                                            .transition(.opacity)
                                            .padding(.leading)
                                    }
                                }
                                withAnimation {
                                    Section {
                                        WarningSettingsView()
                                            .transition(.opacity)
                                            .padding(.leading)
                                    }
                                }
                                withAnimation {
                                    Section {
                                        VoiceSettingsView()
                                            .transition(.opacity)
                                            .padding(.leading)
                                    }
                                }
                                withAnimation {
                                    Section {
                                        DoNotSleepDisplaySettingView()
                                            .transition(.opacity)
                                            .padding(.leading)
                                    }
                                }
                                withAnimation {
                                    Section {
                                        NitPickSettingsView()
                                            .transition(.opacity)
                                            .padding(.leading)
                                    }
                                }
                                withAnimation {
                                    Section {
                                        AncillaryDataSettingsView()
                                            .transition(.opacity)
                                            .padding(.leading)
                                    }
                                }
                                withAnimation {
                                    Section {
                                        ReminderSettingsView()
                                            .transition(.opacity)
                                            .padding(.leading)
                                    }
                                }
                                withAnimation {
                                    Section {
                                        ExperimentSettingsView(theMainViewIsLocked: $theMainViewIsLocked)
                                    }
                                 }
                                    
                                
                            }

                            
                        } // if userAgreedToAgreement
                        
                        UserAgreementView()
                        
                     //   AcknowledgmentsSettingsView()
                        
                    } // end of form
//                    .navigationBarTitle("Settings")
//                    .navigationBarTitleDisplayMode(.inline)
//                    .font(.system(size: 20, weight: .bold))
                }
                else //appExpirationDate
                
                {
                    AppExpiredSettingsView()
                }
                
            }
            .onAppear {
                
                showOtherSettings = announcementOn
            }
        }
//        .navigationViewStyle(.stack)
        
    }
    
}













struct HelpButton<Content: View>: View {
    @Binding var showDescription: Bool
    let title: String

    @ViewBuilder let content: () -> Content

    var body: some View {
        Button(action: {
            showDescription.toggle()
        }) {
            Image(systemName: "questionmark.circle")
                .foregroundColor(.gray)
                .opacity(0.6)
        }
        .popover(isPresented: $showDescription) {
            
            VStack(alignment: .leading) {
                HStack {
                  
                    Text(title)
                        .font(.headline)
                    Spacer()
                    Image(systemName: "info.circle")
                        .foregroundColor(.blue)
                }
            
                content()
                    .padding(.top)
                
                HStack {
                    Spacer()
                    Button(action: {
                        showDescription = false
                    }) {
                        CloseButtonText()
                    }
                    Spacer()

                }

            }
            .padding()
//            .frame(width: UIScreen.main.bounds.width * 0.95)
            
        }
    }
}
















struct SettingsView_Previews: PreviewProvider {
    @State static var theHealthKitIsAvailableOnThisDevice = true
    @State static var userAgreedToAgreement = true
    
    @State static var theMainViewIsLocked = false
    @State static var theShuggaIsPaused = false

    static var previews: some View {
        

        SettingsView(userAgreedToAgreement: userAgreedToAgreement, theMainViewIsLocked: $theMainViewIsLocked, theShuggaIsPaused: $theShuggaIsPaused)//                       // Set the locale environment value to English
                       .environment(\.locale, .init(identifier: "en"))
                       .previewDisplayName("Language Choices by Scheme")
                       .environmentObject(TheAppVoices())
                       .environmentObject(TheTranslator())
                      // .environmentObject(TTS())
        
//            SettingsView(userAgreedToAgreement: userAgreedToAgreement,
//                         theHealthKitIsAvailableOnThisDevice: $theHealthKitIsAvailableOnThisDevice)
//                       // Set the locale environment value to Japanese
//                       .environment(\.locale, .init(identifier: "ja"))
//                       .previewDisplayName("Japanese")
//                       .environmentObject(TheAppVoices())
//                       .environmentObject(TheTranslator())
//                       .environmentObject(TTS())

            
//        SettingsView(userAgreedToAgreement: userAgreedToAgreement,
//                     theHealthKitIsAvailableOnThisDevice: $theHealthKitIsAvailableOnThisDevice)
//                       // Set the locale environment value to Japanese
//                .environment(\.locale, .init(identifier: "de"))
//                       .previewDisplayName("German")
//                       .environmentObject(TheAppVoices())
//                       .environmentObject(TheTranslator())
        //                         .environmentObject(TTS())
//
        
        
        
    }
}



//
