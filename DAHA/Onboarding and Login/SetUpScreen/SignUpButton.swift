//
//  SignUpButton.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import SwiftUI

//View for Sign Up Button
struct SignUpButton: View {
    
    @State var shouldNavigate: Bool = false
    
    var body: some View {
//        NavigationLink(destination: SchoolEmailScreen()
//            .navigationTitle("")){
        Button(action: {
            MediumFeedback()
            shouldNavigate = true
        }) {
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
                NavigationLink(destination: SchoolEmailScreen().navigationTitle(""), isActive: $shouldNavigate){
                    EmptyView()
                }
                    
            }
        } //: ZStack
//        } //: Navigation
    }
}

struct SignUpButton_Previews: PreviewProvider {
    static var previews: some View {
        SignUpButton()
            .previewLayout(.sizeThatFits)
    }
}

