//
//  BloodGlucoseViewComponents.swift
//  Sugah
//
//  Created by Rodi on 10/13/22.
//

import Foundation
import SwiftUI
import CoreMotion
import BackgroundTasks


// ====================== CORE MOTION ==================== 👇
let motionManager = CMMotionManager()
let motionQueue = OperationQueue()
// ====================== CORE MOTION ====================　👆





struct GradientOutlineView: View {
    let outlineWidth: CGFloat = 0.2
    let outlineCount: Int = 25
    let baseCornerRadius: CGFloat = 52
    
    func gradientColor(for index: Int) -> Color {
        let fraction = Double(index) / Double(outlineCount - 1)
        return Color.black.opacity(1.0 - fraction * 0.95)
    }
    
    func cornerRadius(for index: Int) -> CGFloat {
        return baseCornerRadius - CGFloat(index) * outlineWidth
    }
    
    var body: some View {
        ZStack {
            ForEach(0..<outlineCount) { index in
                RoundedRectangle(cornerRadius: cornerRadius(for: index))
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [gradientColor(for: index), gradientColor(for: index)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: outlineWidth
                    )
                    .padding(outlineWidth * CGFloat(index))
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}


















struct DebugDivider: View {
    var body: some View {
        Color.black
            .frame(height:8)
    }
}


struct deBugAndBetaView: View {
    let appExpirationDate: Int
    let unixTimeForExpirationPurpose: Double
    
    var body: some View{
        
        HStack{
            DebugDivider()
            Text ("BETA DEBUG VIEW ")
            DebugDivider()
        }
        Text ("Turn this off in Settings: Debug Mode ").opacity(0.5)
        
        VStack{ if Int(unixTimeForExpirationPurpose) < appExpirationDate {
            VStack{
                let betaMinutesLeft = Int ((appExpirationDate - Int(unixTimeForExpirationPurpose)) / 60 / 60 / 24 )
                Text ("This beta expires in approximately \(betaMinutesLeft) days.")
                    .foregroundColor(.gray)
                    .opacity(0.3)
            }
        }
            else {  BetaExpirationView()  }
        }
    }
}


struct debugShowCGM_View: View {
    
    @ObservedObject var bloodGlucoseData =  BloodGlucoseData.shared
    let diabetes = Diabetes()

    var body: some View {

        VStack {
            Text (bloodGlucoseData.glucoseMonitorModel.currentGlucoseMonitor?.modelName ?? "No glucose monitor found (yet...)")
            Text ("Samples every \(formatSecondsToTimeString(seconds: Int(bloodGlucoseData.glucoseMonitorModel.currentGlucoseMonitor?.samplingSeconds ?? -1), cutOffAt: CutOffAt.minutes))")
                .multilineTextAlignment(.center)

           //     Text("Samples every: \(formatSecondsToTimeString(Int(glucoseMonitor?.samplingSeconds ?? 0)))")
        }
        .padding()
    }
}



struct deBugGlucoseValueListFView: View {
    @ObservedObject var bloodGlucoseData =  BloodGlucoseData.shared
    
    
    var body: some View {
        
        Text ("App started: \(bloodGlucoseData.manySweetnesses.deBug.timeString)")
        
        VStack {
                //Text("Current BG: \(String(format: "%.0f", bloodGlucoseData.glucoseValue))")
            if let sweetness =  bloodGlucoseData.manySweetnesses.sweetnesses?.last?.sweetness {
           
                    HStack{
                        Text ("last bkGnd 🔊:")
                        Text ("\(timeStampToLocal_hh_mm_ss(timestamp: bloodGlucoseData.lastTimeBloodGlucoseWasAnnounced ?? zeroTimestamp))")
                        Text (" : \(sweetness)")
                    }
                
                
                Text("Current BG: \(String(format: "%.0f", sweetness))")
            }

            Text ("# by Background fetch: \(String(bloodGlucoseData.numberOfTimesBackgroundTaskCalledThis))")
                 
                 Button(action: {
                     self.bloodGlucoseData.isFetching = true
                     self.bloodGlucoseData.fetchLatestBloodGlucoseAndSpeak(whoCalledTheFunction: .deBugView) { success in
                         if success {
                             print("Latest blood glucose fetched and spoken successfully! \(WhoCalledTheFunction.deBugView.rawValue)")
                         } else {
                             print("Failed to fetch or speak latest blood glucose.")
                             print("deBugGlucoseValueListFView")
                         }
                     }
                     
                 }) {
                     if self.bloodGlucoseData.isFetching {
                         ActivityIndicator(isAnimating: $bloodGlucoseData.isFetching, style: .large)
                     } else {
                         Text("Fetch Latest Blood Glucose")
                     }
                 }
             }
       
        
        
        
        
        /*
        
        
             .onAppear {
                 bloodGlucoseData.fetchLatestBloodGlucoseAndSpeak(whoCalledTheFunction: .bloodGlucoseView_onAppear) { success in
                     if success {
                         print("Latest blood glucose fetched and spoken successfully! \(WhoCalledTheFunction.bloodGlucoseView_onAppear.rawValue)")
                     } else {
                         print("Failed to fetch or speak latest blood glucose. .onAppear")
                     }
                 }
             }
        
        
        */
        
        
        
        
        VStack {
            
            Text ("next BG Check: \(timeStampToLocal_hh_mm_ss(timestamp: self.bloodGlucoseData.nextBloodGlucoseCheckInUnixTimestamp ?? 0))")
            Text ("next Dexcom: \( timeStampToLocal_hh_mm_ss(timestamp:(self.bloodGlucoseData.manySweetnesses.sweetnesses?.last?.startTimestamp ?? 9) + 300) ?? "-")")
        }
        
        
        VStack {
            Text ("Location").foregroundColor(.red) + Text ("BackgroundTask").foregroundColor(.green) + Text ("AppRefresh").foregroundColor(.orange) + Text ("HKObserver").foregroundColor(.blue)
            ScrollView {
                ForEach(bloodGlucoseData.manySweetnesses.sweetnesses?.reversed() ?? [], id: \.id) { sweetness in 
                    HStack {

                        if sweetness.whoRecorded == WhoCalledTheFunction.locationManger {
                            Text(" \(String(format: "%.0f", sweetness.sweetness)) ")
                            .foregroundColor(.red)

                        } else if sweetness.whoRecorded == WhoCalledTheFunction.backgroundTask {
                            Text(" \(String(format: "%.0f", sweetness.sweetness)) ")
                            .foregroundColor(.green)
                            
                        } else  if sweetness.whoRecorded == WhoCalledTheFunction.backgroundRefresh {
                            Text(" \(String(format: "%.0f", sweetness.sweetness)) ")
                                .foregroundColor(.orange)
                            
                        } else if sweetness.whoRecorded == WhoCalledTheFunction.HKObserverQuery {
                            Text(" \(String(format: "%.0f", sweetness.sweetness)) ")
                                .foregroundColor(.blue)
                        }  else
                        {
                            Text(" \(String(format: "%.0f", sweetness.sweetness)) ")
                        }
                     
                        Text (String(sweetness.deBug.startTimestampHumanReadable))
                        
                        Text (timeStampToLocal_hh_mm_ss(timestamp: sweetness.timeRecordedHere ?? -14.00 ))
                        if sweetness.deBug.whoCalledToAddSweetness == .HKObserverQuery {Text("🏥")}
                    }
                }
            }
        }
    }
}


struct CGM_InfoView: View {
    
    @ObservedObject var bloodGlucoseData = BloodGlucoseData.shared
    let diabetes = Diabetes()

    // Unwrap optional samplingSeconds
    var thisSamplingSeconds: Double? {
        bloodGlucoseData.glucoseMonitorModel.currentGlucoseMonitor?.samplingSeconds
    }
    var thisCGM: String? {
        
        bloodGlucoseData.glucoseMonitorModel.currentGlucoseMonitor?.modelName
    }

    var body: some View {
        VStack {
            if let thisSamplingSeconds = thisSamplingSeconds {
                Text ("\(thisCGM!) samples every \(formatSecondsToTimeString(seconds: Int(thisSamplingSeconds), cutOffAt: CutOffAt.minutes))")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
                    .background(Color.clear)
                    .padding()
                    .opacity (0.66)

            }
        }.padding()
        Spacer()
    }
}



















struct CarbStatusView: View {
    @Environment(\.colorScheme) var colorScheme

    @ObservedObject var carbohydrateData = CarbohydrateData.shared
    @State private var lastCarb: Carb?
    
    let diabetes = Diabetes()
    var totalCarbsIn24Hrs: Double = 0
    var body: some View {
        
        
//        GeometryReader { geometry in
            
            VStack {
                
                Divider()
                    .padding(.leading, 100)
                    .padding(.trailing, 100)

                HStack {
                    Spacer()
                    Text("CARB HISTORY")
//                                .foregroundColor(.secondary)
                        .background(Color.clear)
                        .opacity(0.35)
                    Spacer()

                }.padding(.bottom, -2)
//                Text ("HK Permission: \(carbohydrateData.carbHistoryPermissionsNoticeView ? "true" : "False")")

                ScrollView {
                    let carbSum = carbohydrateData.carbs.reduce(0) { (result, carb) -> Int in
                            return result + Int(carb.amount ?? 0)
                        }
                    HStack {
                        Spacer()
                        Text ("-- \(carbSum)g in the past 24 hrs. --")
                            .opacity (0.6)
                            .background(Color.clear)
                     Spacer()
                    }
                    .padding(.bottom, 3)

                        if carbohydrateData.carbs.count == 0 {
                            Text ("There are no carb records in the last 24 hrs. Check Health Data Access.")
                                .opacity (0.75)
                                .background(Color.clear)
                                .padding()
                        }
                        
                        else {
                            VStack{
                                                              
                                ForEach(carbohydrateData.carbs.reversed(), id: \.self) { carb in
                                    HStack {
                                        Spacer()
                                        Text("\(Int(carb.amount ?? 0))g: ")
                                        
                                        if let date = carb.date {
                                            Text(Date().timeIntervalSince(date) > SecondsIn.fourHours.asDouble
                                                 ? "More than \(formatSecondsToTimeString(seconds: (Int(Date().timeIntervalSince(date))), cutOffAt: CutOffAt.hours)) ago."
                                                 : "\(formatSecondsToTimeString(seconds: (Int(Date().timeIntervalSince(date))), cutOffAt: CutOffAt.minutes)) ago."
                                            )
                                        }
                                        Spacer()
                                    }
                                    .opacity (0.75)
                                    .background(Color.clear)
                                    .padding(.bottom, 3)
                                }
                            }
                    }
                }
                .listStyle(.plain)
                .foregroundColor(Color(.label))
                .frame(maxHeight: 150) // Set the max height of the ScrollView here
                
                Divider()
                    .padding(.leading, 100)
                    .padding(.trailing, 100)

            }
//            .frame(height: geometry.size.height / 2)
                .padding()
//        }
        //.padding()
        .onAppear {
            // Load initial data
            self.refreshData()
        }
        .onChange(of: carbohydrateData.carbs) { _ in
            // Update UI when data changes
            self.refreshData()
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
    
    private func refreshData() {
        if let _  = carbohydrateData.carbs.last {
            lastCarb = carbohydrateData.carbs.last
            printTimestamp(description: "carbohydrateData.carbs.las", content: String(carbohydrateData.carbs.last!.amount!), label: "🍕 ")
        }
    }
}








struct NoCarbHistoryPermissionNoticeView: View {
    var body: some View {
        
        SpeechBubble{
            ScrollView {
                
                Image(systemName: "person.crop.circle.badge.exclamationmark.fill")
                    .font(.system(size: 40 ))
                    .foregroundColor(shuggaRed)
                
                Text ("Please grant permission for the app to access your blood glucose data from the Health for it to function correctly. \n\nTo do this, go to the Settings.app, select \"Health,\" then choose Shugga from \"Data Access & Devices\" section. Finally, enable the app to read Blood Glucose data.")
                    .foregroundColor(shuggaRed)
                    .padding([.bottom])
                Text ("Also, You will need at least one blood glucose entry in Health in the past 24 hours for this app to function.")
                    .foregroundColor(shuggaRed)
                    .padding([.bottom])
                Button(action: {
                    if let url = URL(string: "App-Prefs:") {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }) {
                    Text("Open System Settings")
                        .padding()
                        .background(shuggaRed)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                Text("\n\n")
            }
            .overlay(
                LinearGradient(
                    gradient: Gradient(colors: [Color.clear, Color(.white).opacity(0.75)    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 70)
                .padding(.top, -30),
                alignment: .bottom
            )
            .padding()
            
        }.padding()
        
    }
}


struct UserHasNotAgreedToAgreementNoticeView: View {
    
    
    var body: some View {
 
        SpeechBubble {
            VStack {
                HStack {
                    Spacer()
                    Image(systemName: "person.crop.circle.badge.exclamationmark.fill")
                        .font(.system(size: 40 ))
                        .foregroundColor(shuggaRed)
                    Spacer()
                }.padding(.top, 10)
                
                Text (youMustAgreeText)
                    .foregroundColor(shuggaRed)
                
                    .padding()
            }
            .padding()
        }
        .padding()
        Spacer()
        Spacer()
        
        
    }
    
    
}


struct SweetnessesIsEmptyNoticeView: View {
    
    var body: some View {
        
        SpeechBubble {
            VStack {
                HStack {
                    Spacer()
                    Image(systemName: "person.crop.circle.badge.exclamationmark.fill")
                        .font(.system(size: 40 ))
                        .foregroundColor(shuggaRed)
                    Spacer()
                }.padding(.top, 10)
                
                Text ("You need at least one blood glucose entry in Health in the past 24 hours for this app to function.")
                    .foregroundColor(shuggaRed)
                
                    .padding(15)
            }
            .padding()
        }
        .padding()
        Spacer()
        Spacer()
    }
}
    
    
    
struct NoBloodGlucosePermissionNoticeView: View {
    var body: some View {
        
        SpeechBubble{
            ScrollView {
                
                Image(systemName: "person.crop.circle.badge.exclamationmark.fill")
                    .font(.system(size: 40 ))
                    .foregroundColor(shuggaRed)
                
                Text ("Please grant permission for the app to access your blood glucose data from the Health for it to function correctly. \n\nTo do this, go to the Settings.app, select \"Health,\" then choose Shugga from \"Data Access & Devices\" section. Finally, enable the app to read Blood Glucose data.")
                    .foregroundColor(shuggaRed)
                    .padding([.bottom])
                Text ("Also, You will need at least one blood glucose entry in Health in the past 24 hours for this app to function.")
                    .foregroundColor(shuggaRed)
                    .padding([.bottom])
                Button(action: {
                    if let url = URL(string: "App-Prefs:") {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }) {
                    Text("Open System Settings")
                        .padding()
                        .background(shuggaRed)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                Text("\n\n")
            }
            .overlay(
                LinearGradient(
                    gradient: Gradient(colors: [Color.clear, Color(.white).opacity(0.75)    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 70)
                .padding(.top, -30),
                alignment: .bottom
            )
            .padding()
            
        }.padding()
        
    }
}
















struct UnitConversionHelpPopupView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedRow: Int?

    let diabetes = Diabetes()
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 5)
    let numbers = Array(5...1200).filter { $0 % 5 == 0 }
    @State private var backgroundToggle = false

    
    var body: some View {
        
        VStack {
            Text ("Blood Glucose Units Table")
                .font(.title)
//            LazyVGrid(columns: columns) {
            Spacer()

                HStack {
                    Spacer()

                    Text(BloodGlucoseUnit.milligramsPerDeciliter.rawValue)
                        .font(.headline)
                        .lineLimit(1)
                    
              

//                Spacer()
                
                    Spacer()
//                        .padding(0)

                    Text("mmol/L")
                        .font(.headline)
                        .lineLimit(1)
//                        .padding(0)
//                        .frame(alignment: .trailing)
                    Spacer()

                }
                .frame(alignment: .center)
                .padding([.top], 10)
                
             
//            }
            
            
            HStack {
                Text ("\".\" represents a decimal point")
                    .font(.caption2)
                    .padding([.top], 5)

            }
            
            Spacer()

            ScrollView {
                
                LazyVGrid(columns: columns, spacing: 5) {

                    ForEach(numbers.indices, id: \.self) { index in
                        let number = numbers[index]
                        
                        Spacer()
                        
                        HStack {
                            Spacer()
                            Text("\(number)")
                                .frame(alignment: .trailing)
                                .lineLimit(1)
                            Text (" ")
                        }
                        .frame(alignment: .trailing)
                        
                        let mmol = diabetes.mgPerdLTommolPerLiter(mgPerdL: Double(number))
                        let integerPart = Int(mmol)
                        let fractionalPart = String(String(format: "%.1f", mmol).split(separator: ".").last ?? "")
                        
                        HStack {
                            Spacer()
                            Text("\(integerPart).")
                                .lineLimit(1)
                        }
                        .frame(alignment: .trailing)
                        .padding(-5.0)
                        
                        HStack {
                            Text("\(fractionalPart)")
                                .font(Font.system(.body).monospacedDigit())
                                .lineLimit(1)
                            Spacer()
                        }
                        .frame(alignment: .leading)
                        .padding(0)
                        
                        Spacer()
                    }
                }
            }
            
            
            Spacer()
            
            
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Text("Close")
                        .padding(.vertical)
                        .padding(.horizontal, 10)
                        .background(Color.white)
                        .cornerRadius(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.blue, lineWidth: 1)
                        )
                        .minimumScaleFactor(0.5) // Adjust this value as needed
                        .lineLimit(1) // Ensure that the text is limited to a single line
                }
                
            }

            
        }
        .padding()
    }
}


















struct StatusHelpPopupView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Spacer()
            Text ("Shugga Status Symbols Help")
                .padding()
            HStack {
                Image(systemName: "circle.inset.filled")
                    .font(.system(size: 20))
                    .foregroundColor(.primary)
                    .opacity(0.5)
                    .frame(width: 40)
                
                Image(systemName: "bubble.left.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.primary)
                    .opacity(0.5)
                    .frame(width: 40)
                
                Image(systemName:  "text.bubble")
                    .font(.system(size: 20))
                    .foregroundColor(.primary)
                    .opacity(0.5)
                    .frame(width: 40)
                
                Image(systemName:  "speaker.wave.2.bubble.left.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.primary)
                    .opacity(0.5)
                    .frame(width: 40)
                
                Image(systemName: "x.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.primary)
                    .opacity(0.5)
                    .frame(width: 40)
                
                Image(systemName: "drop.circle")
                    .font(.system(size: 20))
                    .foregroundColor(.primary)
                    .opacity(0.5)
                    .frame(width: 40)
                    .foregroundColor(shuggaRed)
                
                Image(systemName: "drop.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.primary)
                    .opacity(0.5)
                    .frame(width: 40)
            }
            .padding()
            
            Spacer()
            Button("OK") {
                dismiss()
            }
        }
    }
}


struct ShuggaStatusInfoView: View {
    
    @ObservedObject var bloodGlucoseData =  BloodGlucoseData.shared

    @ObservedObject var shuggaStatus =  ShuggaStatus.shared
    @State var bloodGlucoseFetchColor: Color =  .primary
    @State var bloodGlucoseFetchingText = ""
    @State var bloodGlucoseFetchingAlpha = 0.5
    @State var glucoseFetchImage = "lasso"
    @ObservedObject var speech = Speech.shared
    @AppStorage("mainBloodGlucoseDisplayFontSize")  public var mainBloodGlucoseDisplayFontSize =    200

    @State private var showingStatusHelpPopup: Bool = false

    
    var body: some View {
        
        VStack {
            HStack {
                HStack {
                    Spacer()
                    
                    
                    
                    
                    
                    
                    Image(systemName: "circle.inset.filled")
                        .font(.system(size: CGFloat(    mainBloodGlucoseDisplayFontSize > 140 ?      Float (mainBloodGlucoseDisplayFontSize)/7.7  :  18 )     ))
                        .foregroundColor(bloodGlucoseFetchColor)
                        .opacity(bloodGlucoseFetchingAlpha)
                        .frame(width: CGFloat(    mainBloodGlucoseDisplayFontSize > 140 ?      (mainBloodGlucoseDisplayFontSize)/7 + 1  :  21 ) )
                        .offset (y: -1)
                    
                    
                    ZStack(alignment: .leading) {
                        Image(systemName: "bubble.left.fill")
                            .font(.system(size: CGFloat(mainBloodGlucoseDisplayFontSize > 140 ? (mainBloodGlucoseDisplayFontSize)/7 : 20)))
                            .opacity(!bloodGlucoseData.theTranslator.currentSugahMeStatus ? 0.0 : (shuggaStatus.shuggaState == .shuggaInProgress  ? 0 : 0.3))
                            .frame(width: CGFloat(mainBloodGlucoseDisplayFontSize > 140 ? (mainBloodGlucoseDisplayFontSize)/7  : 21))
                            .frame ( alignment: .leading)
                        
                        
                        Image(systemName: shuggaStatus.returnAppropriateCurrentlyPlayingShuggaStatusSystemName())
                            .font(.system(size: CGFloat(mainBloodGlucoseDisplayFontSize > 140 ? (mainBloodGlucoseDisplayFontSize)/7 : 20)))
                            .opacity(!bloodGlucoseData.theTranslator.currentSugahMeStatus ? 0.0 : (shuggaStatus.shuggaState == .shuggaInProgress ? 0.75 : 0.0))
                            .frame(width: CGFloat(mainBloodGlucoseDisplayFontSize > 140 ? (mainBloodGlucoseDisplayFontSize)/7: 21))
                            .frame ( alignment: .leading)
                        
                        
                        Image(systemName: "x.circle.fill")
                            .font(.system(size: CGFloat(mainBloodGlucoseDisplayFontSize > 140 ? (mainBloodGlucoseDisplayFontSize)/7 : 20)))
                            .foregroundColor(shuggaRed)
//                            .opacity(bloodGlucoseData.theTranslator.currentSugahMeStatus ? 0.0 : 0.75)
                            .opacity(bloodGlucoseData.theTranslator.currentSugahMeStatus ? 0.0 : bloodGlucoseFetchingAlpha)

                            .frame(width: CGFloat(mainBloodGlucoseDisplayFontSize > 140 ? (mainBloodGlucoseDisplayFontSize)/7: 21))
                            .frame ( alignment: .center)
                            .offset (y: -1)

                    }
                    
                    
                    Image(systemName: bloodGlucoseData.mainViewBloodDropletWarningFlag ? "drop.circle" : "drop.circle.fill")
                        .font(.system(size: CGFloat(    mainBloodGlucoseDisplayFontSize > 140 ?      Float (mainBloodGlucoseDisplayFontSize)/7.7  :  18 )     ))
                        .foregroundColor(bloodGlucoseData.mainViewBloodDropletWarningFlag ? shuggaRed : .primary)
                        .opacity(bloodGlucoseData.mainViewBloodDropletWarningFlag ? 0.75 : 0.3)
                        .frame(width: CGFloat(    mainBloodGlucoseDisplayFontSize > 140 ?      (mainBloodGlucoseDisplayFontSize)/7 + 1  :  21 ) )
                        .offset (y: -1)
                    
                    Spacer()
                }
                .frame(height: CGFloat(    mainBloodGlucoseDisplayFontSize > 140 ?      (mainBloodGlucoseDisplayFontSize)/7 :  21 ) )
                .frame(minWidth: 0, maxWidth: .infinity)
                
                .onTapGesture {
                    showingStatusHelpPopup = true
                    
                    // Automatically dismiss after 1 minute.
                    DispatchQueue.main.asyncAfter(deadline: .now() + 60) {
                        showingStatusHelpPopup = false
                    }
                }
                .sheet(isPresented: $showingStatusHelpPopup) {
                    StatusHelpPopupView()
                }
                
            }
//            .opacity (0.75)
            
            HStack {
                Spacer()
                Text("Audio Port Type: ")
                    .opacity (0.4)
                Text ("\(speech.currentAudioPortType ?? "Unknown")")
                    .opacity (0.6)
                Spacer()
            }
        }
        
        .onReceive(shuggaStatus.$bloodGlucoseFetchState, perform: { state in
            if state == .fetchingBloodGlucose {
                bloodGlucoseFetchColor = shuggaRed
                withAnimation(.easeIn(duration: 0.35)) {
                    bloodGlucoseFetchingAlpha = 0.75
                }
                //glucoseFetchImage = "lasso.and.sparkles"
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                    bloodGlucoseFetchColor = .primary
                    withAnimation(.easeIn(duration: 0.35)) {
                        bloodGlucoseFetchingAlpha = 0.3
                    }
                    //glucoseFetchImage = "lasso" // Reset the image back to "lasso" after 1 second
                }
            }
        })
    }
}


/*
 
 
 if false {
     HStack {        Image(systemName: shuggaStatus.shuggaState == .queryResultedInEmptyResult ? "0.square.fill" : "square.fill")
             .font(.system(size: CGFloat(    mainBloodGlucoseDisplayFontSize > 140 ?      (mainBloodGlucoseDisplayFontSize)/7  :  20 )     ))
         
         Image(systemName: shuggaStatus.shuggaState == .encounteredErrorWhileFetchingBloodGlucose ? "person.crop.circle.badge.exclamationmark.fill" : "s.circle.fill")
             .font(.system(size: CGFloat(    mainBloodGlucoseDisplayFontSize > 140 ?      (mainBloodGlucoseDisplayFontSize)/7  :  20 )     ))
     }
 }
 
 
 */









struct NoBloodGlucoseDataWarningView: View {
    
    @AppStorage("elapsedTimeWarningDisplayFontSize")              public var elapsedTimeWarningDisplayFontSize: Int =                12

    var body: some View {
        
        VStack {
            Image(systemName: "exclamationmark.triangle.fill")
            // .resizable()
                .font(.title)
                .foregroundColor(.red)
            //                                        .padding()
            
            ScrollView{
            
            VStack {
                Text (noHealthKitNotice)
                    .foregroundColor(.gray)
                //                                        .font(.system(size: 12, weight: .bold, design: .default))
                // .font(.headline)
                //                                        .padding()
                Image("sugar.healthpermission.top")
                    .resizable()
                    .scaledToFit()
                
                    //.frame(width: 220)
                
            }
        }
            
            //   HowToTurnHealthKitOnView
            
        }
        .padding(20)
        .background (.white)
        .cornerRadius(12)
        .padding(40)
        
    }
}

struct SheetView: View {
    
    @Environment(\.dismiss) var dismissSheet
    var body: some View {
        Button("Press to dismiss") {
            dismissSheet()
        }
        .font(.title)
        .padding()
        .background(.black)
    }
}


// ====================== device orientation ==================== 👇

// PAUL HUDSON
// Our custom view modifier to track rotation and
// call our action
struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void
    
    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}

// A View wrapper to make the modifier easier to use
extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}

// PAUL HUDSON
// ====================== device orientation ====================　👆


struct HowToTurnHealthKitOnView: View {
    
    var body: some View {
        
        ScrollView(.horizontal) {
            HStack {
                
                Image("dataAccess1")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 333)
                
                Image(systemName: "arrow.forward")
                
                Image("dataAccess2")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 333)
                
                Image(systemName: "arrow.forward")
                
                Image("dataAccess3")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 333)
                
                Image(systemName: "arrow.forward")
                
                Image("dataAccess4")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 333)
                
                Image(systemName: "arrow.forward")
                
                Image("dataAccess5")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 333)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity/4)
            .padding(20)
        }
    }
}



struct LockButtonView: View {
    
