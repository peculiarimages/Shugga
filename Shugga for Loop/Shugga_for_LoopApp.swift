//
//  Shugga_for_LoopApp.swift
//  Shugga for Loop
//
//  Created by Rodi on 4/26/23.
//

import SwiftUI
import AVFoundation
import BackgroundTasks
//import Purchases

let currentAppEarliestBeginDate =           SecondsIn.twoMinutesAndOneSec.rawValue
let currentAppEarliestBeginDateReSubmit =   SecondsIn.sixtyOneSeconds.rawValue












class AppDelegate: UIResponder, UIApplicationDelegate {
    @AppStorage("appEarliestBeginDate") public var appEarliestBeginDate = currentAppEarliestBeginDate
    
    @AppStorage("speakInterval_seconds")                public var speakInterval_seconds:               Int =  10 // this is going to be multiples of 10 seconds
    
    @AppStorage("backgroundTaskIsOn") public var backgroundTaskIsOn = true
    @AppStorage("backgroundAppRefreshIsOn") public var backgroundAppRefreshIsOn = true
    
    
    @AppStorage("shuggaInBackground")               public var shuggaInBackground =                     true

    
    //    let app = UIApplication.shared
    
    let bloodGlucoseData = BloodGlucoseData.shared
    let shuggaStatus = ShuggaStatus.shared
    let carbohydrateData = CarbohydrateData.shared
    
    //    let theTranslator = TheTranslator.shared
    //    let theAppVoices = TheAppVoices.shared
    
    
    
    
    var backgroundTaskIdentifier: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
    // vs var backgroundTaskIdentifier: UIBackgroundTaskIdentifier!
    //It's worth noting that it's not strictly necessary to use an implicitly unwrapped optional here.
    //You could alternatively use a regular optional and assign a default value of
    //UIBackgroundTaskIdentifier.invalid when you declare the variable (see above).
    
    
    let operationQueue = OperationQueue()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
//        Purchases.debugLogsEnabled = true
//        Purchases.configure(withApiKey("appl_XEptIqUOWKAKqxKaJxpmDXpNafP"))
//        
        
        print ("APP launched")
        
        bloodGlucoseData.manySweetnesses.deBug.timeString = formatTime_HH_mm_ss(Date())

        bloodGlucoseData.lastKnownForegroundEntryDate = Date.init() // the original setting of it when the app opens

        print ("@@ lastKnownForegroundEntryDate: \(dateObjectToLocalDateString(dateObject: bloodGlucoseData.lastKnownForegroundEntryDate))")
        
        
   
        BGTaskScheduler.shared.register(forTaskWithIdentifier: backgroundTaskID1, using: nil) { task in
            // Perform the background task
            self.handleOSBackgroundTask(task: task as! BGProcessingTask)
        }

        

        BGTaskScheduler.shared.register(forTaskWithIdentifier: backgroundRefreshID1, using: nil) { task in
            // Perform the background refresh task
            self.handleOSBackgroundRefreshCall(task: task as! BGAppRefreshTask)
        }
        // Set audio session category
        
