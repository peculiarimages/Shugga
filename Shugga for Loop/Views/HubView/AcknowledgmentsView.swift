//
//  AboutSugah.swift
//  Sugah
//
//  Created by Rodi on 9/25/22.
//

import SwiftUI
import BackgroundTasks





struct AcknowledgmentsView: View {

    @Binding var navigateToAcknowledgement: Bool

    var body: some View {
        
        HStack (alignment: .top){
            VStack{
                Button(action: {
                    navigateToAcknowledgement = false
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
        
        VStack{
          
            Section() {
                ScrollView {
                    VStack {
                        
                        Text ("Acknowledgments")
                            .bold()
                            .font(.headline)
                            .padding([.bottom], 5)
                        
                        Text (acknowledgementText)
                            .foregroundColor(.primary)
                            .padding([.leading, .trailing], 35)
                            .padding([.top, .bottom], 12)
                        
                        Image("thePass")
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(22)
                            .padding([.top, .bottom], 12)
                            .padding([.leading, .trailing], 35)
                        
                        Text (nationalParksText)
                            .foregroundColor(.primary)
                            .padding([.leading, .trailing], 35)
                            .padding([.top], 12)
                        
                        Text("- end - ")
                            .padding([.leading, .trailing, .bottom])
                            .opacity(0.66)


                    }
                    
                }
            }
            .navigationBarBackButtonHidden(true)
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct Acknowledgments_Previews: PreviewProvider {
    static var previews: some View {
        AcknowledgmentsView(navigateToAcknowledgement: .constant(true))
    }
}
