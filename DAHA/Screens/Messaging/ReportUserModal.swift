//
//  ReportUserModal.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 3/5/23.
//

import SwiftUI
import FirebaseAuth

struct ReportUserModal: View {
    
    @EnvironmentObject var messageManager : MessageManager
    @State var channelID: String
    @State var success_alert: Bool = false
    @State var error_alert: Bool = false
    @State var report_alert: Bool = false
    @State var description: String = ""
    @State var uploading: Bool = false
    @State var post : PostModel? = nil
    @Binding var reported: Bool
    @State var username: String
    @State var receiverID: String
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    
    
    
    var body: some View {
        ScrollView {
            VStack(spacing: 5){
                PostModalActions()
                    .padding(.leading, 15)
                    .padding(.top, 20)
                
                Spacer().frame(height: screenHeight * 0.04)
                Image("Logo")
                    .overlay(Rectangle().stroke(colorScheme == .dark ? .white : .clear, lineWidth: 2))
                Spacer().frame(height: 0.01 * screenHeight)
                Text("REPORT USER")
                    .font(.system(size: 26, weight: .black))
                    .padding(.bottom, 7)
                    .onAppear{
                        let index = messageManager.messageChannels.firstIndex(where: {$0.id == channelID })
                        if index != nil{
                            withAnimation{
                                post = messageManager.messageChannels[index!].post
                            }
                        }
                    }
                    
                if post != nil{
                    PostView(post: post!, owner: false, preview: true)
                        .scaleEffect(0.9)
                }
               
                
                Text("@\(username)")
                    .font(.system(size: 22, weight: .bold))
                    .padding(.bottom, 9)
                
                
                if #available(iOS 16.0, *) {
                    TextField("Description", text: $description, axis: .vertical)
                        .textFieldStyle(OutlinedTextFieldStyle(icon: Image(systemName: "flag")))
                        .lineLimit(3)
                        .padding(.leading, screenWidth * 0.08)
                        .padding(.trailing, screenWidth * 0.08)
                        .padding(.bottom, screenHeight * 0.023)
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
        }
            .alert("Report Post", isPresented: $report_alert, actions: {
                Button("Report", role: .destructive, action: {
                    uploading = true
                    let cur_id = Auth.auth().currentUser?.uid
                    if cur_id == nil{
                        return
                    } else {
    //                    let report = ReportModel(id: UUID().uuidString, postID: post.id, posterID: post.userID, reporterID: cur_id ?? "0", description: description, reportedAt: nil)
                        
    //                    Task {
    //                        let success = await firestoreManager.reportPost(report: report, post: post)
    //                        if success {
    //                            reported = true
    ////                                success_alert = true
    //                        } else {
    //                            error_alert = true
    //                        }
    //                        uploading = false
    //                    }
                    }
                })
            }, message: {Text("Are you sure you want to report this user?")})
          
            
        .alert("Error Reporting User", isPresented: $error_alert, actions:{}, message: {Text("Please check your network connection and try again later")})
        .alert("Successfully Reported User", isPresented: $success_alert, actions:{
        }, message: {Text("This post was successfully reported")})
        .keyboardControl()
    }
    
        
    }
    
    struct ReportUserModal_Previews: PreviewProvider {
        static var previews: some View {
            ReportUserModal(channelID: "", reported: .constant(false), username: "Adrian", receiverID: "")
                .environmentObject(MessageManager())
        }
    }
