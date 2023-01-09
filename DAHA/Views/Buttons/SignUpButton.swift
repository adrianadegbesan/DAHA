//
//  SignUpButton.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import SwiftUI

//View for Sign Up Button
struct SignUpButton: View {
    
    var body: some View {
        NavigationLink(destination: SchoolEmailScreen()) {
            ZStack {
                // Blue Button background
                RoundedRectangle(cornerRadius: 33)
                    .fill(Color.init(hex: deepBlue))
                    .frame(width: 202, height: 64)
                
                // Putting Sign Up and Icon side-by-side
                HStack {
                    // Sign Up Text
                    Text("SIGN UP")
                        .font(
                            .system(size:30, weight: .bold)
                        )
                        .foregroundColor(.white)
                        .padding(3)
                    
                    // Person icon
                    Image(systemName: "person.crop.circle.fill.badge.plus")
                        .font(
                            .system(size:30, weight: .bold)
                        )
                        .foregroundColor(.white)
                    
                } //: HStack
                
            } //: ZStack
        } //: Navigation
    }
}

struct SignUpButton_Previews: PreviewProvider {
    static var previews: some View {
        SignUpButton()
            .previewLayout(.sizeThatFits)
    }
}

