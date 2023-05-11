//
//  BloodGlucoseView.swift
//  healthKitBackgroundDeliveryWithAI
//
//  Created by Rodi on 1/14/23.
//

import SwiftUI
import HealthKit
import Foundation
import AVFoundation
import UIKit
import BackgroundTasks
import Speech
import Combine


class CountdownTimerViewModel: ObservableObject {
    @Published var remainingTime: Int
    private var cancellable: AnyCancellable?
    @AppStorage("pauseForX_min")                   public var pauseForX_min =                     pauseShuggaDefault_min

    init(initialTime: Int) {
        remainingTime = initialTime
    }

    func startCountdown() {
        remainingTime = pauseForX_min
        
        cancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.remainingTime > 0 {
                    self.remainingTime -= 1
                } else {
                    self.cancellable?.cancel()
                }
            }
    }

    deinit {
        cancellable?.cancel()
    }
}


struct ActivityIndicator: UIViewRepresentable {
    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style
    
    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}












struct PauseTimerView: View {
    
    @ObservedObject var bloodGlucoseData = BloodGlucoseData.shared
    @AppStorage("pauseForX_min")                   public var pauseForX_min =                     pauseShuggaDefault_min

    var body: some View {
        VStack {
            Text("\(remainingTimeFormatted)")
//                .font(.largeTitle)
        }
//        .onReceive(bloodGlucoseData.$remainingPauseTime, perform: { _ in
//            // The view will be updated when bloodGlucoseData.objectWillChange is triggered
//        })
    }
    
    var remainingTimeFormatted: String {
        
        let hours = Int(bloodGlucoseData.remainingPauseTime) / SecondsIn.oneHour.rawValue
        let minutes = (Int(bloodGlucoseData.remainingPauseTime) % SecondsIn.oneHour.rawValue) / 60
        let seconds = Int(bloodGlucoseData.remainingPauseTime) % 60
        
        if pauseForX_min * SecondsIn.oneMinute.rawValue > SecondsIn.oneHour.rawValue
        {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)

        } else
        {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
}








struct BloodGlucoseView: View {
    
    @ObservedObject var bloodGlucoseData =  BloodGlucoseData.shared
    //    @ObservedObject var theTranslator =     TheTranslator.shared
    
    @ObservedObject var shuggaStatus = ShuggaStatus.shared
    @ObservedObject var carbohydrateData = CarbohydrateData.shared
    
    
    
    // APP STORAGE
    @AppStorage("userAgreedToAgreement")                public var userAgreedToAgreement =                  false
    @AppStorage("whiteBackground")                      public var whiteBackground =                        false
    @AppStorage("grayAppIcon")                          public var grayAppIcon =                            false
    @AppStorage("appExpirationDate")                    public var appExpirationDate =                      june_1_2023 // 1672559996 = april 1 2023 unix time stamp
    @AppStorage("demoMode")                             public var demoMode =                                false
    @AppStorage("dataTooOldPeriod_min")                 public var dataTooOldPeriod_min =                   dateTooOldPeriod_min_default
    @AppStorage("mainBloodGlucoseDisplayFontSize")      public var mainBloodGlucoseDisplayFontSize: Int =   200
    @AppStorage("skipHundredth")                        public var skipHundredth =                          false
    @AppStorage("userBloodGlucoseUnit")                 public var userBloodGlucoseUnit =                   BloodGlucoseUnit.milligramsPerDeciliter
    @AppStorage("doubleTapForSugah")                    public var doubleTapForSugah =                      false
    
    @AppStorage("deBugModeToggle")                      public var deBugModeToggle =                        true
    
    @AppStorage("ancillaryDataOn")                      public var ancillaryDataOn =  true
    @AppStorage("showShuggaStatus")                     public var showShuggaStatus =  true
    @AppStorage("showCGM_info")                         public var showCGM_info =  false
    @AppStorage("showCarbHistory")                      public var showCarbHistory =  false
 
    
    
    
    
    
    
    
    @AppStorage("showLockButton")                       public var showLockButton =                     false

    
    
    
    
    
    
    
    @State var navigationImageSize:                     CGFloat = 50
    @State private var orientation =                    UIDeviceOrientation.unknown // buggy - doesn't know the orientation at launch.
    @State var settingsSymbol =                        Image(systemName: settingSymbolName)
    @State var theHealthKitIsAvailableOnThisDevice = false
    
