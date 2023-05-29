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
        
        
            
            VStack {
                HStack {
                    
                    Button(action: {
                        navigateToAboutShugga = false
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                    }
                    .padding()
                    Spacer()
                }
                // The rest of your view content goes here
                Text("About Sugah Content")
                    .font(.title)
                    .padding()
            }
            
            
            
            
            
        
        .edgesIgnoringSafeArea(.bottom)
//        .navigationBarHidden(true)  // This hides the default navigation bar

    }
}

struct AboutShugga_Previews: PreviewProvider {
    static var previews: some View {
        AboutShuggaView(navigateToAboutShugga: .constant(true))
    }
}
