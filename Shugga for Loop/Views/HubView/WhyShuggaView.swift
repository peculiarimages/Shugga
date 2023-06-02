//
//  AboutSugah.swift
//  Sugah
//
//  Created by Rodi on 9/25/22.
//

import SwiftUI
import BackgroundTasks





struct WhyShuggaView: View {

    @Binding var navigateToWhyShugga: Bool

    var body: some View {
        
        HStack (alignment: .top){
            VStack{
                Button(action: {
                    navigateToWhyShugga = false
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
                    
                    Text ("Why Shugga?")
                        .bold()
                        .font(.title)
                    ScrollView {
                        // The rest of your view content goes here
                        
                           Text(whyShugga_1)
                               .padding([.leading, .trailing])

                        
                        
                        
                        Image ("bodegabay")
                            .resizable()
                                .aspectRatio(contentMode: .fit)
                        
                        
                        
                        
                        
                        Text(whyShugga_2)
                            .padding([.leading, .trailing, .bottom])
                        
                        
                        Image ("seagull")
                            .resizable()
                                .aspectRatio(contentMode: .fit)
                        
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

struct WhyShugga_Previews: PreviewProvider {
    static var previews: some View {
        WhyShuggaView(navigateToWhyShugga: .constant(true))
    }
}
