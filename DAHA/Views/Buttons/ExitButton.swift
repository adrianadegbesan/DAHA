//
//  ExitButton.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 4/20/23.
//

import SwiftUI

struct ExitButton: View {
    
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        Text(Image(systemName: "multiply.circle.fill"))
            .font(.system(size: 15, weight: .bold))
            .foregroundColor(.gray.opacity(colorScheme == .dark ? 0.3 : 0.6))
    }
}

struct ExitButton_Previews: PreviewProvider {
    static var previews: some View {
        ExitButton()
    }
}
