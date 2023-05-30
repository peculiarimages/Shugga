//
//  HubView.swift
//  Shugga for Loop
//
//  Created by Rodi on 5/28/23.
//

import SwiftUI



struct NavigationForHubView: View {
    
    var body: some View {
        
        HStack {
            /*
            VStack {
                //                        NavigationLink(destination: GlucoseValueView()) {
                NavigationLink(destination: SubscriptionsView()) {
                    
                    Image(systemName: "cart.circle.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: 30))
                        .opacity(0.4)
                    //.padding([.top, .leading, .trailing], 10)
                        .accessibilityLabel(_: "")
                }
            }
            .frame (width: 75)
            .padding()
            */
            
            VStack {
                Text("")
            }
            .frame (width: 75)
            .padding([.leading, .trailing], 5)
            
            Spacer()
            
            VStack{
                    
                    HStack {
                        VStack {
                            Image("logo 3")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .padding([.top, .leading, .trailing], 10)
                                .accessibilityLabel(_: "This is the logo of this app. It' a red rounded rectangle with a white speech bubble inside with a tiny red blood droplet inside it. This takes you to the settings.")
                            
                            Text ("Shugga for Loop")
                                .foregroundColor(logoTypeColor)
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                .accessibilityLabel(_: "\"S U G G A H\" is how we spell this app's name. This accessibility label reader says Shugga")
                                .lineLimit(1)
                                 .truncationMode(.tail)
                        }
                    
                }
            }
            .frame (width: 200)
            .padding([.leading, .trailing], 5)
            .background(.clear)

            Spacer()
            
            VStack {
                Text("")

            }
            .frame (width: 75)
            .padding([.leading, .trailing], 5)

        }
        
        
        
        
    }
}


struct HubView: View {
    
    let rotationPeriod =  0.3
    let rotationEarlyCutOffBy = 0.02

    @State private var navigateToAboutShugga = false
    @State private var aboutShuggaIsRotating = false

    @State private var navigateToFAQs = false
    @State private var faqsIsRotating = false

    
    @State private var youTubeIsRotating = false

    @State private var navigateToManuals = false
    @State private var manualsIsRotating = false
    
    @State private var navigateToAcknowledgement = false
    @State private var acknowledgementIsRotating = false

    @State private var kiyoshiIsRotating = false

    
    
    
    
    
    @AppStorage("whiteBackground")                      public var whiteBackground =                        false
    @AppStorage("theMainViewIsLocked")  public var theMainViewIsLocked =    true
    @AppStorage("theShuggaIsPaused")    public var theShuggaIsPaused =      true
    @AppStorage("grayAppIcon")                      public var grayAppIcon =                        false

