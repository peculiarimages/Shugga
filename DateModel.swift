//
//  DateModel.swift
//  Shugga
//
//  Created by Rodi on 3/2/23.
//

import Foundation


enum CutOffAt {
    case hours
    case minutes
    case none
}

func formatSecondsToTimeString(seconds: Int, cutOffAt: CutOffAt, language: String = "en") -> String {
    let hours = seconds / 3600
    let minutes = (seconds % 3600) / 60
    let remainingSeconds = seconds % 60

    var formattedDuration: [String] = []

    
    
    
    switch language {
        
        
    case "ja":
        
        if hours > 0 {
            formattedDuration.append("\(hours)時間")
        }
        
        if cutOffAt != .hours && minutes > 0 {
            formattedDuration.append("\(minutes)分")
        }
        
        if cutOffAt == .none && remainingSeconds > 0 {
            formattedDuration.append("\(remainingSeconds)秒")
        }

        return formattedDuration.joined(separator: "と")
        
        
    default:
        
        if hours > 0 {
            formattedDuration.append("\(hours) \(hours == 1 ? "hour" : "hours")")
        }
        
        if cutOffAt != .hours && minutes > 0 {
            formattedDuration.append("\(minutes) \(minutes == 1 ? "minute" : "minutes")")
        }
        
        if cutOffAt == .none && remainingSeconds > 0 {
            formattedDuration.append("\(remainingSeconds) \(remainingSeconds == 1 ? "second" : "seconds")")
        }

        return formattedDuration.joined(separator: " and ")
        
        
        
    }
    
   
    
    
    
    
    
    
    
}




// ####################################################################################################################


func formatTime_HH_mm_ss_Spaces(_ date: Date = Date()) -> String {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH mm ss"
    return dateFormatter.string(from: date)
}
// ####################################################################################################################

func formatTime_HH_mm_ss(_ date: Date = Date()) -> String {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm:ss"
    return dateFormatter.string(from: date)
}
// ####################################################################################################################


func timeStampToLocal_hh_mm_ss (timestamp: Double) -> String {
    
    
    let date = Date(timeIntervalSince1970: timestamp)

    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm:ss" // set the desired format
    formatter.timeZone = TimeZone.current // set the time zone to the device's current time zone

    let localTimeString = formatter.string(from: date)
   // print(localTimeString)
    
    
    
    return localTimeString
    
    
}
// ####################################################################################################################



func dateStringToLocalDateString (dateString: String) -> String {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
    let date = dateFormatter.date(from: dateString)!

    // Set the time zone to the system's local time zone
    dateFormatter.timeZone = TimeZone.current

    // Convert the date to a local time string
    let localTimeString = dateFormatter.string(from: date)
    
    return localTimeString
}
// ####################################################################################################################


func dateObjectToLocalDateString (dateObject: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
    dateFormatter.timeZone = TimeZone.current
    
    // Convert the date to a local time string
    let localTimeString = dateFormatter.string(from: dateObject)
    
    return localTimeString
}
// ####################################################################################################################