    @State var bloodGlucoseValueTextColor: Color =  .primary
    
    //    var fetchFrequency: Double = 10.0
    @Environment(\.scenePhase) var scenePhase
    
    let dateForExpirationPurpose = NSDate() // current date
    
    let whiteBackgroundColor = LinearGradient(
        gradient: Gradient(colors: [Color(UIColor.systemBackground), Color(UIColor.systemBackground)]),
        startPoint: .topTrailing,
        endPoint: .bottomLeading)
    
    
    var glucoseMonitorModel = GlucoseMonitorModel()
    
    let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)), Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))]),
        startPoint: .topTrailing,
        endPoint: .bottomLeading)
    
    var backgroundDeliveryStatus = false
    
    let bloodGlucoseOnForegroundViewTimer = Timer.publish(every: 19, on: .main, in: .common).autoconnect()
  
    
    @AppStorage("theMainViewIsLocked")                       public var theMainViewIsLocked =                     false
    @AppStorage("theShuggaIsPaused")                         public var theShuggaIsPaused =                     false
    @AppStorage("pauseNow")                   public var pauseNow =                     false
    @AppStorage("pauseForX_min")                   public var pauseForX_min =                     pauseShuggaDefault_min

    @StateObject private var viewModel = CountdownTimerViewModel(initialTime: SecondsIn.oneDay.rawValue)

    