        do {
          
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: .mixWithOthers)
            //To allow your app's audio to play over the system's audio, you can set the category of the app's AVAudioSession to .playback with the option .mixWithOthers. This allows your app's audio to be mixed with other audio from the system, such as from other apps, while still allowing the user to control the volume of your app's audio separately.
            
        } catch {
            print ("ERROR:")
            print("Could not set audio session category")
        }
        
        
        
        if backgroundTaskIsOn { scheduleBackgroundProcessingTask(whoCalledTheFunction: .appDelegate)}
        else {BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: backgroundTaskID1)}// Processing TASK   *****  プロセッシング
        if backgroundAppRefreshIsOn {scheduleBackgroundAppRefreshTask(whoCalledTheFunction: .appDelegate)}
        else {BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: backgroundRefreshID1)}//APP RefreshTask   *****　　リフレッシュ
        
        
        return true
        
    }
    // ####################################################################################################################
    
    
    
    
    
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        sceneConfig.delegateClass = SceneDelegate.self
        
        
        
        isBGProcessingTaskSubmitted(withIdentifier:backgroundTaskID1, whoCalledTheFunction: .applicationConfigurationForConnecting) { isSubmitted in
            if isSubmitted {
//                print("1️⃣ Background task ID: \(backgroundTaskID1) is already submitted")
                
            }
        }
        isBGAppRefreshTaskSubmitted(withIdentifier:backgroundRefreshID1, whoCalledTheFunction: .applicationConfigurationForConnecting) { isSubmitted in
            if isSubmitted {
//                print("2️⃣ Background app refresh ID: \(backgroundRefreshID1) is already submitted")
                
            }
        }
        
        return sceneConfig
    }
    // ####################################################################################################################
    
    
    
    
    func scheduleBackgroundProcessingTask(whoCalledTheFunction: WhoCalledTheFunction) { // Processing TASK   *****  プロセッシング
        
        let request = BGProcessingTaskRequest(identifier: backgroundTaskID1)
        request.requiresNetworkConnectivity = false  // change as needed
        request.requiresExternalPower = false // change as needed
        
        //            request.earliestBeginDate = Date(timeIntervalSinceNow: Double(appEarliestBeginDate)) // what i want?
        if whoCalledTheFunction == .iOSBackgroundCall
        { request.earliestBeginDate = Date() + Double(SecondsIn.sixtyOneSeconds.rawValue) }
        
        else
        { request.earliestBeginDate = Date() + Double(SecondsIn.sixtyOneSeconds.rawValue) }
        //        request.estimatedCompletionTime = 15 * 60 // 15 minutes

        do {
            try BGTaskScheduler.shared.submit(request)
            print("\n\nSuccessfully scheduled task\n\n")
            // checkForBGTaskScheduler()
            
            isBGProcessingTaskSubmitted(withIdentifier:backgroundTaskID1, whoCalledTheFunction: .scheduleBackgroundProcessingTaskMethod) { isSubmitted in
                if isSubmitted {
//                    print("Background task ID: \(backgroundTaskID1) is already submitted")
                }
            }
            isBGAppRefreshTaskSubmitted(withIdentifier:backgroundTaskID1, whoCalledTheFunction: .scheduleBackgroundProcessingTaskMethod) { isSubmitted in
                if isSubmitted {
//                    print("Background task ID: \(backgroundTaskID1) is already submitted")
                }
            }
            
        } catch {
            print("\n\nCould not schedule this background task: \(error)\n\n")
            switch error {
            case BGTaskScheduler.Error.unavailable:
                print("Task scheduling is unavailable on this device")
            case BGTaskScheduler.Error.tooManyPendingTaskRequests:
                print("Too many pending task requests for this app")
            case BGTaskScheduler.Error.notPermitted:
                print("App is not permitted to schedule background tasks")
            default:
                print("An unknown error occurred(background task): \(error)")
            }
        }
    }
    // ####################################################################################################################
    
    
    
    func scheduleBackgroundAppRefreshTask(whoCalledTheFunction: WhoCalledTheFunction) {  //APP RefreshTask   *****　　リフレッシュ
        
        let request = BGAppRefreshTaskRequest(identifier: backgroundRefreshID1)
        //        request.earliestBeginDate = Date(timeIntervalSinceNow: Double(appEarliestBeginDate)) // what i want?
        if whoCalledTheFunction == .iOSBackgroundCall { request.earliestBeginDate = Date() + Double(currentAppEarliestBeginDateReSubmit) }
        else {  request.earliestBeginDate = Date() + Double(currentAppEarliestBeginDate) }

        do {
            try BGTaskScheduler.shared.submit(request)
            print("\n\nSuccessfully scheduled app refresh\n\n")
            // checkForBGTaskScheduler()
            
            isBGProcessingTaskSubmitted(withIdentifier:backgroundRefreshID1, whoCalledTheFunction: .scheduleBackgroundAppRefreshTaskMethod) { isSubmitted in
                if isSubmitted {
//                    print("Background app refresh ID: \(backgroundRefreshID1) is already submitted")
                }
            }
            isBGAppRefreshTaskSubmitted(withIdentifier:backgroundRefreshID1, whoCalledTheFunction: .scheduleBackgroundAppRefreshTaskMethod) { isSubmitted in
                if isSubmitted {
//                    print("Background app refresh ID: \(backgroundRefreshID1) is already submitted")
                    
                }
            }
            
        } catch {
            print("\n\nCould not schedule this app refresh: \(error)\n\n")
            switch error {
            case BGTaskScheduler.Error.unavailable:
                print("app refresh scheduling is unavailable on this device")
            case BGTaskScheduler.Error.tooManyPendingTaskRequests:
                print("Too many pending app refresh requests for this app")
            case BGTaskScheduler.Error.notPermitted:
                print("App is not permitted to schedule background app refresh")
            default:
                print("An unknown error occurred(app refresh): \(error)")
            }
        }
    }
    // ####################################################################################################################
    
    func handleOSBackgroundTask(task: BGTask ) { //BGTaskScheduler
        // Create an operation that performs the main part of the background task.
        
        
        let highPriorityQueue = DispatchQueue(label: "shugga.dispatch", qos: .userInitiated)

             scheduleBackgroundProcessingTask(whoCalledTheFunction: .iOSBackgroundCall)
        
         // Create an operation that performs the main part of the background task.
        
        let operation = BlockOperation {
            print ("Started Background task: Operation")
                
                     highPriorityQueue.async {  // trying out global instead (see below)
//                      DispatchQueue.global(qos: .background).async {
                   self.myBackgroundOperation(whoCalledTheFunction: .backgroundTask)
               }
        }
        
         // Provide the background task with an expiration handler that cancels the operation.
         task.expirationHandler = {
             printTimestamp(description: "task.expirationHandler", content: "operation.cancel()", label: "task cancel❗️❗️ ")
             operation.cancel()
         }
         // Inform the system that the background task is complete when the operation completes.
         operation.completionBlock = {
             task.setTaskCompleted(success: !operation.isCancelled)
             if operation.isCancelled {
                 printTimestamp(description: "operation.completionBlock", content: "end of", label: "task cancelled❗️❗️ ")
                   task.setTaskCompleted(success: false)
                } else {
                    printTimestamp(description: "operation.completionBlock", content: "Success", label: "task completed ✅ ")
                   task.setTaskCompleted(success: true)
                }
         }
         // Start the operation.
         operationQueue.addOperation(operation)
     }
    
    // ####################################################################################################################
    
    
    func handleOSBackgroundRefreshCall(task: BGAppRefreshTask) { //BGTaskScheduler®
        // Schedule a new refresh task.
        
       
            scheduleBackgroundAppRefreshTask(whoCalledTheFunction: .iOSBackgroundCall)
       
      
        // Create an operation that performs the main part of the background task.
        let operation = BlockOperation {
            print ("Started Background AppRefresh: Operation")
            self.myBackgroundOperation(whoCalledTheFunction: .backgroundRefresh)
        }
        // Provide the background task with an expiration handler that cancels the operation.
        task.expirationHandler = {
            printTimestamp(description: "appRefresh.expirationHandler", content: "operation.cancel()", label: "refresh cancel❗️❗️ ")
            operation.cancel()
        }
        // Inform the system that the background task is complete when the operation completes.
        operation.completionBlock = {
            task.setTaskCompleted(success: !operation.isCancelled)
            if operation.isCancelled {
                printTimestamp(description: "operation.completionBlock", content: "end of", label: "refresh cancelled❗️❗️ ")
                  task.setTaskCompleted(success: false)
               } else {
                   printTimestamp(description: "operation.completionBlock", content: "Success", label: "refresh completed ✅ ")
                  task.setTaskCompleted(success: true)
               }
        }
        // Start the operation.
        operationQueue.addOperation(operation)
    }
    
    // ####################################################################################################################
    
    
    
    
    func myBackgroundOperation(whoCalledTheFunction: WhoCalledTheFunction) {
        
        print ("My Background Operation, called by: \(whoCalledTheFunction.rawValue)" )
        
        if bloodGlucoseData.theHealthKitIsAvailableOnThisDevice {
            print("handleBackgroundFetchTask_new")
            
//            if shuggaInBackground {
            
            
            
            
            
            
            
            
            
                if true {

                self.bloodGlucoseData.fetchLatestBloodGlucoseAndSpeak(whoCalledTheFunction: whoCalledTheFunction) { success in
                    if success {
                        print("Latest blood glucose fetched and spoken successfully! \(whoCalledTheFunction.rawValue)")
                    } else {
                        print("Failed to fetch and/or speak latest blood glucose. \(whoCalledTheFunction.rawValue)")
                    }
                }
                
            }
            else {
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                self.bloodGlucoseData.fetchLatestBloodGlucose(whoCalledTheFunction: whoCalledTheFunction) { result in
                    switch result {
                    case .success:
                        print("Latest blood glucose fetched from \(whoCalledTheFunction.rawValue) but shuggaInBackground is turned off so was not utter.")
                    case .failure:
                        print("Failed to fetch latest blood glucose from \(whoCalledTheFunction.rawValue).")
                    }
                }
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
            }
        }
        else {  print("HealthKit is not available on this device.") }
        
        isBGProcessingTaskSubmitted(withIdentifier:backgroundTaskID1, whoCalledTheFunction: .myBackgroundOperationMethod) { isSubmitted in
            if isSubmitted {
//                print("Background task ID: \(backgroundTaskID1) is already submitted")
                
            } }
        
        isBGAppRefreshTaskSubmitted(withIdentifier:backgroundRefreshID1, whoCalledTheFunction: .myBackgroundOperationMethod) { isSubmitted in
            
            if isSubmitted {
//                print("Background task ID: \(backgroundRefreshID1) is already submitted")
                
            } }
    }
   
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

} // ##########################################   End of AppDelegate  #######################################################

//

 

/*
@main
struct ShuggaApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        WindowGroup {
            BloodGlucoseView()
                .environmentObject(BloodGlucoseData.shared)
        }
    }
}

*/


@main
struct ShuggaApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @StateObject private var appLaunchState = AppLaunchState()

    var body: some Scene {
        WindowGroup {
            if appLaunchState.isLaunchScreenDisplayed {
                LaunchScreen()
            } else {
                BloodGlucoseView()
                    .environmentObject(BloodGlucoseData.shared)
            }
        }
    }
}
