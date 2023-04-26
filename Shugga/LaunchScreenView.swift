//
//  launch.screen.swift
//  Shugga
//
//  Created by Rodi on 4/12/23.
//

import SwiftUI




import Combine

class AppLaunchState: ObservableObject {
    @Published var isLaunchScreenDisplayed: Bool = true
    
    private var cancellable: AnyCancellable?
    
    init() {
        startCountdown()
    }
    
    private func startCountdown() {
        cancellable = Future<Void, Never> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                promise(.success(()))
            }
        }
        .sink { [weak self] in
            self?.isLaunchScreenDisplayed = false
        }
    }
}



struct LaunchScreen: View {
    var body: some View {
        Spacer()
        VStack {
            Image("logo 3")
                .resizable()
                .scaledToFit()
                .frame (width: 200)
            // Add any additional elements you want to display on the launch screen here
        }
        .padding()
        .background(Color.white.edgesIgnoringSafeArea(.all))
        Spacer()
        Spacer()
        
        
    }
}

struct LaunchScreen_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreen()
    }
}
