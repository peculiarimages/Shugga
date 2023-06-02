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
                    navigateToFAQs = false
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
Shugga for Loop should work with G7. However, it has been tested on G6 only. There may be some glitches with its 1 min sampling cycles. Let us know how it works for you.


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
