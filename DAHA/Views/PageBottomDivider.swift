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
            .overlay(Color(hex: darkGrey))
            .frame(maxHeight: 3)
            .padding(.bottom, 7)
    }
}

struct PageBottomDivider_Previews: PreviewProvider {
    static var previews: some View {
        PageBottomDivider()
    }
}
