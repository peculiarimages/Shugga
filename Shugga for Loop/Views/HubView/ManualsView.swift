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
                    withAnimation(.easeOut(duration: hubViewEaseBackToDuration)) {
                        
                        navigateToManuals = false
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
                
                Text ("ShuggaShugga Docs")
                    .bold()
                    .font(.title)
            Text ("IMPORTANT CONCEPTS WHEN USING THE APP")
                .bold()
                .font(.headline)
                .padding(5)
            
                ScrollView {
                    
                    Section(header: Text("Shugga and shugga")
                        .bold()
                        .padding()
                    ) {
                        Text(manuals_Shugga_and_shugga)
                            .padding()
                    }
                    
                    
                    Section(header: Text(manuals_foreground_background_subheadline)
                        .bold()
                        .padding()
                    ) {
                        Text(manuals_foreground_background)
                            .padding()
                        
                        Text(manual_foreground_background_explained)
                            .padding()

                        Text(manual_foreground_background_optimization)
                            .padding()

                        Text(manual_foreground_background_belief)
                            .padding()

                        Text (manual_doesnt_work_locked)
                            .padding()

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
