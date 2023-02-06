//
//  PostButton.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import SwiftUI

//Button used to go to Posts Screen
struct PostButton: View {
    
    @State var shouldNavigate : Bool = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        Button(action: {
            MediumFeedback()
            shouldNavigate = true
        }){
                ZStack {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 65, weight: .bold))
                    
                    NavigationLink(destination: MakePostScreen(), isActive: $shouldNavigate){
                        EmptyView()
                    }
                }
                .foregroundColor(.black)
                .background(Circle().fill(.white).scaleEffect(colorScheme == .dark ? 0.9 : 0.8))
            }
        }
    }


struct PostButton_Previews: PreviewProvider {
    static var previews: some View {
        PostButton()
            .previewLayout(.sizeThatFits)
    }
}
