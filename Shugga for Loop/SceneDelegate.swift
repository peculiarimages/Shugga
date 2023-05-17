//
//  SceneDelegate.swift
//  HK_test
//
//  Created by Rodi on 1/19/23.
//

import Foundation
import UIKit
import SwiftUI
import BackgroundTasks


/*    // old scene delegate
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    let bloodGlucoseData = BloodGlucoseData.shared

    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        printTimestamp()
        print("SceneDelegate (willConnectTo): fetchLatestBloodGlucose")
        bloodGlucoseData.fetchLatestBloodGlucose(whoCalledTheFunction: WhoCalledTheFunction.sceneDelegate) { success in
            if success {
  printTimestamp(description: "fetchLatestBloodGlucose", content: "Success", label: "SceneDel")
            }
        }
        
        bloodGlucoseData.startBackgroundDelivery()

        
        window.rootViewController = UIHostingController(rootView: BloodGlucoseView().environmentObject(BloodGlucoseData.shared))
        self.window = window
        window.makeKeyAndVisible()
    }
    

    

    func handleBackgroundFetchTask(task: BGAppRefreshTask) {
           // Perform background fetch task here
           BloodGlucoseData.shared.startBackgroundDelivery()
           task.setTaskCompleted(success: true)
       }

    //...
}


*/




class SceneDelegate: UIResponder, UIWindowSceneDelegate, UIApplicationDelegate {

    var window: UIWindow?
    var bloodGlucoseData = BloodGlucoseData.shared
    @AppStorage("speakInterval_seconds")                public var speakInterval_seconds:               Int =  defaultShuggaInterval // this is going to be multiples of 10 seconds
    @AppStorage("appEarliestBeginDate") public var appEarliestBeginDate = SecondsIn.fiveMinutesPlusOneSec.rawValue

    var backgroundTaskIdentifier: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid

//    override init () {
//        print ("## scene: SceneDelegate")
//
//    }

    
    /*
    func handleBackgroundFetchTask(task: BGTask) { // with the completion handler
        print ("func handleBackgroundFetchTask()")
       // scheduleBackgroundFetchTask()
        // Perform background fetch task here
        // let bloodGlucoseData = BloodGlucoseData.shared
        printTimestamp(description: "handleBackgroundFetchTask", content: "Starting...", label: WhoCalledTheFunction.backgroundFetch.rawValue)
       
        
        
        
        
        
        
//        scheduleBackgroundFetchTask()
        
        
        
        
        
        
        
        
        
        
        if bloodGlucoseData.theHealthKitIsAvailableOnThisDevice {
            print("handleBackgroundFetchTask_new")
            self.bloodGlucoseData.fetchLatestBloodGlucose(whoCalledTheFunction: WhoCalledTheFunction.backgroundFetch) { success in
                   if success {
                       self.bloodGlucoseData.speakBloodGlucose(whoCalledTheFunction: WhoCalledTheFunction.backgroundFetch)
                   }
               }
        } else {
            print("HealthKit is not available on this device.")
        }
//        task.expirationHandler = {
//            print ("cancel task if it expires")
//        }
        task.setTaskCompleted(success: true)
        print ("task completed")
    }
     */
    
    // ####################################################################################################################
    
