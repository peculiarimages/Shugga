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
        
        HStack (alignment: .top){
            VStack{
                Button(action: {
                    withAnimation(.easeOut(duration: hubViewEaseBackToDuration)) {
                        
                        navigateToUserAgreement = false
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
            
            
            
            
            Text ("User Agreement")
                .bold()
                .font(.title)
            UserAgreementView()
                .padding()
        }
        .navigationBarBackButtonHidden(true)
        .edgesIgnoringSafeArea(.bottom)

    }
}

struct UserAgreementHub_Previews: PreviewProvider {
    static var previews: some View {
        UserAgreementHubView(navigateToUserAgreement: .constant(true))
    }
}
