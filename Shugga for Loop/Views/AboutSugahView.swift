//
//  AboutSugah.swift
//  Sugah
//
//  Created by Rodi on 9/25/22.
//

import SwiftUI
import BackgroundTasks



func getVersionNumber() -> String{
    
    var config: [String: Any]?

    
    if let infoPlistPath = Bundle.main.url(forResource: "Info", withExtension: "plist") {
        do {
            let infoPlistData = try Data(contentsOf: infoPlistPath)
            
            if let dict = try PropertyListSerialization.propertyList(from: infoPlistData, options: [], format: nil) as? [String: Any] {
                config = dict
            }
        } catch {
            print(error)
        }
    }

//    print(config?["CFBundleName"])
//    // Optional(example-info)
//
//    print(config?["CFBundleVersion"])
//    // Optional(1)
//
//    print(config?["CFBundleShortVersionString"])
//    // Optional(1.0)
    
    
    let CFBundleVersion = String(describing: config!["CFBundleVersion"]!)

    let CFBundleShortVersionString = String(describing: config!["CFBundleShortVersionString"]!)
 
    print ("Shugga Version: " + CFBundleShortVersionString + " (" + CFBundleVersion + ")")
    
         return ("Version: " + CFBundleShortVersionString + "  \nBuild: " + CFBundleVersion)
    // String(describing: $0)
}




func showFunImage () -> Image{
    
    let thePhotoChoice = Bool.random()
    
    if thePhotoChoice == true {
        return Image ("watermelon")

    } else
    {
       return  Image ("blender")
          
    }
    
}

//let logoTypeColor = Color(red: 0.530, green: 0.0, blue: 0.12)


struct AboutSugahView: View {

