//
//  ChangeUsernameView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/18/23.
//

import SwiftUI

struct EditUsernameView: View {
    @EnvironmentObject var authentication : AuthManager
    @EnvironmentObject var firestoreManager : FirestoreManager
    @Environment(\.colorScheme) var colorScheme
    @State private var isPresented : Bool = false
    @State private var username: String = ""
    @State private var error_message : String = ""
    @State private var error_alert: Bool = false
    @State private var success_alert: Bool = false
    @AppStorage("username") var username_system: String = ""
    @State private var selected : Bool = false
    @State private var changing : Bool = false
    
    var body: some View {
        

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
//                .frame(width: screenWidth * 0.85)
            }
                .onTapGesture {
                    withAnimation{
                        selected.toggle()
                    }
                }
                .alert("Error Editing Username", isPresented: $error_alert, actions: {}, message: {Text(error_message)})
                .alert("Username Changed", isPresented: $success_alert, actions: {}, message: {Text("Your username was successfully changed!")})
                if selected {
                    HStack {
                        VStack{
                            TextField("New Username", text: $username)
                                .padding(10)
                                .overlay(RoundedRectangle(cornerRadius: 8).stroke(colorScheme == .dark ? .white : .black , lineWidth: 2))
                                .foregroundColor(Color(hex: deepBlue))
//                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.horizontal, 5)
                                .textContentType(.username)
                        }
                    }
                    .padding([.top, .bottom], 5)
                    
                    HStack{
                        Spacer()
                        VStack{
                            Button(action: {
                                SoftFeedback()
                                changing = true
                                Task {
                                    let success = await authentication.editUsername(oldUsername: username_system, newUsername: $username, error_message: $error_message)
                                    changing = false
                                    if success {
                                        username_system = username.replacingOccurrences(of: " ", with: "").lowercased()
                                        username = ""
//                                        Task{
//                                            firestoreManager.my_posts.removeAll()
//                                            firestoreManager.listings.removeAll()
//                                            firestoreManager.requests.removeAll()
//                                            firestoreManager.listings_filtered.removeAll()
//                                            firestoreManager.requests_filtered.removeAll()
//
//                                            await firestoreManager.userPosts()
//                                            await firestoreManager.getListings()
//                                            await firestoreManager.getRequests()
//
//                                        }
                                        success_alert = true
                                    } else {
                                        error_alert = true
                                    }
                                 
                                }
                            }){
                                if !changing{
                                    Text("Change")
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)
                                        .padding(6.5)
                                        .background(Capsule().fill(Color(hex: deepBlue)))
                                        .overlay(Capsule().stroke(colorScheme == .dark ? .white : .black, lineWidth: 2))
                                        .scaleEffect(0.9)
                                        .padding([.top, .bottom], 5)
                                } else {
                                    ProgressView()
                                }
                               
                            }
                            .buttonStyle(.plain)
                            .disabled(changing)
                        }
                    }
            }
        
    }
}

struct EditUsernameView_Previews: PreviewProvider {
    static var previews: some View {
        EditUsernameView()
    }
}
