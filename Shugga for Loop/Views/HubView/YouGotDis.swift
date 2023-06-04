import SwiftUI
import AVFoundation

class AudioPlayerDelegate: NSObject, AVAudioPlayerDelegate {
    var audioPlayer: AVAudioPlayer? {
        didSet {
            audioPlayer?.delegate = self
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            audioPlayer = nil
        }
    }
}

struct YouGotDis: View {
    
    @State private var audioPlayer: AVAudioPlayer?
    @State private var errorMessage: String = ""
    @State private var isPopupVisible: Bool = false
    
    private var audioPlayerDelegate = AudioPlayerDelegate()
    
    var body: some View {
        VStack {

            Button(action: {
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
                    audioPlayerDelegate.audioPlayer = audioPlayer
                    audioPlayer?.prepareToPlay()
                    print("Audio player is ready to play.")
                    audioPlayer?.play()
                } catch {
                    errorMessage = "Could not load audio file"
                }
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 22)
                        .fill(Color.gray)
                        .frame(width: 100, height: 100)
                        .shadow(color: Color.black.opacity(0.5), radius: 4, x: -2, y: 3)
                    
                    Image("buttonImage")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 90, height: 90)
                        .clipShape(RoundedRectangle(cornerRadius: 22))
                }
            }

            if errorMessage != "" {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            }
        }
    }
}

struct YouGotDis_Previews: PreviewProvider {
    static var previews: some View {
        YouGotDis()
    }
}
