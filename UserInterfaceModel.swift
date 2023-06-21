//
//  UserInterfaceModel.swift
//  Shugga
//
//  Created by Rodi on 4/2/23.
//

import Foundation
import UIKit
import SwiftUI
import CoreHaptics
import PDFKit
import CoreImage
import CoreImage.CIFilterBuiltins








func triggerHaptic(binaryPattern: String, timeUnit: TimeInterval) {
    let theTimeUni = timeUnit / 100
    let hapticEngine: CHHapticEngine?
    let hapticPattern: CHHapticPattern?

    do {
        hapticEngine = try CHHapticEngine()
    } catch {
        print("Failed to create haptic engine: \(error.localizedDescription)")
        return
    }

    var events: [CHHapticEvent] = []
    for (index, char) in binaryPattern.enumerated() {
        if char == "1" {
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [], relativeTime: theTimeUni * Double(index))
            events.append(event)
        }
    }

    do {
        hapticPattern = try CHHapticPattern(events: events, parameterCurves: [])
    } catch {
        print("Failed to create haptic pattern: \(error.localizedDescription)")
        return
    }

    do {
        try hapticEngine?.start()
    } catch {
        print("Failed to start haptic engine: \(error.localizedDescription)")
        return
    }

    let player: CHHapticAdvancedPatternPlayer

    do {
        guard let hapticPattern = hapticPattern, let hapticPlayer = try hapticEngine?.makeAdvancedPlayer(with: hapticPattern) as? CHHapticAdvancedPatternPlayer else {
            print("Failed to create haptic player")
            return
        }
        player = hapticPlayer
    } catch {
        print("Failed to create haptic player: \(error.localizedDescription)")
        return
    }

    do {
        try player.start(atTime: CHHapticTimeImmediate)
        DispatchQueue.main.asyncAfter(deadline: .now() + theTimeUni * Double(binaryPattern.count)) {
            hapticEngine?.stop()
        }
    } catch {
        print("Failed to play haptic pattern: \(error.localizedDescription)")
        return
    }
}




func isAppInBackground(completion: @escaping (Bool) -> Void) {
    DispatchQueue.main.async {
        let state = UIApplication.shared.applicationState
        if state == .background || state == .inactive {
            completion(true)
        } else if state == .active {
            completion(false)
        } else {
            // If the state is unknown, assume it's in the background
            completion(true)
        }
    }
}




struct SpeechBubble<Content: View>: View {
    let content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            content()
        }
        .padding(EdgeInsets(top: 22, leading: 22, bottom: 22, trailing: 22))
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color(.systemBackground)) // Apply the color directly to the RoundedRectangle
                .shadow(color: Color(.black).opacity(0.4), radius: 8, x: 0, y: 2)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                )
        )
        .background(Color(.systemBackground)) // Use system primary color
        .offset(x: 0, y: -5)
    }
}






struct ScrollOverlayOnTheBottom: ViewModifier {
    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    gradient: Gradient(colors: [Color.clear, Color(.systemBackground).opacity(1.0)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 150)
                .padding(.top, -30),
                alignment: .bottom
            )
    }
}


struct SlidingUnlockButton: View {
    
    @ObservedObject var bloodGlucoseData = BloodGlucoseData.shared

    @State private var dragOffset = CGSize.zero
    @State private var isUnlocked = false
    
    @State private var grayRectangleWidth: CGFloat = 0
    
    @State private var originalSlideText = true
    @State private var grayRectangleColor: Color = Color.gray.opacity(0.4) // Add this new state property
    
    @State private var sliderInLockPosition = true
    @AppStorage("showLockButton") public var showLockButton = false
    @AppStorage("pauseNow")                   public var pauseNow =                     false

    @Binding var theMainViewIsLocked: Bool
    @Binding var theShuggaIsPaused: Bool
    
    @AppStorage("as_pauseStartTime") public var as_pauseStartTime: Double = 0
    @AppStorage("as_pauseDuration") public var as_pauseDuration: TimeInterval = 0
    @AppStorage("pauseForX_min")                   public var pauseForX_min =                     pauseShuggaDefault_min

    
    let theHeight = 60.0
    var onUnlock: () -> Void = {} // Closure to be called when the slider is unlocked

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
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(grayRectangleColor) // Use grayRectangleColor state property
                            .frame(width: geometry.size.width - 32, height: theHeight + 18)
                            .opacity (0.8)
                            .overlay(
                                  RoundedRectangle(cornerRadius: 12)
                                      .stroke(Color.primary, lineWidth: 2) // Set the border color and width
                                    .opacity (0.2)
                              )
                    
