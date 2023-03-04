//
//  NotificationsView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/14/23.
//

import SwiftUI

struct NotificationsView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @State private var toggle : Bool = false
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                HStack{
                    Text(Image(systemName: "bell.circle"))
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                    Spacer()
                }
                .frame(width: screenWidth * 0.1)
            
                Toggle("Notifications", isOn: $toggle)
                    .tint(Color(hex: deepBlue))
            }
//            Divider()
        }
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}
