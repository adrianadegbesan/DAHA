//
//  ForgotPasswordButton.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/25/23.
//

import SwiftUI

struct ForgotPasswordButton: View {
    
    @State private var shouldNavigate : Bool = false
    
    var body: some View {
        Button(action: {
            shouldNavigate = true
        }){
            HStack{
                Text("Forgot Password")
                    .foregroundColor(.gray)
                
                NavigationLink("", destination: ForgotPasswordScreen(), isActive: $shouldNavigate)
            }
            
        }
        .buttonStyle(.plain)
}
    
    struct ForgotPasswordButton_Previews: PreviewProvider {
        static var previews: some View {
            ForgotPasswordButton()
        }
    }
    
}
