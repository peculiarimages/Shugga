//
//  DebugMethods.swift
//  shugga
//
//  Created by Rodi on 2/23/23.
//

import Foundation
import SwiftUI
import BackgroundTasks

func customLog(_ message: String, functionName: String = #function, lineNumber: Int = #line) {
    let deviceName = UIDevice.current.name
    print("[\(deviceName)] [\(functionName):\(lineNumber)] \(message)")
}



func checkForBGTaskScheduler() -> Bool {
    print ("-----------------------------------")

    print ("checkForBGTaskScheduler")
    var isTaskScheduled = false

    BGTaskScheduler.shared.getPendingTaskRequests { taskRequests in
        if taskRequests.isEmpty {
            print ("looking like no tasks")

        }
        for taskRequest in taskRequests {
            if taskRequest.identifier == backgroundTaskID1 {
                isTaskScheduled = true
                
                print("Notification ID:       \(taskRequest.identifier)")
                print("earliestBeginDate:     \(dateObjectToLocalDateString(dateObject: taskRequest.earliestBeginDate!))")

                print("earliestBeginDate:     \( dateStringToLocalDateString (dateString: dateObjectToLocalDateString(dateObject: taskRequest.earliestBeginDate!)))     ** LOCAL TIME")
                print("Content:               \(taskRequest.description)")
                print ("-----------------------------------")
                
                
                
                
                
                
        /*
                
                if let refreshTaskRequest = taskRequest as? BGAppRefreshTaskRequest {
                            // Update the earliest begin date
                    refreshTaskRequest.earliestBeginDate = Date(timeIntervalSinceNow: defaultFirstScheduleTaskEarliestInSeconds)
                            // Submit the updated task
                            do {
                               // try BGTaskScheduler.shared.submit(refreshTaskRequest)
                                print ("-- Successfully rescheduled task --✅")
                                print("Notification ID:       \(taskRequest.identifier)")
                                print("earliestBeginDate:     \( dateStringToLocalDateString (dateString: dateObjectToLocalDateString(dateObject: taskRequest.earliestBeginDate!)))     ** LOCAL TIME")
                                print("Content:               \(taskRequest.description)")
                                print ("-----------------------------------")
                                
                            } catch {
                                print("Failed to reschedule task: \(error.localizedDescription)")
                            }
                        }
      */
                
                
                
                
                
                
                break
            }
            else
            {
                print ("Did not find any scheduled task")
                print ("-----------------------------------")

                
            }
        }
    }

    return isTaskScheduled
}
