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
                        .scaleEffect(1.5)
                }
                .foregroundColor(colorScheme == .dark ? .white : .black)
            } //:HStack
        }
 
    }
}

struct MakePostScreenExit_Previews: PreviewProvider {
    static var previews: some View {
        MakePostScreenExit()
    }
}
