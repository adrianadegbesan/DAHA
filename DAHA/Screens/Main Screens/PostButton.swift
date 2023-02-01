//
//  PostButton.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import SwiftUI

//Button used to go to Posts Screen
struct PostButton: View {
    var body: some View {
        NavigationLink(destination: MakePostScreen()){
            ZStack {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 75, weight: .bold))
            }
        } .foregroundColor(.black)
    }
}

struct PostButton_Previews: PreviewProvider {
    static var previews: some View {
        PostButton()
            .previewLayout(.sizeThatFits)
    }
}
