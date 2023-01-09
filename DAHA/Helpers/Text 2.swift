//
//  Text.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import Foundation
import SwiftUI


extension Text {
    // extension for title text
    func titleText() -> some View {
        self
        .font(
            .system(size:20, weight: .bold)
        )
    }
    
    // extension for channel text
    func channelText() -> some View {
        self
            .font(
                .system(size:20, weight: .bold)
        )
            .foregroundColor(.white)
    }    
}