    /*
    
    func scheduleBackgroundFetchTask() {
        
        print ("AppLaunched: Starting BGTaskScheduler.shared.submit(task)\n")
        
        let timeIntervalSinceNow: Double = bloodGlucoseData.returnSecondsToCheckCGM()
        print ("let timeIntervalSinceNow: Double = bloodGlucoseData.returnSecondsToCheckCGM(): \(timeIntervalSinceNow)")
        let date = Date()
        let timeStamp = date.timeIntervalSince1970
        
        print ("バックグランド　バックグランド　バックグランド　バックグランド　")

        BGTaskScheduler.shared.getPendingTaskRequests { [weak self] taskRequests in
            guard let self = self else { return }
            for taskRequest in taskRequests {
                if taskRequest.identifier == backgroundTaskID1 {
                    
                    print (taskRequest)
                    
                    print("\nTask is already scheduled    +++++++++++++   \(dateObjectToLocalDateString(dateObject: taskRequest.earliestBeginDate ?? Date()))")

                    UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
                        for request in requests {
                            print ("-----------------------------------")
                            print("Notification ID:       \(taskRequest.identifier)")
                            print("earliestBeginDate:     \( dateStringToLocalDateString (dateString: dateObjectToLocalDateString(dateObject: taskRequest.earliestBeginDate!)))     ** LOCAL TIME")
                            print("Content:               \(taskRequest.description)")
                            print ("-----------------------------------")
                            
                            
                            if request.identifier == backgroundTaskID1 {
                                
                                print("Notification ID:       \(taskRequest.identifier)")
                                print("earliestBeginDate:     \( dateStringToLocalDateString (dateString: dateObjectToLocalDateString(dateObject: taskRequest.earliestBeginDate!)))     ** LOCAL TIME")
                                print("Content:               \(taskRequest.description)")
                                print ("-----------------------------------")
                                break
                            }
                        }
                    }
                    return
                }
                else
                {  print ("No tasks with ID\(backgroundTaskID1) currently pending...") }
            }
            if taskRequests.isEmpty {  print ("No tasks currently pending...") }
            print ("バックグランド　バックグランド　バックグランド　バックグランド　")

            let request = BGAppRefreshTaskRequest(identifier: backgroundTaskID1)
            request.earliestBeginDate = Date().addingTimeInterval(Double(self.earliestBeginDate)) // Schedule task to run in x seconds
            do {
                try BGTaskScheduler.shared.submit(request)
                printTimestamp(description: "The task appeared to have just gotten scheduled.... in ", content: String(timeIntervalSinceNow), label: "BG Submit ")
                
                DispatchQueue.main.async {
                    self.bloodGlucoseData.theLastBackGroundAppRefreshRequested = timeStamp + Double(self.speakInterval_seconds)
                    print ("theLastBackGroundAppRefreshRequested: \(timeStampToLocal_hh_mm_ss(timestamp: self.bloodGlucoseData.theLastBackGroundAppRefreshRequested ?? zeroTimestamp))")
                    printTimestamp(description: "in seconds, Earliest Scheduled task", content: String(timeIntervalSinceNow), label: "SCH ")
                }
            } catch let error as NSError {
                printTimestamp(description: "scheduleBackgroundFetchTask", content: "Could not schedule background fetch task:\n \(error.localizedDescription)", label: "ERROR ", passedError: error)
            
                print("Error code: \(error.code)\n")
            }
            
            BGTaskScheduler.shared.getPendingTaskRequests { taskRequests in
                let isTaskScheduled = taskRequests.contains { $0.identifier == backgroundTaskID1}
                for taskRequest in taskRequests {
                    print ("*********** TASK x *************")

                    print(taskRequest.identifier)
                    print(dateObjectToLocalDateString(dateObject: taskRequest.earliestBeginDate!))
                }
            }
        } // BGTaskScheduler.shared.getPendingTaskRequests
        
        if thisIsBeta {
            //            simulateBackgroundTaskLaunch()
        }
    }
    */
    // ####################################################################################################################
    
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        print ("## scene: Scene will connect to session")

        isBGProcessingTaskSubmitted(withIdentifier:backgroundTaskID1, whoCalledTheFunction: .sceneDelegate) { isSubmitted in
            if isSubmitted {
                print("func scene(... task")
                
            }
        }
        isBGAppRefreshTaskSubmitted(withIdentifier:backgroundRefreshID1, whoCalledTheFunction: .sceneDelegate) { isSubmitted in
            if isSubmitted {
                print("func scene(... refresh")
                
            }
        }
        // Make sure the scene is of type UIWindowScene
               guard let windowScene = (scene as? UIWindowScene) else { return }
               
               // Create the UIWindow object
               let window = UIWindow(windowScene: windowScene)
               
               
               // Set your root view controller as the root view controller of the window
                window.rootViewController = UIHostingController(rootView: BloodGlucoseView().environmentObject(bloodGlucoseData))

               // Set the window property of the scene delegate
               self.window = window
               
