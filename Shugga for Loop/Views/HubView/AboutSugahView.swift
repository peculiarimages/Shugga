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

    @Binding var navigateToAboutShugga: Bool

    var body: some View {
        
        
        VStack {
            
            
            VStack {
                Button(action: {
                    navigateToAboutShugga = false
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                }
                .padding()
                
                // The rest of your view content goes here
                Text("About Sugah Content")
                    .font(.title)
                    .padding()
            }
            
            
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
                
                
                Text (whatThisAppDoes)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                    .padding([.leading, .trailing], 35)
                    .padding([.top, .bottom], 3)
                    .frame(alignment: .center)
                    .font(.system(size: 13, design: .rounded))
                
                Link("CLick here to see the playlist of all the videos we made for the app on YouTube", destination: URL(string: "https://youtube.com/playlist?list=PLk5rQBc5hAiMtojLe-aJYYALgaHOT1UGn")!)
                    .padding([.leading, .trailing], 35)

                Text("")
                
                Text (disclaimerBoilerplate)
                    .font(.caption)
                    .padding([.leading, .trailing], 35)


                Link("Read about loop in LoopDocs here", destination: URL(string: "https://loopkit.github.io/loopdocs/")!)

                // Text ("Tweet [@SugahApp](\twitterLink) with all your questions and concerns.")
//                 Text(.init("Tweet [\(twitterHandle)](\(twitterLink)) with all your questions and concerns.")) //
//                     .foregroundColor(.primary)
//                     .padding([.top, .bottom], 12)
//                     .padding([.leading, .trailing], 35)
//                     .lineLimit(1)
//                     .minimumScaleFactor(0.5)
                 
                 Text(pleaseSendUsANote)
                    .font(.caption)
                     .foregroundColor(.primary)
                     .padding([.top, .bottom], 5)
                     .padding([.leading, .trailing], 35)
//                     .lineLimit(3)
//                     .minimumScaleFactor(0.5)
                 
                 Text(.init("[\(webPageLink)](\(webPageLink))")) //
                     .foregroundColor(.primary)
                     .padding([.top, .bottom], 12)
                     .padding([.leading, .trailing], 35)
                     .lineLimit(1)
                     .minimumScaleFactor(0.5)
                
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
                    Text("Known bugs and future plans:")
                    Text (listOfBugs)
//                        .foregroundColor(.orange)
                        .padding([.leading, .trailing], 35)
                        .font(.system(size: 12, design: .rounded))
                        .padding([.top, .bottom], 12)

                    
                   
                    AcknowledgmentsSettingsView()

                    Image("rodi-nobackground")
                        .resizable()
                        .frame(width: 100, height: 100)
//                        .padding([.top, .leading, .trailing], 5)
                    
//                    Text (whyShugga)
//                        .foregroundColor(.secondary)
//                        .padding([.leading, .trailing], 35)
//                        .padding([.top], 12)
//                        .font(.system(size: 14, design: .rounded))
                    
                    Text ("Lob all complaints and grievances to Outside Center LLC, please. I am not responsible for anything...\n\n\n\n\n\n\n")
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
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarHidden(true)  // This hides the default navigation bar

    }
}

struct AboutSugah_Previews: PreviewProvider {
    static var previews: some View {
        AboutSugahView(navigateToAboutShugga: .constant(true))
    }
}
