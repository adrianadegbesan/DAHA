//
//  TimestampView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 5/23/23.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct TimestampView: View {
    var message: MessageModel
    
    var body: some View {
              Text("\(message.timestamp.formatted(.dateTime.hour().minute()))")
                  .fontWeight(.semibold)
                  .font(.caption2)
                  .foregroundColor(.gray)
                  .padding(message.senderID != Auth.auth().currentUser?.uid  ? .leading : .trailing, 5)
    }
}

//struct TimestampView_Previews: PreviewProvider {
//    static var previews: some View {
//        TimestampView()
//    }
//}
