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
        VStack{
            HStack {
                
                Button(action: {
                    navigateToAcknowledgement = false
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                }
                //                        .padding()
                Spacer()
            }
            
            Section(header: Text("Acknowledgments")) {
                ScrollView {
                    VStack {
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
                        

                    }
                    
                }
            }
            .navigationBarBackButtonHidden(true)
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct Acknowledgments_Previews: PreviewProvider {
    static var previews: some View {
        AcknowledgmentsView(navigateToAcknowledgement: .constant(true))
    }
}
