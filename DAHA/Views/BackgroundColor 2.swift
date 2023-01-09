//
//  BackgroundColor.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import SwiftUI

struct BackgroundColor: View {
    
    let color: String
    
    var body: some View {
        Color.init(hex: color)
            .ignoresSafeArea()
    }
}

struct BackgroundColor_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundColor(color: "E8E8E8")
    }
}
