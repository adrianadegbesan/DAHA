//
//  EmailSettingsView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/14/23.
//

import SwiftUI

struct EmailSettingsView: View {
    @State var mailData = ComposeMailData(subject: "",
                                                   recipients: ["team@joindaha.com"],
                                                   message: "",
                                                   attachments: nil)
    @State private var showMailView = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {

        Button(action: {
            showMailView.toggle()
        }){
            VStack(alignment: .leading){
                HStack{
                    HStack{
                        Text(Image(systemName: "envelope.fill"))
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                        Spacer()
                    }
                    .frame(width: screenWidth * 0.1)
                   
                    Text("Contact Us")
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                }
                Divider()
            }
        }.disabled(!MailView.canSendMail)
            .sheet(isPresented: $showMailView) {
              MailView(data: $mailData) { result in
                print(result)
               }
        }
    }
}

struct EmailSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        EmailSettingsView()
    }
}
