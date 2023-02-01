//
//  PostModalActions.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/31/23.
//

import SwiftUI

struct PostModalActions: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack{
            HStack{
                Capsule()
                    .frame(width: 35, height: 8)
                    .foregroundColor(.gray)
            } //: HStack
            .padding(.bottom, 8)
            HStack{
                Image(systemName: "multiply")
                    .padding(.bottom, 10)
                    .scaleEffect(1.5)
                    .onTapGesture {
                        dismiss()
                    }
                Spacer()
            } //:HStack
        }
 
    }
}

struct PostModalActions_Previews: PreviewProvider {
    static var previews: some View {
        PostModalActions()
    }
}
