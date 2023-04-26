//
//  Enums.Errors.swift
//  Shugga
//
//  Created by Rodi on 3/10/23.
//

import Foundation


enum GlucoseMonitorError: Error {
    case noMatchingGlucoseMonitorShortName(modelShortName: String)
    case noMatchingGlucoseMonitorFDA_ID(modelShortName: String)
    case invalidInput
}


enum SpeechError: Error {
    case invalidLanguageCode
    case voiceNotFound
    case unknown
    case synthesizerBusy
    case shuggaPaused
}


enum BloodGlucoseError: Error {
    case fetchError(Error)
    case speechError(Error)
    case userPermissionNotGranted
    case unknownError
}
