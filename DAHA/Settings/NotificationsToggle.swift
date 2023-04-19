//
//  NotificationsToggle.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 4/19/23.
//

import SwiftUI

struct NotificationsToggle: View {
    @AppStorage("notifications") var notificationsEnabled: Bool = true
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                HStack {
                    Image(systemName: "bell.circle")
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                    Spacer()
                }
                .frame(width: screenWidth * 0.1)
                
//                Text("Notifications")
//                    .foregroundColor(colorScheme == .dark ? .white : .black)
                Toggle("Notifications", isOn: $notificationsEnabled)
                    .tint(Color(hex: deepBlue))
            }
        }
    }
}

struct NotificationsToggle_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsToggle()
    }
}
