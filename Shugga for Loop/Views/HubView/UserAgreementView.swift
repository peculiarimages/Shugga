//
//  AboutSugah.swift
//  Sugah
//
//  Created by Rodi on 9/25/22.
//

import SwiftUI
import BackgroundTasks





struct UserAgreementHubView: View {

    @Binding var navigateToUserAgreement: Bool

    var body: some View {
        
        
            
            VStack {
                VStack{
                    HStack {
                        
                        Button(action: {
                            navigateToUserAgreement = false
                        }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("Back")
                            }
                        }
//                        .padding()
                        Spacer()
                    }
                    
                 
                    

                    
                    Text ("User Agreement")
                        .bold()
                        .font(.title)
                    UserAgreementView()
                        .padding()
                }
            }
            .navigationBarBackButtonHidden(true)
            .edgesIgnoringSafeArea(.all)
       
    }
}

struct UserAgreementHub_Previews: PreviewProvider {
    static var previews: some View {
        UserAgreementHubView(navigateToUserAgreement: .constant(true))
    }
}