//    var pauseTimerStarted = false
    
    var body: some View {
        let unixTimeForExpirationPurpose = dateForExpirationPurpose.timeIntervalSince1970
        //        if bloodGlucoseData.manySweetnesses.sugahNow {
        //            DispatchQueue.global(qos: .background).async {
        //                bloodGlucoseData.speakBloodGlucose()
                
        
        
        
        
        ZStack {
            NavigationView (
                content: {
                    
                    //   if whiteBackground { whiteBackgroundColor .edgesIgnoringSafeArea(.all) }
                    
                    VStack {
                        TopMenuView( grayAppIcon: $grayAppIcon,     settingsSymbol: $settingsSymbol,    navigationImageSize: $navigationImageSize,
                                     userAgreedToAgreement: $userAgreedToAgreement,                     orientation: $orientation,
                                     theHealthKitIsAvailableOnThisDevice: $theHealthKitIsAvailableOnThisDevice)
                        
                        Spacer()
                        
                        if (Int(unixTimeForExpirationPurpose) < appExpirationDate && thisIsBeta == true ) || thisIsBeta == false
                        {
                            if userAgreedToAgreement
                            {
                                if !demoMode {
                                    
                                    VStack {
                                        MainGlucoseDisplayView(     bloodGlucoseValueTextColor: $bloodGlucoseValueTextColor,
                                                                    orientation: $orientation,          userBloodGlucoseUnit: $userBloodGlucoseUnit,
                                                                    mainBloodGlucoseDisplayFontSize: $mainBloodGlucoseDisplayFontSize,
                                                                    demoMode: $demoMode,                dataTooOldPeriod_min: $dataTooOldPeriod_min,
                                                                    skipHundredth: skipHundredth)
                                    }
                                    .padding(.top, 10)
                                    .onAppear () {
                                        
                                        if let _ = bloodGlucoseData.manySweetnesses.sweetnesses?.last?.sweetness {
                                            DispatchQueue.main.async { bloodGlucoseData.userApprovedHealthKitBloodGlucose_Read = true }
                                        }
                                    }
                                    .onAppear () {
                                        let sampleType = bloodGlucoseHKSampleType
                                        
                                        bloodGlucoseData.healthStore.enableBackgroundDelivery(for: sampleType, frequency: .immediate) { (success, error) in
                                            if success {  print("123 Background delivery enabled for \(sampleType.identifier)") }
                                            else { print("123 Failed to enable background delivery for \(sampleType.identifier): \(error?.localizedDescription ?? "unknown error")")  }
                                        }
                                    }
                                    .onAppear () {
                                        
                                        bloodGlucoseData.carbohydrateData.isItTimeToRemindAboutBloodGlucose()
                                        
                                        
                                    }
                                    
                                    .onTapGesture(count: 2) {
                                        
//                                        triggerHaptic(binaryPattern: "10101", timeUnit: 0.1)

                                        handleBloodGlucoseViewOnTapGesture(view: self,
                                         doubleTapForSugah: doubleTapForSugah, bloodGlucoseData: bloodGlucoseData)
                                        

                                        
                                    }
                                    .onChange(of: scenePhase) { newPhase in handleBloodGlucoseViewOnChange (view: self, newPhase: newPhase, bloodGlucoseData: bloodGlucoseData)  }
                                    
                                    
                                    
                                    
//                                    if pauseNow {
//                                        PauseTimerView()
//                                        
//                                    }
//                                    
                                    
                                    
                                    if theMainViewIsLocked {
                                        //                                    Spacer()
                                        LockButtonView(theMainViewIsLocked: $theMainViewIsLocked, theShuggaIsPaused: $theShuggaIsPaused)
                                        //                                    .background(Color.clear)
                                            .padding()
                                            .offset(y: -50)
                                        Spacer()
                                    }
                                    
                                    if pauseNow {
                                        //                                    Spacer()
                                        LockButtonView(theMainViewIsLocked: $theMainViewIsLocked, theShuggaIsPaused: $theShuggaIsPaused)
                                        //                                    .background(Color.clear)
                                            .padding()
                                            .offset(y: -50)
                                        Spacer()
                                    }
                                    
                                    
                                    
                                    if ancillaryDataOn && (showShuggaStatus || showCarbHistory || showCGM_info) { Spacer() }
                                    if bloodGlucoseData.userApprovedHealthKitBloodGlucose_Read && ancillaryDataOn && showShuggaStatus  { ShuggaStatusInfoView()    }
                                    if ancillaryDataOn && showCarbHistory   {
                                        CarbStatusView()
                                            .onTapGesture(count: 2) { bloodGlucoseData.carbohydrateData.isItTimeToRemindAboutBloodGlucose()
                                                triggerHaptic(binaryPattern: "10000000100000010000010010001", timeUnit: 1)

                                            }
                                    }
                                    if bloodGlucoseData.userApprovedHealthKitBloodGlucose_Read && ancillaryDataOn && showCGM_info      { CGM_InfoView()            }
                                }
                            }
                            else {
                                UserHasNotAgreedToAgreementNoticeView()
                                Spacer()
                            }
                        }
                        
                        if thisIsBeta && deBugModeToggle {
                            Spacer()
                            ScrollView() {
                                
                                if thisIsBeta && deBugModeToggle  {
                                    deBugAndBetaView(appExpirationDate: appExpirationDate, unixTimeForExpirationPurpose: unixTimeForExpirationPurpose) }
                                if deBugMode && deBugModeToggle {
                                    
                                    deBugGlucoseValueListFView()
                                    debugShowCGM_View () }
                            }.padding()
                        }
                    }
                    .onAppear {
                        if showLockButton { theMainViewIsLocked = true }
                        else { theMainViewIsLocked = false }
                        
                        
                        
                        bloodGlucoseData.fetchLatestBloodGlucose(limit: 1, whoCalledTheFunction: .bloodGlucoseView_onAppear) { result in
                            switch result {
                                
                            case .success:
                                print("foregroundViewTimer blood glucose fetch complete")
                                
                            case .failure(let error):
                                print("❌ foregroundViewTimer fetch blood glucose failed: \(error)")
                            }
                        }
                        
                    }
                    .background(whiteBackground ? whiteBackgroundColor : backgroundGradient)
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
//
//
//                    .onReceive(bloodGlucoseOnForegroundViewTimer) { _ in
//
//                        bloodGlucoseData.fetchLatestBloodGlucose(limit: 1, whoCalledTheFunction: .foregroundViewTimer) { result in
//                            switch result {
//
//                            case .success:
//                                print("foregroundViewTimer blood glucose fetch complete")
//
//                            case .failure(let error):
//                                print("❌ foregroundViewTimer fetch blood glucose failed: \(error)")
//                            }
//                        }
//                    }
//
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                }
            ) // Navigation View
//            GradientOutlineView()

            
        }
        
        
    }
}





struct BloodGlucoseView_Previews: PreviewProvider {
    
    
    
    
    
  
    
    static var previews: some View {
        
        let healthStore = HKHealthStore()
        
 
    
    
        var sweetness =  Sweetness(sweetness: 99.9)
        
        let bloodGlucoseData = BloodGlucoseData()
        
        bloodGlucoseData.manySweetnesses.addSweetness(sweetness: sweetness)
        
        
        
       return  BloodGlucoseView()
            .environmentObject(bloodGlucoseData)
            .previewDisplayName("sample data")
            .colorScheme(.light)
    }
}