    var body: some View {
        
        VStack {
            
            
            
            VStack {
                
                Image("logo 3")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .padding([.top, .leading, .trailing], 25)
                
                Text ("Shugga for Loop")
                    .foregroundColor(logoTypeColor)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
            }
                                
            VStack {
                
               Text(getVersionNumber())
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .font(.caption)
                    .padding([.top, .bottom], 2)
            
                Text ("©2023 Outside Center LLC")
                    .font(.caption)
                    .padding(20)

            
            ScrollView {
                
                
                Text ("“Shugga for Loopˮ is not associated with Loop.app nor LoopKit. This version of Shugga is designed to work with HealthKit that is updated by Loop in real-time.")
                    .font(.caption)
                    .padding([.leading, .trailing], 35)

                // Text ("Tweet [@SugahApp](\twitterLink) with all your questions and concerns.")
                 Text(.init("Tweet [\(twitterHandle)](\(twitterLink)) with all your questions and concerns.")) //
                     .foregroundColor(.primary)
                     .padding([.top, .bottom], 12)
                     .padding([.leading, .trailing], 35)
                     .lineLimit(1)
                     .minimumScaleFactor(0.5)
                 
                 Text(pleaseSendUsANote)
                     .foregroundColor(.primary)
                     .padding([.top, .bottom], 5)
                     .padding([.leading, .trailing], 35)
                     .lineLimit(3)
                     .minimumScaleFactor(0.5)
                 
                 Text(.init("[\(webPageLink)](\(webPageLink))")) //
                     .foregroundColor(.primary)
                     .padding([.top, .bottom], 12)
                     .padding([.leading, .trailing], 35)
                     .lineLimit(1)
                     .minimumScaleFactor(0.5)
                
                Text (whatThisAppDoes)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                    .padding([.leading, .trailing], 35)
                    //.padding([.top, .bottom], 3)
                    .frame(alignment: .center)
                    .font(.system(size: 13, design: .rounded))
                
                VStack {
                    
                    Text (legalText)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .padding([.leading, .trailing], 15)
                        .padding([.top, .bottom], 14)
                        .frame(alignment: .center)
                        .font(.system(size: 12, design: .rounded))
    //                    .background (.red)
    //                    .cornerRadius(22)
    //                    .padding([.leading, .trailing], 15)
    //                    .padding(22)
                        .opacity(0.7)
                    
                    showFunImage()
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(22)
                                .padding([.top, .bottom], 12)

                                .padding([.leading, .trailing], 35)
                }
                .background (shuggaRed)
                .cornerRadius(22)
                .padding([.leading, .trailing], 15)
                .padding(22)

                VStack {
                    Text("Bugs:")
                    Text (listOfBugs)
                        .foregroundColor(.orange)
                        .padding([.leading, .trailing], 35)
                        .font(.system(size: 12, design: .rounded))
                    
                    Text ("The future version will have language and accent pickers as well as most voices from the iOS to choose from.")
                        .foregroundColor(.secondary)
                        .padding([.leading, .trailing], 35)
                        .font(.system(size: 12, design: .rounded))
                    //                    ForEach(voiceNames, id: \.self) { voiceName in
                    //
                    //                        Text (voiceName)
                    //                    }
                    Text ("Many thanks to the following individuals who helped me get this far with Shugga:\n\nGlo GLo the Nurse\n\nLocalizations\n\n   Deutsch: My better half Ms. Fritz\n   Italiano: Tiziana\n   한국어: Alex Y.\n   Français: Haruka\n\nMoral Support: \n\n   Henri, everyone's Secret Weapon!!\n   歩く人 Justine, The only Vet I know who actually cares!!\n   Stephen🐤, the only　宇宙人 I know!!\n\nMoral Hazard & LLC: Gregman G.\n\nAnd as for my own type 1 diabetes, thanks to all of you who have supported me the last 20 odd years- including all the fantabulous doctors (1, 2, 3, 4, 5) and all the way to the tech support/accounting peeps at CGM/Pump makers. And lets not foret those of you who created and support Loop.app and LoopKit.  “Thank you all for saving my life.ˮ\n\n Hmmmm, not sure if I should thank my insurance company.... I would need over 30,000 subscriptions a year to cover just the annual premium. And we think that is ok in this country.\n\nAnd for the rest of you, THANK YOU SO MUCH for DOWNLOADING/PURCHASING. It sucks ass to have diabetes. But I hope this little app will make things a tiny bit easier to enjoy life. The only one we've got.❤️")
                        .foregroundColor(.secondary)
                        .padding([.leading, .trailing], 35)
                        .padding([.top, .bottom], 12)
                        .font(.system(size: 12, design: .rounded))
                    
                    Image("thePass")
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(22)
                        .padding([.top, .bottom], 12)
                        .padding([.leading, .trailing], 35)
                    
                    Text ("Now that you've read this far, go get your free lifetime National Parks pass! The only free thing, beside the love from the people around you that is free for us diabetics. (link)\n")
                        .foregroundColor(.secondary)
                        .padding([.leading, .trailing], 35)
                        .padding([.top, .bottom], 12)
                        .font(.system(size: 12, design: .rounded))

                    Text ("Created by:\n\nHiroshi Howell\n\nLob all complaints and grievances to Outside Center LLC, please. I am not responsible for anything...\n\n\n\n\n\n\n")
                        .foregroundColor(.secondary)
                        .padding([.leading, .trailing], 35)
                        .padding([.top, .bottom], 12)
                        .font(.system(size: 12, design: .rounded))
                    
                }
            } //ScrollView
            .overlay(
                LinearGradient(
                    gradient: Gradient(colors: [Color.clear, Color(.systemBackground).opacity(1.0)]),
                       startPoint: .top,
                       endPoint: .bottom
                   )
                .ignoresSafeArea(.all, edges: .bottom)
                .frame(height: 150)
                .padding(.top, -30),
                alignment: .bottom
            )
            
            }
            .padding(5)
        }
    }
}

struct AboutSugah_Previews: PreviewProvider {
    static var previews: some View {
        AboutSugahView()
    }
}
