//
//  enums.Warnings.swift
//  sugah
//
//  Created by Rodi on 2/6/23.
//

import Foundation
import BackgroundTasks

let shuggaIndependentAppDisclaimer = "Shugga for Loopˮ is an independent app and is not affiliated with Loop.app, LoopKit, or Dexcom."

let acknowledgementText = "While this app is a project of a single mere mortal behind the vail of an LLC, many thanks to the following individuals who helped me get this far with Shugga:\n\nGlo Glo the Nurse\n\nFuture localizations:\n\n   Deutsch: My better half Ms. Fritz\n   Italiano: Tiziana\n   한국어: Alex Y.\n   Français: Haruka\n\n日本語: Rodi\n\nMoral Support: \n\n   Henri🚀, everyone's secret weapon!!\n   Justine🚶🏻‍♀️, a vet who actually cares!!\n   Stephen🐤, the only benevolent 宇宙人 I know!!\n\nMoral Hazard & LLC: Gregman G.\n\nAs for my own pancreas that stoped behaving 20 odd years ago, WTF and for your bad attitude, I would like to express my profound gratitude to everyone who has supported me over the past two decades+.\n\n This includes all the outstanding doctors, nurses and other clinicians, as well as the pharmacists who go the extra mile to provide me with those hard-to-find 3 ml Humalog vials! \n\nI also need to thank the diabetes reserachers, developers of medical devices and the technical support and accounting teams at CGM/Pump manufacturers. Moreover, I can't forget to express my gratitude to those who created and support Loop.app and LoopKit. 'Thank you all for saving my life.'\n\nWhile I'm hesitant to thank my insurance company, it's worth noting that if others knew the cost of my monthly premium, they might 💩 in your 👖. It's astonishing that we tolerate such \"culture\" in a nation that considers itself advanced.\n\nTo everyone else, THANK YOU SO MUCH for downloading. Living with diabetes can be immensely challenging, and it might be difficult for others to fully comprehend this struggle. However, I hope this small app will bring some degree of manageability and joy to your life. The only one we've got."

let doesNotHaveBGonHealth = "Sorry, we couldn't find any blood glucose records in your Health data. This app requires access to your blood glucose (optionally your carbohydrate) data to work properly."

let legalText = "Shugga is for entertainment purposes only. It is NOT meant to be used for clinical diagnosis. This app provides only information which may or may not be accurate, is not medical or treatment advice and may not be treated as such by the user. As such, this app may not be relied upon for the purposes of medical diagnosis or as a recommendation for medical care or treatment. The information on this app is not a substitute for professional medical advice, diagnosis or treatment. All content, including text, graphics, images and information, contained on or available through this app is for general information purposes only. Always check your blood glucose data given on this app against blood glucose measuring devices approved by your regulatory agencies. Read the “About” section of this app completely. Stay healthy!!"

let whatThisAppDoes = "Welcome to Shugga, an app that retrieves your latest blood glucose entry (optionally your carbohydrate record) from the Health data stored on your phone and reads it back to you. We take your privacy seriously and want you to know that Shugga does not use your health data for any other purpose. Your blood glucose data is never stored, transmitted, or shared outside the confines of this app. To use Shugga, you will need to grant the app permission to read your blood glucose data stored on your phone. Your privacy is important to us and we are committed to keeping your data to you only."

let pleaseSendUsANote = "Since this app tracks nothing, please send us a note, even if it's something small. It could be as simple as “I used it while running my first half marathon!ˮ By doing so, we can focus our efforts more efficiently."

let demoValueNotice = "This app is running in Demo Mode. The blood glucose value shown above and all other information on this app are for demonstration purposes only. None of the information found when running in \"Demo Mode\" reflect your actual values."

let noHealthDataAccessNotice = "Warning users that the __data access permission is not set for this app__ part of logic is not working. Users will see a blank page if the access is not set, for now."

let demoValue_mgPerdl = "XYZ"
let demoValue_mmolPerLiter = "X.Y"

let noHealthKitNotice: String = "\nThere appears to be no available blood glucose data to be read. \n\nEither you don't have any blood glucose values stored on the phone or you may not have allowed data access to this app in the System Settings. \n\nIf not, please add glucose values and go to System Settings→ Health→ Data Access and Devices and look for Shugga.app in the list. Then, turn that on as shown below. The app should work fine after that."

let twitterLink: String = "https://twitter.com/ShuggaApp"

let twitterHandle: String = "@ShuggaApp"

