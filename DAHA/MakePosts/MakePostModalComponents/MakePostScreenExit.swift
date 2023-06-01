//
//  MakePostModalActions.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/31/23.
//

import SwiftUI

struct MakePostScreenExit: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack{
            HStack{
                Button(action: {
//                    SoftFeedback()
                    dismiss()
                }){
                    Image(systemName: "multiply")
                        .font(.system(size: 20, weight: .heavy))
//                        .padding(.bottom, 10)
                }
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .buttonStyle(.plain)
            } //:HStack
        }
    }
}

struct MakePostScreenExit_Previews: PreviewProvider {
    static var previews: some View {
        MakePostScreenExit()
    }
}