    var body: some View {
        
        let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
        
        let theImageWidthRatio = 7.0
        
        
        VStack {

            
          
            
                    
                   
//                    .background(.clear)
//                    Text ("test")
                    
            GeometryReader { geometry in
                
              
//                Spacer()
                VStack {
//                    Spacer()
                    NavigationForHubView()
                        .padding(.bottom, 50)

//                    Spacer()
                    if navigateToAboutShugga {
                        AboutShuggaView(navigateToAboutShugga: $navigateToAboutShugga)
                    }
                    else if navigateToFAQs {
                        FAQsView(navigateToFAQs: $navigateToFAQs)
                    }
                    else if navigateToManuals {
                        ManualsView(navigateToManuals: $navigateToManuals)
                    }
                    else if navigateToAcknowledgement {
                        AcknowledgmentsView(navigateToAcknowledgement: $navigateToAcknowledgement)

                        
                    }
                    
                    else {
                        
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 20) {
                                
                          
                                
                                
                                VStack {
                                    Image(systemName: "info.circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: geometry.size.width/theImageWidthRatio, height: geometry.size.width/theImageWidthRatio)                                        .foregroundColor(.primary)
                                        .opacity(aboutShuggaIsRotating ? 0 : 0.7) // Fade out when rotating
                                        .rotationEffect(.degrees(aboutShuggaIsRotating ? 360 : 0))
                                        .onTapGesture {
                                            withAnimation(.linear(duration: rotationPeriod)) {
                                                aboutShuggaIsRotating.toggle()
                                            }
                                            
                                            DispatchQueue.main.asyncAfter(deadline: .now() + rotationPeriod - rotationEarlyCutOffBy) {
                                                navigateToAboutShugga = true
                                                withAnimation {
                                                    aboutShuggaIsRotating = false
                                                }
                                            }
                                        }
                                    
                                    Text("About...")
                                        .foregroundColor(.primary)
                                }

                       
                                
                                VStack {
                                    Image (systemName: "questionmark.circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: geometry.size.width/theImageWidthRatio, height: geometry.size.width/theImageWidthRatio)                                        .foregroundColor(.primary)
                                        .opacity(faqsIsRotating ? 0 : 0.7) // Fade out when rotating
                                        .rotationEffect(.degrees(faqsIsRotating ? 360 : 0))
                                        .onTapGesture {
                                            withAnimation(.linear(duration: rotationPeriod)) {
                                                faqsIsRotating.toggle()
                                            }
                                            
                                            DispatchQueue.main.asyncAfter(deadline: .now() + rotationPeriod - rotationEarlyCutOffBy) {
                                                navigateToFAQs = true
                                                withAnimation {
                                                    faqsIsRotating = false
                                                }
                                            }
                                        }
                                    
                                    Text("FAQs")
                                        .foregroundColor(.primary)
                                    
                                }
                                    
                                    VStack {
                                        Image (systemName: "newspaper.circle.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: geometry.size.width/theImageWidthRatio, height: geometry.size.width/theImageWidthRatio)                                            .foregroundColor(.primary)
                                            .opacity(manualsIsRotating ? 0 : 0.7) // Fade out when rotating
                                            .rotationEffect(.degrees(manualsIsRotating ? 360 : 0))
                                            .onTapGesture {
                                                withAnimation(.linear(duration: rotationPeriod)) {
                                                    manualsIsRotating.toggle()
                                                }
                                                
                                                DispatchQueue.main.asyncAfter(deadline: .now() + rotationPeriod - rotationEarlyCutOffBy) {
                                                    navigateToManuals = true
                                                    withAnimation {
                                                        manualsIsRotating = false
                                                    }
                                                }
                                            }
                                        
                                        
                                        Text("Documentation")
                                    }
                                
                                
                                    
                                    VStack {
                                        Image (systemName:"building.columns.circle.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: geometry.size.width/3, height: geometry.size.width/theImageWidthRatio)
                                            .opacity(0.7)
                                        
                                        Text("User Agreement")
                                    }
                                
                                
                                    
                                Link(destination: URL(string: youTubePlayListLink)!) {
                                    VStack {
                                        Image(systemName: "video.circle.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: geometry.size.width/theImageWidthRatio, height: geometry.size.width/theImageWidthRatio)                                            .foregroundColor(.primary)
                                            .opacity(youTubeIsRotating ? 0 : 0.7) // Fade out when rotating
                                            .rotationEffect(.degrees(youTubeIsRotating ? 360 : 0))
                                        
                                        Text("Watch on YouTube")
                                            .foregroundColor(.primary)
                                    }
                                    .onTapGesture {
                                        withAnimation(.linear(duration: rotationPeriod)) {
                                            youTubeIsRotating.toggle()
                                        }
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + rotationPeriod) {
                                            UIApplication.shared.open(URL(string: youTubePlayListLink)!, options: [:], completionHandler: nil)
                                            withAnimation {
                                                youTubeIsRotating = false
                                            }
                                        }
                                    }
                                }


                                
                                
                                    
                                    VStack {
                                        Image (systemName: "paperplane.circle.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: geometry.size.width/theImageWidthRatio, height: geometry.size.width/theImageWidthRatio)                                            .opacity(0.7)
                                        
                                        Text("Contact Us")
                                    }
                                
                                
                                    
                                    VStack {
                                        Image (systemName: "heart.circle.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: geometry.size.width/theImageWidthRatio, height: geometry.size.width/theImageWidthRatio)                                            .foregroundColor(.primary)
                                            .opacity(acknowledgementIsRotating ? 0 : 0.7) // Fade out when rotating
                                            .rotationEffect(.degrees(acknowledgementIsRotating ? 360 : 0))
                                            .onTapGesture {
                                                withAnimation(.linear(duration: rotationPeriod)) {
                                                    acknowledgementIsRotating.toggle()
                                                }
                                                
                                                DispatchQueue.main.asyncAfter(deadline: .now() + rotationPeriod - rotationEarlyCutOffBy) {
                                                    navigateToAcknowledgement = true
                                                    withAnimation {
                                                        acknowledgementIsRotating = false
                                                    }
                                                }
                                            }
                                        
                                        Text("Acknowledgements")
                                    }

                                
                                    
                                    VStack {
                                        Image (systemName: "lightbulb.circle.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: geometry.size.width/theImageWidthRatio, height: geometry.size.width/theImageWidthRatio)
                                            .opacity(0.7)
                                        
                                        Text("Why Shugga?")
                                    }
                                
                                
                            }
                            .padding(.all)
                            
                            Spacer()
                            
                            HStack {
                                Spacer()
                                Spacer()

                                YouGotDis()
                                
                                    .opacity(kiyoshiIsRotating ? 0 : 0.7) // Fade out when rotating
                                    .rotationEffect(.degrees(kiyoshiIsRotating ? 360 : 0))
                                    .onTapGesture {
                                        withAnimation(.linear(duration: rotationPeriod)) {
                                            kiyoshiIsRotating.toggle()
                                        }
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + rotationPeriod - rotationEarlyCutOffBy) {
                                            kiyoshiIsRotating = true
                                            withAnimation {
                                                kiyoshiIsRotating = false
                                            }
                                        }
                                    }
                                
                                Spacer()
                                VStack {
                                    Image ("outside-center-logotype")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: geometry.size.width/2, height: geometry.size.width/2)
                                    
                                    //                               Text("Why Shugga?")
                                }
                                Spacer()

                            }
                            .padding ()
                            
                        }
                    }
                    
                  
                    
                    Spacer()
                }
                .padding()
                Spacer()
            } .edgesIgnoringSafeArea(.bottom)
                        .background(whiteBackground ? whiteBackgroundColor : backgroundGradient)
            
            
            
        }
        .edgesIgnoringSafeArea(.bottom)

    }
}

struct HubView_Previews: PreviewProvider {
    static var previews: some View {
        HubView()
    }
}