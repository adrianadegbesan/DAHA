//
//  NotificationsView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/14/23.
//

import SwiftUI
import UserNotifications

struct NotificationsView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("notifications") var notifications : Bool = true
    @State private var toggle : Bool = false
    
    
    var body: some View {
        
        Button(action: {
            Task {
                let opened = await UIApplication.shared.openAppNotificationSettings()
                if !opened {
                  print("error opening notifications")
                }
            }
        }){
            VStack(alignment: .leading) {
                HStack {
                    HStack {
                        Image(systemName: "bell.circle")
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                        Spacer()
                    }
                    .frame(width: screenWidth * 0.1)
                    
                    Text("Notifications")
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                }
            }
        }
    }
    
    
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}

extension UIApplication {
  private static let notificationSettingsURLString: String? = {
    if #available(iOS 16, *) {
      return UIApplication.openNotificationSettingsURLString
    }

    if #available(iOS 15.4, *) {
      return UIApplicationOpenNotificationSettingsURLString
    }

    if #available(iOS 8.0, *) {
      // just opens settings
      return UIApplication.openSettingsURLString
    }

    // lol bruh
    return nil
  }()

  private static let appNotificationSettingsURL = URL(
    string: notificationSettingsURLString ?? ""
  )

    func openAppNotificationSettings() async -> Bool {
    guard
      let url = UIApplication.appNotificationSettingsURL,
      UIApplication.shared.canOpenURL(url) else { return false }
      return await self.open(url)
  }
}
