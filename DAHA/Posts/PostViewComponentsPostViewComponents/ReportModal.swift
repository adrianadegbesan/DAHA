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
    @State var dismiss_screen: Bool = false
    @State var success_alert: Bool = false
    @State var error_alert: Bool = false
    @State var description: String = ""
    @State var uploading: Bool = false
    @Binding var reported: Bool
    @FocusState var keyboard : Bool
    @EnvironmentObject var firestoreManager : FirestoreManager
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss

    
    var body: some View {
        ScrollViewReader { value in
            ScrollView {
                VStack(spacing: 5){
                    ModalCapsule()
                        .padding(.top, 20)
                        
                    Spacer().frame(height: screenHeight * 0.04)
                    Image("Logo")
                        .overlay(Rectangle().stroke(colorScheme == .dark ? .white : .clear, lineWidth: 2))
                    Spacer().frame(height: 0.01 * screenHeight)
                    Text("REPORT POST")
                        .font(.system(size: 26, weight: .black))
                    
                    PostView(post: post, owner: false, preview: true)
                        .scaleEffect(0.9)
                    
                    
                    if #available(iOS 16.0, *) {
                        TextField("Description", text: $description, axis: .vertical)
                            .textFieldStyle(OutlinedTextFieldStyle(icon: Image(systemName: "flag")))
                            .lineLimit(3)
                            .padding(.leading, screenWidth * 0.08)
                            .padding(.trailing, screenWidth * 0.08)
                            .padding(.bottom, screenHeight * 0.023)
                            .focused($keyboard)
                            .id(1)
                        
                    } else {
                        TextField("Description", text: $description)
                            .textFieldStyle(OutlinedTextFieldStyle(icon: Image(systemName: "flag")))
                            .submitLabel(.return)
                            .onSubmit {
                                hideKeyboard()
                            }
                            .padding(.leading, screenWidth * 0.08)
                            .padding(.trailing, screenWidth * 0.08)
                            .padding(.bottom, screenHeight * 0.023)
                            .focused($keyboard)
                            .id(1)
                    }
                    
                    
                    Button(action: {
                        if !uploading {
                            report_alert = true
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
                .keyboardControl()
//                .onChange(of: keyboard){ num in
//                    if keyboard{
//                        value.scrollTo(1)
//                    }
//                    
//                }
                .alert("Report Post", isPresented: $report_alert, actions: {
                    Button("Report", role: .destructive, action: {
                        uploading = true
                        let cur_id = Auth.auth().currentUser?.uid
                        if cur_id == nil{
                            return
                        } else {
                            let report = ReportModel(id: UUID().uuidString, postID: post.id, posterID: post.userID, reporterID: cur_id ?? "0", description: description, reportedAt: nil)
                            
                            Task {
                                let success = await firestoreManager.reportPost(report: report, post: post)
                                if success {
                                    reported = true
    //                                success_alert = true
                                } else {
                                    error_alert = true
                                }
                                uploading = false
                            }
                        }
                    })
                }, message: {Text("Are you sure you want to report this post?")})
              
                
            .alert("Error Reporting Post", isPresented: $error_alert, actions:{}, message: {Text("Please check your network connection and try again later")})
            .alert("Successfully Reported Post", isPresented: $success_alert, actions:{
    //            dismiss_screen = true
            }, message: {Text("This post was successfully reported")})
            }
            .onTapGesture {
                hideKeyboard()
            }
            .onChange(of: reported){ value in
                if reported {
                    dismiss()
                }
            }
        }
    }
}

struct ReportModal_Previews: PreviewProvider {
    static var previews: some View {
        let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted", postedAt: nil, condition: "old", category: "Bikes", price: "100", imageURLs: [], channel: "Stanford", savers: [], type: "", keywordsForLookup: [], reporters: [])
        
        ReportModal(post: post, reported: .constant(false))
    }
}
