//
//  ShimmerPost.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 5/9/23.
//

import SwiftUI
import Shimmer

struct PostShimmer: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Text("DAHA               ")
                    .font(.system(size: 28, weight: .bold))
                    .redacted(reason: .placeholder)
                    .shimmering()
                Text("                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           ")
                    .font(.system(size: 21))
                    .redacted(reason: .placeholder)
                    .shimmering()
                    
            }
        }
        .frame(width: screenWidth * 0.902, height: 170)
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder( (colorScheme == .dark ? .gray : .black), lineWidth: colorScheme == .dark ? 2 : 2)
        )
        .background(colorScheme == .dark ? .black.opacity(0.7): .white)
        .cornerRadius(20)
        .shimmering()
    }
}

struct PostShimmer_Previews: PreviewProvider {
    static var previews: some View {
        PostShimmer()
    }
}
