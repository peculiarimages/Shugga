//
//  enums.Warnings.swift
//  sugah
//
//  Created by Rodi on 2/6/23.
//

import Foundation
import BackgroundTasks


let doesNotHaveBGonHealth = "Sorry, we couldn't find any blood glucose records in your Health data. This app requires access to your blood glucose (optionally your Steps and Carbohydrate) data to work properly."

let legalText = "Shugga is for entertainment purposes only. It is NOT meant to be used for clinical diagnosis. This app provides only information which may or may not be accurate, is not medical or treatment advice and may not be treated as such by the user. As such, this app may not be relied upon for the purposes of medical diagnosis or as a recommendation for medical care or treatment. The information on this app is not a substitute for professional medical advice, diagnosis or treatment. All content, including text, graphics, images and information, contained on or available through this app is for general information purposes only. Always check your blood glucose data against blood glucose measuring devices approved by your regulatory agencies. Stay safe!!"

let whatThisAppDoes = "Welcome to Shugga, an app that retrieves your latest blood glucose entry (optionally your carbohydrate and step records) from the Health data stored on your phone and reads it back to you. We take your privacy seriously and want you to know that Shugga does not use your health data for any other purpose. Your blood glucose data (optionally your carbohydrate and step records) is never stored, transmitted, or shared outside the confines of this app. To use Shugga, you will need to grant the app permission to read your blood glucose data stored on your phone. Your privacy is important to us and we are committed to keeping your data safe."

let pleaseSendUsANote = "Since this app tracks nothing, please send us a note even if it's a tiny thing. Even something like \"I used it while running my first half marathon!!\" because we can focus our effort more efficiently that way."

let demoValueNotice = "This app is running in Demo Mode. The blood glucose value shown above and all other information on this app are for demonstration purposes only. None of the information found when running in \"Demo Mode\" reflect your actual values."

let noHealthDataAccessNotice = "Warning users that the __data access permission is not set for this app__ part of logic is not working. Users will see a blank page if the access is not set, for now."

let demoValue_mgPerdl = "XYZ"
let demoValue_mmolPerLiter = "X.Y"

let noHealthKitNotice: String = "\nThere appears to be no available blood glucose data to be read. \n\nEither you don't have any blood glucose values stored on the phone or you may not have allowed data access to this app in the System Settings. \n\nIf not, please add glucose values and go to System Settings→ Health→ Data Access and Devices and look for Shugga.app in the list. Then, turn that on as shown below. The app should work fine after that."

let twitterLink: String = "https://twitter.com/ShuggaApp"

let twitterHandle: String = "@ShuggaApp"

let webPageLink: String = "https://shugga.app"

let listOfBugs = "AboutView returns to SettingsView w/o the user clicking the return link when SettingsView gets updated"
