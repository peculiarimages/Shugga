//
//  BackgroundModel.swift
//  Shugga
//
//  Created by Rodi on 3/2/23.
//

import Foundation
import BackgroundTasks


func isBGProcessingTaskSubmitted(withIdentifier identifier: String, whoCalledTheFunction: WhoCalledTheFunction, completionHandler: @escaping (Bool) -> Void) {
    var isTaskSubmitted = false

    BGTaskScheduler.shared.getPendingTaskRequests { taskRequests in
        if taskRequests.isEmpty {
            print("No pending task プロセッシング requests found")
        }
        
        for taskRequest in taskRequests {
            if taskRequest is BGProcessingTaskRequest {
                if let processingTaskRequest = taskRequest as? BGProcessingTaskRequest {
                    if processingTaskRequest.identifier == identifier {
                        isTaskSubmitted = true
//                        printTimestamp(description: "✅ プロセッシング Task ID: \(processingTaskRequest.identifier)", content: "*** earliestBeginDate: \(dateObjectToLocalDateString(dateObject: taskRequest.earliestBeginDate ?? rodisBirthday))", label: "✅1️⃣ exists ")
                        break
                        
                    } else { print("Found BGProcessingTaskRequest with identifier '\(processingTaskRequest.identifier)', but it doesn't match the specified identifier '\(identifier)'\n\n") }
                }
            }
        }
        
        if !isTaskSubmitted {
            print("Background task with identifier '\(identifier)' was not found in pending task requests")
        }
        
        DispatchQueue.main.async {   /// ⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️ remove dispatchqueue if not working
            completionHandler(isTaskSubmitted)
        }    }
}
// ####################################################################################################################



func isBGAppRefreshTaskSubmitted(withIdentifier identifier: String, whoCalledTheFunction: WhoCalledTheFunction,completionHandler: @escaping (Bool) -> Void) {
    var isTaskSubmitted = false
    
    BGTaskScheduler.shared.getPendingTaskRequests { taskRequests in
        if taskRequests.isEmpty {
            print("No pending app refresh リフレッシュ requests found")
        }
        
        for taskRequest in taskRequests {
            if taskRequest is BGAppRefreshTaskRequest {
                if let appRefreshTaskRequest = taskRequest as? BGAppRefreshTaskRequest {
                    if appRefreshTaskRequest.identifier == identifier {
                        isTaskSubmitted = true
//                        printTimestamp(description: "✅ リフレッシュ Task ID: \(appRefreshTaskRequest.identifier)", content: "*** earliestBeginDate: \(dateObjectToLocalDateString(dateObject: taskRequest.earliestBeginDate ?? rodisBirthday))", label: "✅2️⃣ exists ")
                       break
                        
                    }  else { print("Found BGAppRefreshTaskRequest with identifier '\(appRefreshTaskRequest.identifier)', but it doesn't match the specified identifier '\(identifier)'\n\n") }
                }
            }
        }
        
        if !isTaskSubmitted {
            print("Background task with identifier '\(identifier)' was not found in pending app refresh requests")
        }
        
        completionHandler(isTaskSubmitted)
    }
}
// ####################################################################################################################


func returnEarliestBeginDate(identifier: String, completionHandler: @escaping (Date) -> Void) {
    BGTaskScheduler.shared.getPendingTaskRequests { taskRequests in
        if let processingTaskRequest = taskRequests.first(where: {
            $0 is BGProcessingTaskRequest && $0.identifier == identifier
        }) as? BGProcessingTaskRequest {
            let earliestBeginDate = processingTaskRequest.earliestBeginDate ?? rodisBirthday
            completionHandler(earliestBeginDate)
        } else if let appRefreshTaskRequest = taskRequests.first(where: {
            $0 is BGAppRefreshTaskRequest && $0.identifier == identifier
        }) as? BGAppRefreshTaskRequest {
            let earliestBeginDate = appRefreshTaskRequest.earliestBeginDate ?? rodisBirthday
            completionHandler(earliestBeginDate)
        } else {
            completionHandler(rodisBirthday)
        }
    }
}

