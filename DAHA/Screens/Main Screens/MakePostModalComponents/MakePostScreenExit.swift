//
//  MakePostModalActions.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/31/23.
//

import SwiftUI

struct MakePostScreenExit: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack{
            HStack{
                Image(systemName: "multiply")
                    .padding(.bottom, 10)
                    .scaleEffect(1.5)
                    .onTapGesture {
                        dismiss()
                    }
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
