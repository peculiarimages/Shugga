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
    
    @State private var navigateToAboutShugga = false

    
    @AppStorage("whiteBackground")                      public var whiteBackground =                        false
    @AppStorage("theMainViewIsLocked")  public var theMainViewIsLocked =    true
    @AppStorage("theShuggaIsPaused")    public var theShuggaIsPaused =      true
    @AppStorage("grayAppIcon")                      public var grayAppIcon =                        false

    var body: some View {
        
        let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
        
        let theImageWidthRatio = 5.0
        
        
        VStack {

            
            VStack (
                content: {
            
                    
                   
//                    .background(.clear)
//                    Text ("test")
                    
            GeometryReader { geometry in
                
              
//                Spacer()
                VStack {
                    NavigationForHubView()
                        .padding(.bottom, 50)

//                    Spacer()
                    if navigateToAboutShugga {
                        AboutShuggaView(navigateToAboutShugga: $navigateToAboutShugga)
                    } else {
                        
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 20) {
                                
                                VStack {
                                    Image (systemName: "questionmark.circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: geometry.size.width/3, height: geometry.size.width/theImageWidthRatio)
                                        .foregroundColor(.primary)
                                        .opacity(0.7)
                                    
                                    Text("FAQs")
                                        .foregroundColor(.primary)
                                    
                                }
                                .onTapGesture { navigateToAboutShugga = true }
                                
                                
                                    
                                    VStack {
                                        Image (systemName: "newspaper.circle.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: geometry.size.width/3, height: geometry.size.width/theImageWidthRatio)
                                            .opacity(0.7)
                                        
                                        
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
                                
                                
                                    
                                    VStack {
                                        Image (systemName: "video.circle.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: geometry.size.width/3, height: geometry.size.width/theImageWidthRatio)
                                            .opacity(0.7)
                                        
                                        Text("Watch on YouTube")
                                    }
                                
                                
                                    
                                    VStack {
                                        Image (systemName: "paperplane.circle.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: geometry.size.width/3, height: geometry.size.width/theImageWidthRatio)
                                            .opacity(0.7)
                                        
                                        Text("Contact Us")
                                    }
                                
                                
                                    
                                    VStack {
                                        Image (systemName: "heart.circle.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: geometry.size.width/3, height: geometry.size.width/theImageWidthRatio)
                                            .opacity(0.7)
                                        
                                        Text("Acknowledgements")
                                    }
                                
                                
                                    
                                    VStack {
                                        Image (systemName: "lightbulb.circle.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: geometry.size.width/3, height: geometry.size.width/theImageWidthRatio)
                                            .opacity(0.7)
                                        
                                        Text("Why Shugga?")
                                    }
                                
                                
                            }
                            .padding(.all)
                            
                            
                        }
                    }
                    VStack {
                        Image ("outside-center-logotype")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geometry.size.width/3, height: geometry.size.width/theImageWidthRatio)
                        
                        //                               Text("Why Shugga?")
                    }
                    Spacer()
                }
                .padding()
                Spacer()
            } .edgesIgnoringSafeArea(.bottom)
                        .background(whiteBackground ? whiteBackgroundColor : backgroundGradient)
            
            Spacer()
            
        })
            
        }
       
    }
}

struct HubView_Previews: PreviewProvider {
    static var previews: some View {
        HubView()
    }
}
