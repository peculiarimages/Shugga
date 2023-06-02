//
//  AboutSugah.swift
//  Sugah
//
//  Created by Rodi on 9/25/22.
//

import SwiftUI
import BackgroundTasks





struct ManualsView: View {

    @Binding var navigateToManuals: Bool

    var body: some View {
        
     
        HStack (alignment: .top){
            VStack{
                Button(action: {
                    navigateToManuals = false
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
                
                Text ("Shugga for Loop Docs")
                    .bold()
                    .font(.title)
                ScrollView {
                    
                    VStack {
                        Text ("IMPORTANT CONCEPTS WHEN USING THE APP")
                            .bold()
                            .font(.headline)
                            .padding([.bottom], 5)                    // The rest of your view content goes here
                        
                        Text ("Shugga and shugga")
                            .bold()
                            .font(.subheadline)
                            .padding([.bottom], 5)
                        
                        Text(manuals_Shugga_and_shugga)
                            .padding([.leading, .trailing, .bottom])
                        
                        
                        
                        
                        Text (manuals_foreground_background_subheadline)
                            .bold()
                            .font(.subheadline)
                            .padding([.bottom], 5)
                        
                        Text(manuals_foreground_background)
                            .padding([.leading, .trailing, .bottom])
                        
                        Text(manual_foreground_background_explained)
                            .padding([.leading, .trailing, .bottom])
                        
                        Text(manual_foreground_background_optimization)
                            .padding([.leading, .trailing, .bottom])
                        
                        
                        
                        Text(manual_foreground_background_belief)
                            .padding([.leading, .trailing, .bottom])
                        
                        
                        
                        
                        Text (manual_doesnt_work_locked)
                            .bold()
                            .font(.headline)
                            .foregroundColor(shuggaRed)
                            .padding([.bottom], 5)
                        
                    }
                    
                    VStack {
                        
                        Text (manual_shugga_foreground_subhedline)
                            .bold()
                            .font(.subheadline)
                            .padding([.bottom], 5)
                        
                        Text(manual_shugga_foreground)
                            .padding([.leading, .trailing, .bottom])
                        
                        Text (manual_shugga_background_subhedline)
                            .bold()
                            .font(.subheadline)
                            .padding([.bottom], 5)
                        
                        Text(manual_shugga_background)
                            .padding([.leading, .trailing, .bottom])
                        
                        Text (manual_foreground_background_suggestion)
                            .bold()
                            .font(.headline)
                            .foregroundColor(shuggaRed)
                            .padding([.bottom], 5)
                        
                    }
                    Text("- end - ")
                        .padding([.leading, .trailing, .bottom])
                        .opacity(0.66)

                    
                }
                .padding()
                
//                    Spacer(fon)
            
        }
        .navigationBarBackButtonHidden(true)
        .edgesIgnoringSafeArea(.bottom)

        
        
        
    }
}

struct AManuals_Previews: PreviewProvider {
    static var previews: some View {
        ManualsView(navigateToManuals: .constant(true))
    }
}
