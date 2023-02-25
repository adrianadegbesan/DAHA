//
//  ReportModal.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/23/23.
//

import SwiftUI
import FirebaseAuth

struct ReportModal: View {
    @State var post: PostModel
    @State var report_alert: Bool = false
    @State var success_alert: Bool = false
    @State var error_alert: Bool = false
    @State var description: String = ""
    @State var uploading: Bool = false
    @Binding var reported: Bool
    @EnvironmentObject var firestoreManager : FirestoreManager
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @FocusState var description_input : Bool
    
    var body: some View {
        ScrollView {
            VStack{
                PostModalActions()
                    .padding(.leading, 15)
                    .padding(.top, 20)
                    
                Spacer().frame(height: screenHeight * 0.14)
                Image("Logo")
                    .overlay(Rectangle().stroke(colorScheme == .dark ? .white : .clear, lineWidth: 2))
                Spacer().frame(height: 0.01 * screenHeight)
                Text("REPORT POST")
                    .font(.system(size: 26, weight: .black))
                    .padding(.bottom, screenHeight * 0.02)
                
                
                TextField("Description", text: $description)
                    .textFieldStyle(OutlinedTextFieldStyle(icon: Image(systemName: "flag")))
                    .submitLabel(.return)
                    .onSubmit {
                        hideKeyboard()
                    }
                    .padding(.leading, screenWidth * 0.08)
                    .padding(.trailing, screenWidth * 0.08)
                    .padding(.bottom, screenHeight * 0.02)
                
                
                Button(action: {
                    if !uploading {
                        uploading = true
                        let cur_id = Auth.auth().currentUser?.uid
                        if cur_id == nil{
                            return
                        } else {
                            let report = ReportModel(id: UUID().uuidString, postID: post.id, posterID: post.userID, reporterID: cur_id ?? "0", description: description, reportedAt: nil)
                            
                            Task {
                                let success = await firestoreManager.reportPost(report: report, post: post)
                                if success {
                                    
                                    if post.type == "Listing"{
                                        if let index = firestoreManager.listings.firstIndex(where: { $0.id == post.id }) {
                                            firestoreManager.listings.remove(at: index)
                                        }
                                        
                                        
                                    } else if post.type == "Request"{
                                        if let index = firestoreManager.requests.firstIndex(where: { $0.id == post.id }) {
                                            firestoreManager.requests.remove(at: index)
                                        }
                                    }
                                    
                                    reported = true
                                    dismiss()
                                } else {
                                    error_alert = true
                                }
                                uploading = false
                            }
                        }
                    }
                  
                }){
                    ZStack {
                        // Blue Button background
                        RoundedRectangle(cornerRadius: 33)
                            .fill(Color.init(hex: deepBlue))
                            .frame(width: 150, height: 50)
                            .overlay(Capsule().stroke(colorScheme == .dark ? .white : .black, lineWidth: 2))
                        
                        // Putting Sign Up and Icon side-by-side
                        HStack {
                            // Sign Up Text
                            Text("REPORT")
                                .font(
                                    .system(size:25, weight: .bold)
                                )
                                .foregroundColor(.white)
                                .padding(3)
                        } //: HStack
                    } //: ZStack
                }
                
                Spacer()
            }  //: VStack
          
            
            .alert("Error Reporting Post", isPresented: $error_alert, actions:{}, message: {Text("Please check your network connection and try again later")})
        .alert("Successfully Reported Post", isPresented: $success_alert, actions:{}, message: {Text("This post was successfully reported")})
        }
        .keyboardControl()
    }
}

struct ReportModal_Previews: PreviewProvider {
    static var previews: some View {
        let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted", postedAt: nil, condition: "old", category: "Bikes", price: "$100", imageURLs: [], channel: "Stanford", savers: [], type: "", keywordsForLookup: [], reporters: [])
        
        ReportModal(post: post, reported: .constant(false))
    }
}
