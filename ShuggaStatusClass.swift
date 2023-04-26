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
}
