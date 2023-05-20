//
//  SafetyMessageView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 5/20/23.
//

import SwiftUI

struct SafetyMessageView: View {
    var body: some View {
        (
         Text("STAY SAFE")
                .foregroundColor(Color(hex: deepBlue)) +
         Text(": Choose to meet in only ")
                .foregroundColor(.secondary)  +
         Text("open ")
            .foregroundColor(Color(hex: color_new)) +
         Text(", ")
            .foregroundColor(.secondary) +
         Text("well-lit")
            .foregroundColor(Color(hex: color_new)) +
         Text(", ")
            .foregroundColor(.secondary) +
         Text("public ")
            .foregroundColor(Color(hex: color_new)) +
         Text("areas and never share ")
            .foregroundColor(.secondary) +
         Text("personal")
            .foregroundColor(.red) +
         Text(" or ")
            .foregroundColor(.secondary) +
         Text("sensitive")
            .foregroundColor(.red) +
         Text(" information in the chat.")
            .foregroundColor(.secondary)
        )
            
            .font(.system(size: 11, weight: .bold))
            .padding(.horizontal, 15)
            .padding(.bottom, 15)
    }
}

struct SafetyMessageView_Previews: PreviewProvider {
    static var previews: some View {
        SafetyMessageView()
    }
}
