//
//  ConsoleFunctions.swift
//  sugah
//
//  Created by Rodi on 1/21/23.
//

import Foundation
import BackgroundTasks

let zeroTimestamp: Double = 28800 // amount of seconds needed to make hh:mm:ss into 00:00:00 for 1970 timestamp (technically the midnight of 1/2/1970

func printTimestamp(description: String = "", content: String = "", label: String = "-",  object: Any? = nil, passedError: Error? = nil) {
    var errorLabel = ""
    if passedError != nil { errorLabel = " ERROR "}
    
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm:ss"
    let currentTime = formatter.string(from: date)
    
    
    var repeatedLabel = label
    let forLoopEndingNumber = Int(22 / label.count )
    for _ in 0...forLoopEndingNumber {
        repeatedLabel = repeatedLabel + label
    }
    
    print ("")
    
    print (" \(repeatedLabel) : \(description) \(errorLabel) +")
    
    print (" t    \(currentTime)")
    
    if passedError != nil {
        print (" e    \(passedError!)")
            }
    
    if object != nil {
        if passedError != nil {
            print ("")
        }
        print (" o    \(object!)")
    }
    
    if content != "" {
        if object != nil {
            print ("")
        }
        print (" c    \(content)")
    }
    print (" \(repeatedLabel) : \(description) \(errorLabel) -")
    print ("")
    

}









// ####################################################################################################################
