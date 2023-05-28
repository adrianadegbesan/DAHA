//
//  PostShimmerScroll.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 5/9/23.
//

import SwiftUI

struct PostShimmerScroll: View {
    var body: some View {
        VStack{
            ForEach(1..<10) { i in
                PostShimmer()
                    .padding(.horizontal, 5)
                    .padding(.bottom, 10)
            }
        }
    }
}

struct PostShimmerScroll_Previews: PreviewProvider {
    static var previews: some View {
        PostShimmerScroll()
    }
}
