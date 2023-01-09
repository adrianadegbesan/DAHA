//
//  DMButton.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import SwiftUI

// Button used to go to DM Page
struct DMButton: View {
    var body: some View {
        NavigationLink(destination: {}) {
            Image(systemName: "paperplane.fill")
                .headerImage()
        }
        .foregroundColor(.black)
    }
}

struct DMButton_Previews: PreviewProvider {
    static var previews: some View {
        DMButton()
    }
}
