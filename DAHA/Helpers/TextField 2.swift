//
//  TextField.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import Foundation
import SwiftUI


extension TextField {
    // extension for title text
    func inputFields() -> some View {
        self
            .background(RoundedRectangle(cornerRadius: 5).fill(Color.white))
        .frame(width: screenWidth * 0.9)
        .padding(.horizontal, 40)
    }
    
}