let youTubePlayListLink: String = "https://youtube.com/playlist?list=PLk5rQBc5hAiMtojLe-aJYYALgaHOT1UGn"


let webPageLink: String = "https://shugga.app"

let listOfBugs = "The future version will have other languages and more voices."

let youMustAgreeText = "You must agree to the User Agreement, then turn Shugga ON before you can use this app in the app's settings, which you can navigate by tapping the Shugga logo or the gear ⚙️ icon above."

let nationalParksText = "Now that you've read this far, go get your free lifetime US National Parks pass! This is the only free thing, beside the love from the people around you that is free for us diabetics. Just show up at the gate of a national park, then inform the park ranger that you are an insulin dpendent diabetic and you can get a freebie. WOO HOO!\n"

let disclaimerBoilerplate = "Disclaimer: “Shugga for Loopˮ is an independent app and is not affiliated with Loop.app, LoopKit, or Dexcom. This version of Shugga works with Apple's HealthKit, leveraging real-time updates of blood glucose values provided by Loop. Even without a continuous glucose monitor and Loop, “Shugga for Loopˮ could facilitate manual blood glucose testing, provided you enter carbohydrate consumption into the Health app. We strongly recommend reviewing and understanding Loop's documentation and guidelines before using this app to ensure a seamless experience.\n\nPlease note, this version has been tested with the Dexcom G6 and its 5-minute sampling frequencies. However, it hasn't been tested with the G7 yet. \n\nAlways check your blood glucose data against blood glucose measuring devices approved by your regulatory agencies. You are on your own because it's your own body.\n"

let whyShugga = "This is why I decided to make Shugga:\n\nA year earlier, I had capsized three times in a single day due to an unexpected storm during solo kayak fishing on Bodega Bay. My trusted NOAA's marine-point-forecast hadn't predicted this. A few boaters, also rushing back to port, blew past me in the water. I was about to turn my marine radio channel from 69 to 16 (Coast Guard) when one boat rescued me (Thank you! Your comments about sharks were \"hilarious!\"). \n\nIt took me a while to regain my confidence and return to the water, but by the following summer, I was fishing again as often as I could, albeit with a lot more caution.\n\nOn an otherwise pleasant summer day kayaking again, I noticed the wind picking up and the water becoming choppier (not again!). A quick glance at the fish-finder's GPS indicated that I was about 45 minutes from the safety of Dillon Beach if I paddled hard (my kayak is of the leg-powered, pedal-driven type, about 4-5 knots max.). \n\nAs the sea turned rougher, with my left hand on the rudder and my right maintaining balance, I had no spare moments to check my blood sugar. I didn't want to pour carbs unnecessarily (Nerds are my go-to). My Apple Watch was virtually useless due to my wet hands, and my waterlogged iPhone, tethered to my PFD, was similarly unresponsive. To optimally navigate back to the shore, a continuous auditory cue of my BG would have been immensely helpful. Hence, this app."

let aboutShuggaText = """
Shugga for Loop is a simple yet highly customizable iPhone app that announces your latest blood glucose (BG) data found in your HealthKit. Primarily built as a companion for Loop.app, it also serves those who have their live BG values written to HealthKit by other means. It also caters to those who manually enter their BG values into Health app, though in a limited capacity.

Additionally, it provides an optional display of your carb intake in the past 24 hrs. (also sourced from Health data)

The app's design and customization cater to a wide range of users, offering enhanced accessibility for visually impaired individuals and features for active users. The main page is deliberately kept simple for quick visual cues.

Shugga for Loop is exclusively compatible with iPhones due to its dependence on Apple Health, which is not available on other devices.
"""

let aboutPrivacy = " We take your privacy seriously and want you to know that Shugga for Loop does not use your data for any other purpose. Your data is never stored, transmitted, or shared outside the confines of this app. Your privacy is important to us and we are committed to keeping your data to you only."

let aboutHealthKitPermissions = """
You will need to grant the app an ongoing “Read Access” to your BG data in HealthKit for this app to work at all. Optionally, you can give the same access to your carbohydrate data if you are interested in being able to see your carbohydrate history in the app.

You will be prompted only once for the permissions by the Shugga for Loop, per Apple’s design at the very first time you use the app. If you don't grant access(es) then, you can do so later in the iPhone’s Settings: Health: Data Access and Devices: Shugga for Loop.
"""

let aboutAppInBackgroundSetting = "If you want Shugga for Loop to work while the app is in the background, make sure you enable Background App Refresh in the iPhone’s Settings: Shugga for Loop:  Background App Refresh."