    @Binding var theMainViewIsLocked: Bool
    @Binding var theShuggaIsPaused: Bool

    @AppStorage("showLockButton") public var showLockButton = false

    var body: some View {
        
        SlidingUnlockButton(theMainViewIsLocked: $theMainViewIsLocked, theShuggaIsPaused: $theShuggaIsPaused)
                        
    }
}



struct MainGlucoseDisplayView: View {
    
    @AppStorage("userAgreedToAgreement")                 public var userAgreedToAgreement =  false
    @AppStorage("whiteBackground")                  public var whiteBackground =                    false
    @ObservedObject var bloodGlucoseData =  BloodGlucoseData.shared
    @AppStorage("displayBothUnits")                   public var displayBothUnits =                        false

    @Binding var bloodGlucoseValueTextColor: Color
    @Binding var orientation: UIDeviceOrientation
    @Binding var userBloodGlucoseUnit: BloodGlucoseUnit
    @Binding var mainBloodGlucoseDisplayFontSize: Int
    @Binding var demoMode: Bool
    
    @Binding var dataTooOldPeriod_min: Int
    
    @State private var showingUnitConverionHelpPopup: Bool = false

    
    let skipHundredth: Bool
  //  let theDataIsTooOld: Bool
    
    /// <#Description#>
    var body: some View {
        
        let timeSinceUpdateInSeconds = Int(Date().timeIntervalSince1970) - Int(bloodGlucoseData.manySweetnesses.sweetnesses?.last?.startTimestamp ?? 0.0)
        
        let theLastUpdate = elapsedTimeFormatter(timeSinceUpdateInSeconds: timeSinceUpdateInSeconds, recordingDevice: bloodGlucoseData.manySweetnesses.sweetnesses?.last?.manufacturer ?? "", language: "English", demoMode: demoMode)
        
        if timeSinceUpdateInSeconds > Int(dataTooOldPeriod_min / SecondsIn.oneMinute.rawValue) {
          let   theDataIsTooOld = true
        }
        else
        {
         let   theDataIsTooOld = false

        }
        
        VStack {
            if demoMode {
                if userBloodGlucoseUnit == BloodGlucoseUnit.milligramsPerDeciliter {
                    Text ("\(demoValue_mgPerdl)")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .font(Font.system(size: CGFloat(mainBloodGlucoseDisplayFontSize), weight: .bold,design: .rounded))
                        .foregroundColor(bloodGlucoseValueTextColor)//.background(.red)
                        .lineLimit(1)
                        .minimumScaleFactor(((orientation.isPortrait) || (!orientation.isPortrait && !orientation.isLandscape)) ? 0.9 : 0.9)
                        .accessibilityLabel(_: "This is the last available blood glucose value from your Apple Health data.")
                }
                
                else
                
                {
                    Text ("\(demoValue_mmolPerLiter)")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .font(Font.system(size: CGFloat(mainBloodGlucoseDisplayFontSize), weight: .bold, design: .rounded))
                        .foregroundColor(bloodGlucoseValueTextColor)//.background(.red)
                        .lineLimit(1)
                        .minimumScaleFactor(((orientation.isPortrait) || (!orientation.isPortrait && !orientation.isLandscape)) ? 0.9 : 0.9)
                        .accessibilityLabel(_: "This is the last available blood glucose value from your Apple Health data.")
                }
            }
            
            
            else if /* bloodGlucoseData.theHealthKitIsAvailableOnThisDevice && */ userAgreedToAgreement { // not demo mode
                
                
                if bloodGlucoseData.userApprovedHealthKitBloodGlucose_Read == false {
                 
                    NoBloodGlucosePermissionNoticeView()
                        .padding()
                }
                else
                if bloodGlucoseData.manySweetnesses.sweetnesses?.last?.sweetness ?? -99 < 0 {
                    SweetnessesIsEmptyNoticeView()
                   
                    
                }
                
                else {
                    
                    let almostCompleteValueInString = returnCorrectValueForUnit_string(rawValue : bloodGlucoseData.manySweetnesses.sweetnesses?.last?.sweetness ?? -0.5, userBloodGlucoseUnit : userBloodGlucoseUnit.rawValue, skipHundredth: skipHundredth)
                    
                    let completeValueInString_noSpace = almostCompleteValueInString.replacingOccurrences(of: " ", with: "")
                    let completeValueInString = completeValueInString_noSpace.replacingOccurrences(of: "O", with: "0")
                    
                    Text(completeValueInString) // this is the blood glucose
                        .frame(maxWidth: .infinity, alignment: .center)
                        .font(Font.system(size: CGFloat(mainBloodGlucoseDisplayFontSize), weight: .bold,design: .rounded))
                        .foregroundColor( (timeSinceUpdateInSeconds > dataTooOldPeriod_min * SecondsIn.oneMinute.rawValue) ? shuggaRed : bloodGlucoseValueTextColor )//.background(.red)
                        .opacity(whiteBackground ? 1.0 : 0.9)

                        .allowsTightening(false) // Disable automatic scaling
                    //.foregroundColor(bloodGlucoseValueTextColor)//.background(.red)
                        .lineLimit(1)
                        .minimumScaleFactor(((orientation.isPortrait) || (!orientation.isPortrait && !orientation.isLandscape)) ? 0.7 : 0.7)
                        .accessibilityLabel(_: "This is your last blood glucose value recorded in Apple Health.")
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding([.leading, .trailing, .top], 10)
        .overlay (VStack {
            Text (demoMode ? " Demo Value " : "")
                .foregroundColor(.white)
            //.frame (alignment: .leading)unit
            
                .font(.title)
            
                .background(shuggaRed)
                .cornerRadius(5)
            
            //.offset(x: 0, y: -50)
                .rotationEffect(Angle(degrees: -10))
                .opacity(0.7)
                .shadow(color: Color.indigo.opacity(0.25),
                        radius: 4,
                        x: 1.5,
                        y: 1.5)
                .shadow(color: Color.black.opacity(0.9),
                        radius: 4,
                        x: 1.5,
                        y: 1.5)
        }
        )
        
        
        
        if bloodGlucoseData.userApprovedHealthKitBloodGlucose_Read == true {
            
            
            VStack {
                Text(userBloodGlucoseUnit.rawValue)
                    .opacity(whiteBackground ? 1.0 : 0.4)

                    .accessibilityLabel(_: "This is the unit currently selected in this app for your blood glucose measurements.")
            }
            
            Spacer()

            if displayBothUnits {
//                Spacer()
                
                
                if let currentBloodGlucoseInmgdL = bloodGlucoseData.manySweetnesses.sweetnesses?.last?.sweetness
                {
                    //showingUnitConverionHelpPopup
                    HStack {
                        if userBloodGlucoseUnit == .milligramsPerDeciliter
                        {
                            Text(returnCorrectValueForUnit_string(rawValue : currentBloodGlucoseInmgdL, userBloodGlucoseUnit : BloodGlucoseUnit.millimolesPerLiter.rawValue, skipHundredth: false))
                            Text (" \(BloodGlucoseUnit.millimolesPerLiter.rawValue)")
                        }
                        if userBloodGlucoseUnit == .millimolesPerLiter
                        {

                            // let sWithoutSpaces = s.replacingOccurrences(of: " ", with: "")
                            Text(returnCorrectValueForUnit_string(rawValue : currentBloodGlucoseInmgdL, userBloodGlucoseUnit : BloodGlucoseUnit.milligramsPerDeciliter.rawValue, skipHundredth: skipHundredth).replacingOccurrences(of: " ", with: "")) // eg: "1 46" to "146" for skip hundred
                            Text (" \(BloodGlucoseUnit.milligramsPerDeciliter.rawValue)")
                        }
                    }
                    .opacity(whiteBackground ? 1.0 : 0.4)
                    .padding()
                    .onTapGesture {
                        showingUnitConverionHelpPopup = true
                           }
                    .sheet(isPresented: $showingUnitConverionHelpPopup) {
                        // Your pop up content here.
                        UnitConversionHelpPopupView()
                    }
                }
               
                
                
                
                
            }
            
            
            VStack {
                
                if (timeSinceUpdateInSeconds > Int(dataTooOldPeriod_min *  SecondsIn.oneMinute.rawValue)) {
                    
                
                    Text ("Entry by \(theLastUpdate)")
                        .font(.subheadline)
                        .foregroundColor(shuggaRed)
                        .padding([.bottom], 12)
                } else
                { Text ("Entry by \(theLastUpdate)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding()
                        .multilineTextAlignment(.center)
                }
            }.padding()
            
        }
        
        

        
    }
}



struct TopMenuView: View {
    
//    @EnvironmentObject var theAvailableLanguages:   TheAppVoices
//    @EnvironmentObject var theTranslator:           TheTranslator
//    @EnvironmentObject var thePlayer:               TTS
    @AppStorage("theMainViewIsLocked")  public var theMainViewIsLocked =    true
    @AppStorage("theShuggaIsPaused")    public var theShuggaIsPaused =      true
    @AppStorage("pauseNow")                   public var pauseNow =                     false
    @AppStorage("whiteBackground")                  public var whiteBackground =                    false

    @Binding var grayAppIcon: Bool
    @Binding var settingsSymbol: Image
    @Binding var navigationImageSize: CGFloat
    
    @Binding var userAgreedToAgreement: Bool
    @Binding var orientation: UIDeviceOrientation
    
    @Binding var theHealthKitIsAvailableOnThisDevice: Bool
    
//    var logoFileName: String
    
 
    @Environment(\.colorScheme) var colorScheme

    
    var body: some View {
        Spacer()
        HStack {
            
            if theMainViewIsLocked {
                VStack {
                        
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(.gray)
                            .font(.system(size: 30))
                            .opacity(whiteBackground ? 1.0 : 0.4)
                        //.padding([.top, .leading, .trailing], 10)
                            .accessibilityLabel(_: "This gray question mark button takes you to the about page.")
                    
                }
                .frame (width: 75)
                .padding([.leading, .trailing], 5)

            }
            else
            {
                
                VStack {
                    NavigationLink(destination: HubView()) {
                        
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(.gray)
                            .font(.system(size: 30))
                            .opacity(whiteBackground ? 1.0 : 0.4)
                        //.padding([.top, .leading, .trailing], 10)
                            .accessibilityLabel(_: "This gray question mark button takes you to the about page.")
                    }
                }
                .frame (width: 75)
                .padding([.leading, .trailing], 5)

            }
          
            Spacer()
            
            VStack {
                
                if theMainViewIsLocked {
                    ZStack {
                        Image (grayAppIcon ? "logo 3 monochrome" : "logo 3")
                            .resizable()
                            .scaledToFit()
                            .frame(width: navigationImageSize, height: navigationImageSize)
                            .shadow(color:  Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: itemShadowOpacity)), radius: itemShadowRadius, x: itemShadowOffsetX, y: itemShadowOffsetY)
                    }
                    
                } else
                {
                    
                    NavigationLink(destination: SettingsView(theMainViewIsLocked: $theMainViewIsLocked, theShuggaIsPaused: $theShuggaIsPaused)
                                   //                        .environmentObject(theAvailableLanguages)
                                   //                        .environmentObject(theTranslator)
                                   //                        .environmentObject(thePlayer)
                    ) {
                        
                        
                        Image (grayAppIcon ? "logo 3 monochrome" : "logo 3")
                            .resizable()
                            .scaledToFit()
                            .frame(width: navigationImageSize, height: navigationImageSize)
                            .shadow(color:  Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: itemShadowOpacity)), radius: itemShadowRadius, x: itemShadowOffsetX, y: itemShadowOffsetY)
                    }
                }
                
            }
            .frame (width: 75)

            .accessibilityLabel(_: "This button takes you to the About Page of this app. If you press this button, you will be directed to the settings menu.")
            .padding([.leading, .trailing], 5)

            Spacer()

            VStack {
                
                
                if theMainViewIsLocked {
                    
                    
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(.gray)
                            .font(.system(size: 30))
                            .opacity(whiteBackground ? 1.0 : 0.4)
                        // .frame(width: 50, height: 50)
                        //.padding([.top, .leading, .trailing], 10)
                            .accessibilityLabel(_: "This is a gray gear button. This also takes you to the settings.")
                }
                else
                    
                {
                    
                    
                    NavigationLink(destination: SettingsView(theMainViewIsLocked: $theMainViewIsLocked, theShuggaIsPaused: $theShuggaIsPaused)
                                   //                    .environmentObject(theAvailableLanguages)
                                   //                    .environmentObject(theTranslator)
                                   //                    .environmentObject(thePlayer)
                                   
                    )  {
                        
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(.gray)
                            .font(.system(size: 30))
                            .opacity(whiteBackground ? 1.0 : 0.4)
                        // .frame(width: 50, height: 50)
                        //.padding([.top, .leading, .trailing], 10)
                            .accessibilityLabel(_: "This is a gray gear button. This also takes you to the settings.")
                        
                    }
                    
                }
                
                
                
                
                
                
//                .environmentObject(theAvailableLanguages)

            }
            .frame (width: 75)
            .padding([.leading, .trailing], 5)

           }
        
        .padding([.top], 10)
        .padding([.leading], 31)
        .padding([.trailing], 31)
        Spacer()
        //        .border(.blue)
//        .environmentObject(theAvailableLanguages)
    }
}








struct BetaExpirationView: View {
    
    var body: some View {
        VStack {
            Image ("logo 3")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
               // .shadow(color:  Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: itemShadowOpacity)), radius: itemShadowRadius, x: itemShadowOffsetX, y: itemShadowOffsetY)
            
            Text ("The app's beta test period has expired. \nThank you for testing the app :)")
                .foregroundColor(.red)
                .lineLimit(3)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
                .font(.system(size: 15, weight: .bold, design: .default))
    }
    }
}














