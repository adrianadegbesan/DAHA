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
                    dismiss()
                }){
                    Image(systemName: "multiply")
                        .padding(.bottom, 10)
                        .padding(.trailing, 0)
                        .scaleEffect(1.5)
                }
                .foregroundColor(colorScheme == .dark ? .white : .black)
                Text("Cancel")
                    .font(.system(size: 18, weight: .bold))
                    .padding(.bottom, 14)
            } //:HStack
        }
 
    }
}

struct MakePostScreenExit_Previews: PreviewProvider {
    static var previews: some View {
        MakePostScreenExit()
    }
}
