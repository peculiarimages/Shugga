//
//  Enum.Text.manuals.swift
//  Shugga
//
//  Created by Rodi on 5/30/23.
//

import Foundation


let manuals_Shugga_and_shugga = """
Within the app and in this document, the word shugga (lowercase) is used as a verb to express the latest BG reading available in HealthKit data being announced.

Eg: “Shugga for Loop will shugga every five minutes.

Meaning: The app will announce the latest BG stored in your HealthKit.
"""

let manuals_foreground_background_subheadline = "App Modes"
let manuals_foreground_background = " It's important to understand that there are two main phases of the app you experience and the different exceptions you should have from the them:"

let manual_foreground_background_explained = """
Foreground Mode

This is when the app is in the foreground and being actively used by you or being left turned on. You can expect the app to behave exactly as you set the parameters in the settings.

Background Mode

This is when the app runs in the background while you may be using other apps or when the phone is unlocked but not otherwise being used. The app, when the background mode is turned on, is capable of making the announcement.

The frequencies of shugga, however, is limited while in this mode. The iPhone’s operating system will dictate when the app can shugga. It has been shown, under some conditions, the app is capable to shugga about every ten minutes. The exact nature of optimizing for this is not well publicized.

We believe having the iPhone in the following conditions greatly improves the odds of the operating system allowing Shugga for Loop to shugga (these are guesses):
"""

let manual_foreground_background_optimization = """
  • A good battery charge
  • Not a degraded battery
  • Currently charging
  • Using quick charger
  • App higher up in the list of running app order
  • App in one of the positions in the doc
  • Good mobile and/or WIFI reception
  • Not playing other media
  • Use the app often
"""

let manual_foreground_background_belief = "We believe all the above conditions will help to get the operating system “feeling relaxed” to spend the resources allowing the app to do its things."

let manual_foreground_background_suggestion = "We recommend you keep Shugga for Loop in the foreground and turn off the auto-lock feature and lower the brightness in the main iPhone Display & Brightness settings when doing some activities you want frequent and consistent shugga to occur."
let manual_doesnt_work_locked = "The app doesn't function when the phone is locked or turned off."

let manual_shugga_foreground_subhedline = "SHUGGA FREQUENCIES: Foreground Mode"
let manual_shugga_foreground = """
When the app is in the foreground, you get the total experience and the control with shugga in Shugga for Loop.

You can customize the app functionality by using the settings available by tapping on the gear icon. The frequencies in which the app announce the latest available BG in your record will be the value you set it in.

If you set it to 30 seconds, it will repeat and announce about every 30 seconds.

If you set it to 5 minutes, it will announce about every 5 min.

It's "about" because the app will try to adjust the frequencies so it will try to announce the data as soon as it is made available to HealthKit.

For example, when using a CGM with a 5 min sample frequencies, the CGM may sample and report the value every five on the dot (12:00, 12:05, 12:10 …), provided that there is an adequate Bluetooth connection between the CGM transmitter and your iPhone..
 
If you have initiated the app at 12:03, with 5 min as the frequency to shugga, the first shugga could be five minutes after 12:03 or 12:08. Then, the next will be five minutes later at 12:13. In both times, the data were at least 2 minutes older than the actual sample times.

The app tries to adjust the cycle by increasing the frequency once to be just ten seconds old. So it will be 12:05:10 when the first announcement is made, then 12:10:10 and so on. That way, you hear the new value as soon as it is expected to be made available by the CGM.

There may be some Bluetooth wireless communication issues between the transmitter and your iPhone. In that event, the value announced by the app will be what is still in HealthKit. It is important that to keep “Shugga time elapsed when in foreground” option turned on. That way you know exactly when the sample being announced was taken.

Eg: “Seven minutes and nine seconds ago, 110 mg/dL”

If your CGM samples every 5 minutes, you can be sure that it has missed one sample thus far.

As shown in the earlier example, the app will wait 10 seconds from the expected sampling delivery by the CGM/Loop before querying HealthKit for the latest data.

When in foreground, it queries every ten seconds for a new data also. When the app detects a new data, it will update the displayed BG and will shugga it during the next shugga cycle assigned by you.
"""


let manual_shugga_background_subhedline = "SHUGGA FREQUENCIES: Background Mode"


let manual_shugga_background = """
As explained earlier, when Shugga for Loop is in the background, the app is at a mercy of the operating system. The operating system rations its resources tightly and allows the apps in the background to have less in order to maintain better battery performances and user experiences.

There are a few things that are happening when the app is in the background.

The operating system decides to “wake up” Shugga for Loop at a certain time.

Then the app queries for the latest BG in HealthKit.

It will then shugga that to you accompanied by how old that BG data is.

While the shugga is in progress, CGM/Loop may update your BG entry in HealthKit.

After Shugga for Loop is done with that instance of shugga, it will check once more to see if any new BG data was entered to Health.

If it finds a new data, it will then shugga that immediately after the earlier background Shugga (3).

Eg: “Eight minutes and 12 seconds ago, 112 mg/dL. Up 1.1 mg/dL per minute. Three minutes and 34 seconds ago, 115 mg/dL. Steady*

What had happened here is that when the app was awaken by the system, the latest value in HealthKit was 112 (which was sampled 8 min and 12 seconds ago). While the app is making that announcement, Loop has entered a new value from the CGM to your HealthKit data. Just be mindful of the battery consumption rate.
"""
/*
 
 
 IMPORTANT CONCEPTS WHEN USING THE APP

 Shugga and shugga

 Within the app and this document, the word shugga (lowercase) is used as a verb to express the latest BG reading available in HealthKit data being announced.

 Eg: “Shugga for Loop will shugga every five minutes.

 Meaning: The app will announce the latest BG stored in your HealthKit.

 App Modes

 It's important to understand that there are two main phases of the app you experience and the different exceptions you should have from the app:

 Foreground Mode

 This is when the app is in the foreground and being actively used by you or being left turned on. You can expect the app to behave exactly as you set the parameters in the settings.

 Background Mode

 This is when the app runs in the background while you may be using other apps or when the phone is unlocked but not otherwise being used. The app, when the background mode is turned on, is capable of making the announcement.

 The frequencies of shugga, however, is limited while in this mode. The iPhone’s operating system will dictate when the app can shugga. It has been shown, under some conditions, the app is capable to shugga about every ten minutes. The exact nature of optimizing for this is not well publicized.

 We believe having the iPhone in the following conditions greatly improves the odds of the operating system allowing Shugga for Loop to shugga:

 Having the iPhone with some good battery reserve,
 Having the iPhone being charged
 Having the app higher up in the list of running app order
 Having the app in one of the positions in the doc
 Having good mobile and/or WIFI reception
 Not playing any media in foreground or background
 Having to have used the app often

 We believe all the above conditions will help to get the operating system “feeling relaxed” to spend the resources allowing the app to do its things.

 The app doesn't function when the phone is locked or turned off.
 
 
 
 
 
 
 
 
 
 
 */
