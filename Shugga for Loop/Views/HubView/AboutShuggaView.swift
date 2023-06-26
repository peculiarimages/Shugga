//
//  AboutSugah.swift
//  Sugah
//
//  Created by Rodi on 9/25/22.
//

import SwiftUI
import BackgroundTasks




struct AboutShuggaView: View {
    
    @Binding var navigateToAboutShugga: Bool
    
    var body: some View {
        
        HStack (alignment: .top){
            VStack{
                Button(action: {
                    withAnimation(.easeOut(duration: hubViewEaseBackToDuration)) {
                        navigateToAboutShugga = false
                    }                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                        
                    }
                }
            }
            .frame (width: 75)
            
            SubHubViewTopMenuLogoPortionView()

        }
//        .padding()
        
        
        VStack {
            
            Text(getVersionNumber())
                 .multilineTextAlignment(.center)
                 .foregroundColor(.secondary)
                 .font(.caption)
                 .padding([.top, .bottom], 2)
         
             Text ("©2023 Outside Center LLC")
                 .font(.caption)
        }
        .padding()
        
        VStack{
            
            
            
            
            
//
//            Text ("About ShuggaShugga")
//                .bold()
//                .font(.title)
            ScrollView {
                VStack {
                    Section(header: Text("About Shugga")
                        .bold()
                        .padding()
                    ) {
                        Text(aboutShuggaText)
                            .padding()
                    }
                    
                    Section(header: Text("Disclaimer")
                        .bold()
                        .padding()
                    ) {
                        Text(shuggaIndependentAppDisclaimer)
                            .padding([.leading, .trailing, .bottom])
                    }

                    Section(header: Text("Your Privacy")
                        .bold()
                        .padding()
                    ) {
                        Text(aboutPrivacy)
                            .padding()
                    }

                    Section(header: Text("Health Permissions")
                        .bold()
                        .padding()
                    ) {
                        Text(aboutHealthKitPermissions)
                            .padding()
                        Image ("health_permissions")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }

                    Section(header: Text("Background App Refresh")
                        .bold()
                        .padding()
                    ) {
                        Text(aboutAppInBackgroundSetting)
                            .padding()
                        Image ("background_appRefresh")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }

                    Section {
                        Text("- end -")
                            .padding()
                            .opacity(0.66)
                    }
                }
            }


            .padding()
            
            //                    Spacer(fon)
        }
        
        .navigationBarBackButtonHidden(true)
        //            .edgesIgnoringSafeArea(.all)
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct AboutShugga_Previews: PreviewProvider {
    static var previews: some View {
        AboutShuggaView(navigateToAboutShugga: .constant(true))
    }
}
