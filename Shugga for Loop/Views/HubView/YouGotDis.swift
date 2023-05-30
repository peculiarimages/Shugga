//
//  YouGotDis.swift
//  Shugga
//
//  Created by Rodi on 5/30/23.
//

import SwiftUI
import AVFoundation

struct YouGotDis: View {
    
    @State private var audioPlayer: AVAudioPlayer?
    @State private var errorMessage: String = ""
    @State private var isPopupVisible: Bool = false
    
    var body: some View {
        VStack {
//            Spacer()

            Button(action: {
                if let player = self.audioPlayer {
                    if player.isPlaying {
                        print("Audio is already playing.")
                    } else {
                        player.play()
                        if player.isPlaying {
                            print("Audio started playing successfully.")
                        } else {
                            errorMessage = "Audio could not be played."
                        }
                    }
                } else {
                    errorMessage = "Audio player is not initialized."
                }
            }) {
                ZStack {
                        RoundedRectangle(cornerRadius: 22)
                            .fill(Color.clear)
                            .frame(width: 100, height: 100)
                            .shadow(color: Color.black.opacity(0.8), radius: 4, x: -3, y: 4)
                            .shadow(color: Color.black.opacity(0.8), radius: 4, x: 2, y: 2)
                     
                    
                    Image("buttonImage")
                                   .resizable()
                                   .aspectRatio(contentMode: .fit)
                                   .frame(width: 90, height: 90)
                                   .clipShape(RoundedRectangle(cornerRadius: 22))
                    }
                
            }
            
//            Text("Kiyoshi")
//                .opacity(0.35)
//                .padding()
            
            if errorMessage != "" {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            }
//            
//            Spacer()
//            
//            Button(action: {
//                isPopupVisible = true
//            }) {
//                Image(systemName: "questionmark.circle.fill")
//                    .font(.system(size: 24))
//                    .foregroundColor(.gray)
//                    .opacity(0.50)
//                    .padding()
//                    
//            }
        }
        .onAppear {
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)
            } catch {
                print("Failed to set up audio session: \(error)")
            }
            
            guard let sound = Bundle.main.path(forResource: "audio", ofType: "mp3") else {
                errorMessage = "Could not find audio file"
                return
            }

            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound))
                audioPlayer?.prepareToPlay()
                print("Audio player is ready to play.")
            } catch {
                errorMessage = "Could not load audio file"
            }
        }
       
        
    }
}

struct YouGotDis_Previews: PreviewProvider {
    static var previews: some View {
        YouGotDis()
    }
}
