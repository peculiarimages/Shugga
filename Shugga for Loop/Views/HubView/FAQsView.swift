//
//  AboutSugah.swift
//  Sugah
//
//  Created by Rodi on 9/25/22.
//

import SwiftUI
import BackgroundTasks





struct FAQsView: View {
    
    @Binding var navigateToFAQs: Bool
    
    var body: some View {
        
        HStack (alignment: .top){
            VStack{
                Button(action: {
                    withAnimation(.easeOut(duration: hubViewEaseBackToDuration)) {
                        
                        navigateToFAQs = false
                    }
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
        .padding()
        
        VStack {
            
            Text ("FAQs")
                .bold()
                .font(.title)
            ScrollView {
                // The rest of your view content goes here
                
                
                Text("Does it work with Dexcom G7?")
                    .padding([.leading, .trailing, .bottom])
                    .font(.title2)
                
                Text("""
Yes, But if you go back to using G6 after G7, you may need to delete the G7 app and re-sync the G6 using your Loop.app if the trend is no longer available on ShuggaShugga.app. You can check if the trend is missing by checking the latest blood glucose entry in the Health: Blood Glucose: Show All Data. It should have an entry for "...GlucoseTrendRateValue".

""")
                .padding([.leading, .trailing, .bottom])
                
                
                Text("What does 'Just now...' mean?")
                    .padding([.leading, .trailing, .bottom])
                    .font(.title2)
                
                Text("""
It means ShuggaShugga has read the latest blood glucose from Health and it is less than 15 seconds old from the time it was sampled.

""")
                .padding([.leading, .trailing, .bottom])
                
                
                
                
                Text("- end - ")
                    .padding([.leading, .trailing, .bottom])
                    .opacity(0.66)
                
            }
            .padding()
            
            //                    Spacer()
            
        }
        .navigationBarBackButtonHidden(true)
        .edgesIgnoringSafeArea(.bottom)
        
    }
}

struct FAQs_Previews: PreviewProvider {
    static var previews: some View {
        FAQsView(navigateToFAQs: .constant(true))
    }
}
