//
//  UILoadingImage.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 3/29/23.
//

import SwiftUI

struct UILoadingImage: View {
    
    @State var uiImage : UIImage
    @State private var isAnimating : Bool = false
    var body: some View {
        
        Image(uiImage: uiImage)
            .resizable()
            .scaledToFit()
            .cornerRadius(12)
            .overlay{
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.primary, lineWidth: 2)
            }
            .frame(maxWidth: 180)
            .scaleEffect(isAnimating ? 1.1 : 1.0)
            .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 1), value: isAnimating)
            .onTapGesture {
                 SoftFeedback()
                 isAnimating = true
                 DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    isAnimating = false
                 }
             }
            .padding(.horizontal, 10)
    }
}


