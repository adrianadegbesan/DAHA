//
//  ImageIndicator.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/17/23.
//

import SwiftUI

struct ImageIndicator: View {
    @Binding var index: Int
    @State var my_index : Int
    
    var body: some View {
        if index == my_index{
            Image(systemName: "circle.fill")
                .foregroundColor(Color(hex: deepBlue))
                .font(.system(size: 8, weight: .bold))
        } else {
            Image(systemName: "circle.fill")
                .foregroundColor(Color(hex: "D1D0CE"))
                .font(.system(size: 8, weight: .bold))
                .onTapGesture {
                    index = my_index
                }
        }
    }
}

struct ImageIndicator_Previews: PreviewProvider {
    static var previews: some View {
        ImageIndicator(index: .constant(0), my_index: 0)
    }
}
