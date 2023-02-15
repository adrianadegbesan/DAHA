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
//            HStack{
//                    ModalCapsule()
//            } //: HStack
//            .padding(.bottom, 8)
            HStack{
                Image(systemName: "multiply")
                    .font(.system(size: 28, weight: .heavy))
                    .padding(.bottom, 10)
                    .onTapGesture {
                        SoftFeedback()
                        dismiss()
                    }
                Spacer()
            } //:HStack
            .padding(.leading, 4)
        }
 
    }
}

struct PostModalActions_Previews: PreviewProvider {
    static var previews: some View {
        PostModalActions()
    }
}
