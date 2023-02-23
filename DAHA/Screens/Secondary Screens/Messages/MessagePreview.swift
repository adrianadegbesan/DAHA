//
//  MessagePreview.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/22/23.
//

import SwiftUI

struct MessagePreview: View {
    
    //State var MessageObject
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        NavigationLink(destination: ChatScreen()){
            VStack{
//                Divider()
                HStack{
                    Text("Image")
                    Spacer().frame(width: screenWidth * 0.05)
                    
                    VStack{
                        Text("@username")
                        HStack{
                            Text("Title")
                                .font(.system(size: 20, weight: .bold))
                            Text("($Price)")
                                .font(.system(size: 16, weight: .bold))
                            
                        }
                        
                        Text("Message")
                    }
                    Spacer()
                    Text("Time")
                    
                }
                .padding()
//                Divider()
            
            }
            .frame(width: screenWidth, height: screenWidth * 0.2)
        }
        .foregroundColor(colorScheme == .dark ? .white : .black)
    
   }
}

struct MessagePreview_Previews: PreviewProvider {
    static var previews: some View {
        MessagePreview()
    }
}
