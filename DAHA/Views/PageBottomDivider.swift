//
//  PageBottomDivider.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/30/23.
//

import SwiftUI

struct PageBottomDivider: View {
    var body: some View {
        Divider()
            .frame(maxHeight: 2)
            .overlay(Color(hex: darkGrey))
            .padding(.bottom, 7)
    }
}

struct PageBottomDivider_Previews: PreviewProvider {
    static var previews: some View {
        PageBottomDivider()
    }
}
