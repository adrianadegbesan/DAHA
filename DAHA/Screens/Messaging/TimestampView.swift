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
        if Calendar.current.isDateInToday(message.timestamp) {
              Text("\(message.timestamp.formatted(.dateTime.hour().minute()))")
                  .font(.caption2)
                  .foregroundColor(.gray)
                  .padding(message.senderID != Auth.auth().currentUser?.uid  ? .leading : .trailing, 5)
          } else {
              Text("\(message.timestamp.formatted(.dateTime.hour().minute())) - \(message.timestamp.formatted(.dateTime.month().day().year()))")
                  .font(.caption2)
                  .foregroundColor(.gray)
                  .padding(message.senderID != Auth.auth().currentUser?.uid  ? .leading : .trailing, 5)
          }
    }
}

//struct TimestampView_Previews: PreviewProvider {
//    static var previews: some View {
//        TimestampView()
//    }
//}
