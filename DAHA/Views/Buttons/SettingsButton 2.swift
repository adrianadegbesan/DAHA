//
//  SettingsButton.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import SwiftUI

struct SettingsButton: View {
    var body: some View {
        NavigationLink(destination: {}) {
            Image(systemName: "gearshape")
                .headerImage()
        }
        .foregroundColor(.black)
    }
}

struct SettingsButton_Previews: PreviewProvider {
    static var previews: some View {
        SettingsButton()
    }
}
