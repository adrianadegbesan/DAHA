//
//  MessageField.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 3/3/23.
//

import SwiftUI
import Firebase


struct MessageField: View {
    @EnvironmentObject var messagesManager: MessageManager
    @State private var message = ""
    @State var post: PostModel
    @State var channelID : String?
    @State var sending : Bool = false
    @Binding var sent : Bool
    @State var error_alert : Bool = false

    var body: some View {
        HStack {
            // Custom text field created below
            CustomTextField(placeholder: Text(""), text: $message)
                .frame(height: 52)
                .disableAutocorrection(true)

            Button {
                if message != ""{
                    SoftFeedback()
                    
                    if channelID == nil {
                        let id = messagesManager.createMessageChannel(message: message, post: post)
                        if id == nil{
                            error_alert = true
                        } else {
                            sent = true
                            message = ""
                        }
                        
                        
                    } else {
                            let result =  messagesManager.sendMessage(message: message, channelID: channelID!, post: post)
                            if !result{
                                error_alert = true
                            } else {
                                sent = true
                                message = ""
                            }
                    }
                    
                    
                }
              
            } label: {
                Image(systemName: "arrow.up")
                    .font(.system(size: 20, weight: .heavy))
                    .foregroundColor(.white)
                    .padding(10)
                    .background(message != "" ? Color(hex: deepBlue) : .gray)
                    .cornerRadius(50)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 3)
        .background(RoundedRectangle(cornerRadius: 50).stroke(lineWidth: 2))
        .padding(.horizontal, screenWidth * 0.01)
        .alert("Error Sending Message", isPresented: $error_alert, actions: {}, message:{Text("Please check your network connection")})
        
    }
}

struct MessageField_Previews: PreviewProvider {
    static var previews: some View {
        let calendar = Calendar.current
        let startTime = calendar.date(byAdding: .day, value: -2, to: Date())
        let startTimestamp: Timestamp = Timestamp(date: startTime!)
        
        let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted, gave me alot of miles but kinda creaky sometimes", postedAt: startTimestamp, condition: "Good", category: "Bikes", price: "100", imageURLs: [], channel: "Stanford", savers: [], type: "Listing", keywordsForLookup: [], reporters: [])
        
        MessageField(post: post, sent: .constant(false))
            .environmentObject(MessageManager())
    }
}

struct CustomTextField: View {
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }

    var body: some View {
        ZStack(alignment: .leading) {
            // If text is empty, show the placeholder on top of the TextField
            if text.isEmpty {
                placeholder
                .opacity(0.5)
            }
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
        }
    }
}
