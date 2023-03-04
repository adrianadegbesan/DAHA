//
//  ChangeUsernameView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/18/23.
//

import SwiftUI

struct EditUsernameView: View {
    @EnvironmentObject var authentication : AuthManager
    @Environment(\.colorScheme) var colorScheme
    @State private var isPresented : Bool = false
    @State private var username: String = ""
    @State private var error_message : String = ""
    @State private var error_alert: Bool = false
    @State private var success_alert: Bool = false
    @AppStorage("username") var username_system: String = ""
    
    var body: some View {
        
        Button(action: {
            
            isPresented = true
            
       
        }){
            VStack(alignment: .leading) {
                HStack {
                    HStack {
                        Image(systemName: "pencil.circle")
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                        Spacer()
                    }
                    .frame(width: screenWidth * 0.1)
                    
                    Text("Edit Username")
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                }
//                Divider()
            }
        }
        .alert("Edit Username", isPresented : $isPresented, actions: {
            TextField("New Username", text: $username)
                .foregroundColor(Color(hex: deepBlue))
            Button("Change", action: {
                Task {
                    let success = await authentication.editUsername(newUsername: $username, error_message: $error_message)
                    if success {
                        username_system = username.replacingOccurrences(of: " ", with: "").lowercased()
                        success_alert = true
                    } else {
                        error_alert = true
                    }
                }
            })
            Button("Cancel", role: .cancel, action: {})
            
        }, message: {Text("Please enter your new username")})
        
        .alert("Error Editing Username", isPresented: $error_alert, actions: {}, message: {Text(error_message)})
        .alert("Username Changed", isPresented: $success_alert, actions: {}, message: {Text("Your username was successfully changed!")})
    }
}

struct EditUsernameView_Previews: PreviewProvider {
    static var previews: some View {
        EditUsernameView()
    }
}