                    Text( (sliderInLockPosition && theMainViewIsLocked ) ? "Slide to unlock help and settings buttons" : (sliderInLockPosition && theShuggaIsPaused) ? "Shugga is paused for \(remainingTimeFormatted) \nSlide to resume" :    (  theMainViewIsLocked ?   "Release to unlock settings" : "Release to resume Shugga")     )
                            .font(.system(size: 18))
                            .foregroundColor(.primary)
                            .frame(width: geometry.size.width - 32  - (theHeight * 3))
                            .minimumScaleFactor(0.5)
                            .opacity (0.9)
                            .padding()
                }
                
                ZStack { // Encapsulate RoundedRectangle and Image in a new ZStack
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(sliderInLockPosition ? Color.gray : shuggaRed)
                            .frame(width: theHeight, height: theHeight + 5)
                            .overlay(
                                  RoundedRectangle(cornerRadius: 12)
                                      .stroke(Color.primary, lineWidth: 1) // Set the border color and width
                                    .opacity (0.2)
                              )
                        Image(systemName: "arrowshape.right") // Add your desired system image
                            .foregroundColor(.white) // Set the color of the image
                }
                    .offset(x: dragOffset.width - (geometry.size.width)/2 + theHeight - 5)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let offsetX = value.translation.width
                                let threshold: CGFloat = (geometry.size.width - (2 * theHeight)) + 10
                                
                                if offsetX > 0 && offsetX <  threshold {
                                    dragOffset.width = offsetX
                                    
                                    if dragOffset.width > threshold - theHeight/2 {
                                        withAnimation {
                                            
                                            sliderInLockPosition = false
                                        }
                                    }
                                    else {
                                        withAnimation {
                                            
                                            sliderInLockPosition = true
                                        }
                                    }
                                }
                            }
                            .onEnded { value in
                                let threshold: CGFloat = geometry.size.width - (2 * theHeight) - 16 + 10
                                
                                if dragOffset.width > threshold {
                                    isUnlocked = true
                                    showLockButton = false
                                    if theMainViewIsLocked { theMainViewIsLocked = false }
                                    if pauseNow {
                                        pauseNow   = false
                                        as_pauseDuration = 0
                                        as_pauseStartTime = 0
                                    }
                                    onUnlock()

                                    let feedbackGenerator = UINotificationFeedbackGenerator()
                                    feedbackGenerator.notificationOccurred(.error)
                                } else {
                                    withAnimation {
                                        dragOffset = CGSize.zero
                                        sliderInLockPosition = true
                                    }
                                }
                            }
                    )
                    .animation(.interactiveSpring(), value: dragOffset)
            }
            }
            .padding()
            .opacity(isUnlocked ? 0 : 1)

            .onAppear {
                grayRectangleWidth = geometry.size.width - 32
            }
            .onAppear {
                grayRectangleWidth = geometry.size.width - 32
                
                // Add the following code for timed color change
                withAnimation(.easeInOut(duration: 1)) {
                    grayRectangleColor =  shuggaRed
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation(.easeInOut(duration: 1)) {
                        grayRectangleColor = Color.gray.opacity(0.4)
                    }
                }
            }
        }
    }
}










struct ValueSlider: ViewModifier {
    @Binding var value: Double
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    let thumbSize = geometry.size.width * 0.1
                    let font = UIFont.preferredFont(forTextStyle: .caption1)
                    let scaledFontSize = font.pointSize * 0.85 
                    let scaledFont = font.withSize(scaledFontSize)
                    let thumbText = String(format: "%.0f", value * 100)
                    let thumbPosition = (geometry.size.width - thumbSize) * CGFloat(value) + thumbSize / 2
                    
                    ZStack {
                        Text(thumbText)
                            .foregroundColor(.primary)
                            .font(.init(scaledFont))
                            .background(Color.clear)
                            .opacity(0.75)
                            .frame(width: thumbSize, height: thumbSize)
                            .offset(x: thumbPosition - thumbSize / 2)
                            .animation(.none, value: value)
                            .allowsHitTesting(false) // Ignore touches on the Text view
                    }
                }
            )
    }
}


extension String {
    func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size
    }
}


extension View {
    func valueSlider(value: Binding<Double>) -> some View {
        return self.modifier(ValueSlider(value: value))
    }
}
