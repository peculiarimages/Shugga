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
                    navigateToAboutShugga = false
                }) {
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
            
            
            
            
            
            
            Text ("About Shugga for Loop")
                .bold()
                .font(.title)
            ScrollView {
                // The rest of your view content goes here
                
                Text(aboutShuggaText)
                    .padding([.leading, .trailing, .bottom])
                
                Text(shuggaIndependentAppDisclaimer)
                    .padding([.leading, .trailing, .bottom])
                
                Text ("Your Privacy")
                    .bold()
                    .font(.subheadline)
                    .padding([.bottom], 5)
                
                Text(aboutPrivacy)
                    .padding([.leading, .trailing, .bottom])
                
                Text(aboutHealthKitPermissions)
                    .padding([.leading, .trailing, .bottom])
                
                
                Image ("health_permissions")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                Text ("Background App Refresh ")
                    .bold()
                    .font(.subheadline)
                    .padding([.bottom], 5)
                
                Text(aboutAppInBackgroundSetting)
                    .padding([.leading, .trailing, .bottom])
                Image ("background_appRefresh")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Text("- end - ")
                    .padding([.leading, .trailing, .bottom])
                    .opacity(0.66)
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
