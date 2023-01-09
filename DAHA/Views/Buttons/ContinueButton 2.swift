//
//  ContinueButton.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import SwiftUI

struct ContinueButton: View {
    
    @Binding var schoolFound: Bool
    @Binding var isPresented: Bool
    
    var body: some View {
        Button(action: {
            if !schoolFound {
                isPresented = true
            }
        } ) {
            ZStack {
                // Blue Button background
                RoundedRectangle(cornerRadius: 33)
                    .fill(Color.init(hex: deepBlue))
                    .frame(width: 180, height: 55)
            
                HStack {
                    // Continue Text
                    Text("CONTINUE")
                        .font(
                            .system(size:20, weight: .bold)
                        )
                        .foregroundColor(.white)
                        .padding(3)
                } //: HStack
            } //: ZStack
        } //: Button
    }
}

struct ContinueButton_Previews: PreviewProvider {
    static var previews: some View {
        ContinueButton(schoolFound: .constant(false), isPresented: .constant(false))
            .previewLayout(.sizeThatFits)
    }
}