               // Make the window visible
               window.makeKeyAndVisible()
        
        
  
    }
    
    
    // ####################################################################################################################
    
    
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
        print ("\n\n\n## sceneDidDisconnect ❗️❗️❗️❗️❗️❗️❗️❗️❗️❗️")
        bloodGlucoseData.appIsInForeground = false
    }
    
    
    // ####################################################################################################################
   
    
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
   
        bloodGlucoseData.appIsInForeground = true
        print ("\n\n## sceneDidBecomeActive")
        
        
        /*
        self.bloodGlucoseData.fetchLatestBloodGlucoseAndSpeak(whoCalledTheFunction: .sceneDelegate) { success in
            if success {
                print("Latest blood glucose fetched and spoken successfully! \(WhoCalledTheFunction.sceneDelegate.rawValue)")
            } else {
                print("Failed to fetch or speak latest blood glucose. \(WhoCalledTheFunction.sceneDelegate.rawValue)")
            }
        }
        */
        
        print ("self.sweetnesses?.count: \(bloodGlucoseData.manySweetnesses.returnTimeSinceLastCGM())")

        
        self.bloodGlucoseData.fetchLatestBloodGlucose(limit: 1, whoCalledTheFunction: .sceneDelegate) { result in
            
            switch result {
            case .success:
                print ("sceneDidBecomeActive fetchLatestBloodGlucose success")
            case .failure:
                print ("sceneDidBecomeActive fetchLatestBloodGlucose failure ❌")
            }
        } 
        
        CarbohydrateData.shared.getCarbohydrateConsumptionRecords { result in
            switch result {
            case .success(let carbs):
                print("Successfully fetched carbohydrates consumption records:")
                for carb in carbs {
                    print("Amount: \(carb.amount ?? 0), Date: \(carb.date ?? Date()), Source: \(carb.source ?? ""), Food type: \(carb.foodType ?? "")")
                }
            case .failure(let error):
                print("Failed to fetch carbohydrates consumption records: \(error.localizedDescription)")
            }
        }

        
        
        
        
        

        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
            for request in requests {
                print("Notification ID: \(request.identifier)")
                print("Content: \(request.content)")
                print("Trigger: \(String(describing: request.trigger))")
            }
        }
    }
    
    // ####################################################################################################################
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
       
        
        /*
        isBGProcessingTaskSubmitted(withIdentifier:backgroundTaskID1) { isSubmitted in
            if isSubmitted {
                print("Background task ID: \(backgroundTaskID1) is already submitted")
                
            }
        }
        isBGAppRefreshTaskSubmitted(withIdentifier:backgroundRefreshID1) { isSubmitted in
            if isSubmitted {
                print("Background task ID: \(backgroundRefreshID1) is already submitted")
                
            }
        }
        
        
        */
        print ("\n\n## sceneWillResignActive")
    }
    
    // ####################################################################################################################
   
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        bloodGlucoseData.appIsInForeground = true

        print ("\n\n## sceneWillEnterForeground")
        print ("*********** TASK *************")

        
//               sleep (10)
               if let _ = bloodGlucoseData.manySweetnesses.sweetnesses?.last {
                   
                   if bloodGlucoseData.manySweetnesses.returnTimeSinceLastCGM() > Double(speakInterval_seconds) {
                       
                       bloodGlucoseData.fetchLatestBloodGlucoseAndSpeak(whoCalledTheFunction: .foregroundScenePhase) { success in
                           if success {
                               print("Latest blood glucose fetched and spoken successfully!540 \(WhoCalledTheFunction.foregroundScenePhase.rawValue)")
                           } else {
                               print("Failed to fetch or speak latest blood glucose.")
                           }
                       }
                   }
               }

        bloodGlucoseData.setMainSugarTimerInterval()
        
        bloodGlucoseData.lastKnownForegroundEntryDate = Date.init() // foreground time right before going to backgrond

        print ("@@ lastKnownForegroundDate: \(dateObjectToLocalDateString(dateObject: bloodGlucoseData.lastKnownForegroundEntryDate))")
                
        isBGProcessingTaskSubmitted(withIdentifier:backgroundTaskID1, whoCalledTheFunction: .sceneDelegate) { isSubmitted in
            if isSubmitted {
              //  print("Background task ID: \(backgroundTaskID1) is already submitted")
            }
        }
        isBGAppRefreshTaskSubmitted(withIdentifier:backgroundRefreshID1, whoCalledTheFunction: .sceneDelegate) { isSubmitted in
            if isSubmitted {
               // print("Background task ID: \(backgroundRefreshID1) is already submitted")
            }
        }
    }
    
    // ####################################################################################################################
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Perform any tasks that need to be done before the app goes into the background
        print ("## applicationWillResignActive")
        bloodGlucoseData.appIsInForeground = false

    }
    
    // ####################################################################################################################
    
    
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        bloodGlucoseData.appIsInForeground = false

        print("\n\n## sceneDidEnterBackground")
        
        
        bloodGlucoseData.stopMainSugahTimer()
        
        bloodGlucoseData.lastKnownForegroundEntryDate = Date.init() // foreground time in the start of background

        print ("@@ lastKnownForegroundEntryDate: \(dateObjectToLocalDateString(dateObject: bloodGlucoseData.lastKnownForegroundEntryDate))")
        
        
        
        isBGProcessingTaskSubmitted(withIdentifier:backgroundTaskID1, whoCalledTheFunction: .sceneDelegate) { isSubmitted in
            if isSubmitted {
                print("Background task ID: \(backgroundTaskID1) is already submitted")
                
            }
        }
        isBGAppRefreshTaskSubmitted(withIdentifier:backgroundRefreshID1, whoCalledTheFunction: .sceneDelegate) { isSubmitted in
            if isSubmitted {
                print("Background task ID: \(backgroundRefreshID1) is already submitted")
                
            }
        }
        printTimestamp(description: "sceneDidEnterBackground")
        print("---------------------------")
        
//        if !isBGProcessingTaskSubmitted(withIdentifier: backgroundTaskID1){
//               print ("\n\n NO TASKS \n\n")
//        }
    }
    // ####################################################################################################################

    
    
   

    
    
    
} // sceneDelegate
