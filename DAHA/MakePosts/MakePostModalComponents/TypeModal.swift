//
//  TypeModal.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/9/23.
//

import SwiftUI

struct TypeModal: View {
    
    @Binding var selected: String
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            VStack{
                if #unavailable(iOS 16.0){
                    HStack{
                        Image(systemName: "multiply")
                            .font(.system(size: 25, weight: .heavy))
                            .onTapGesture {
                                dismiss()
                            }
                            .padding(.leading, 15)
                            .padding(.top, 5)
                        Spacer().frame(width: screenWidth * 0.34)
                        ModalCapsule()
                        Spacer()
                    }
                    .padding(.top, 10)
                } 
                
                 Spacer().frame(height: screenHeight * 0.035)
                 Text("Types")
                     .font(
                         .system(size:30, weight: .heavy)
                     )
                 Spacer().frame(height: screenHeight * 0.06)
                 TypeIcon(selected: $selected, type: "Listing")
                 Spacer().frame(height: screenHeight * 0.06)
                 TypeIcon(selected: $selected, type: "Request")
                 Spacer()
            }
        }
    }
}

struct TypeModal_Previews: PreviewProvider {
    static var previews: some View {
        TypeModal(selected: .constant(""))
    }
}
