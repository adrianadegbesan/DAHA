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
        NavigationLink(destination: {}){
            ZStack {
                Image(systemName: "circle.fill")
                    .font(.system(size: 65, weight: .bold))
                    .foregroundColor(.white)
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 65, weight: .bold))
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
