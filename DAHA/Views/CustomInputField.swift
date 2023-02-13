//
//  CustomInputField.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/8/23.
//

import SwiftUI

struct CustomInputField: View {
    let imageName: String?
    let placeholderText: String
    @Binding var text: String
    let secure: Bool
    
    var body: some View {
        VStack{
            HStack {
                if imageName != nil {
                    Image(systemName: imageName!)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                    .foregroundColor(Color(.darkGray))
                }
                
                if (secure){
                    SecureField(placeholderText, text: $text)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                } else {
                    TextField(placeholderText, text: $text)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                }
                
            }
            Divider()
                .background(Color(.darkGray))
        }
    }
}

struct CustomInputField_Previews: PreviewProvider {
    static var previews: some View {
        CustomInputField(imageName: "envelope", placeholderText: "Email", text: .constant(""), secure: false)
    }
}
