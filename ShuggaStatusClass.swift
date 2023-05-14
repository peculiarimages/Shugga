//
//  ShuggaStatusClass.swift
//  Shugga
//
//  Created by Rodi on 3/22/23.
//

import Foundation
import SwiftUI

class ShuggaStatus: ObservableObject {
    
    static let shared = ShuggaStatus()

    @Published var theAppState: TheAppState = .appStarted

    @Published var bloodGlucoseFetchState: TheAppState = .appStarted
    
    @Published var shuggaState: TheAppState = .appStarted
    
    
    
    private init() {}
    
    let defaultImageName =      "speaker.wave.2.bubble.left.fill"
    let alternateImageName =    "text.bubble"
    
    func returnAppropriateCurrentlyPlayingShuggaStatusSystemName() -> String {
        if UIImage(systemName: defaultImageName) != nil { return (defaultImageName) }
        return (alternateImageName)

    }
}
