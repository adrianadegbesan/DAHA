//
//  AppDelegate.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 4/11/23.
//

import Foundation
import SwiftUI
import Firebase

class AppDelegate: NSObject,UIApplicationDelegate, ObservableObject{
    @AppStorage("fcmtoken") private var token = ""
    @AppStorage("onboarding") var isOnboardingViewActive: Bool = true
    @AppStorage("signedin") var isSignedIn: Bool = false
    @AppStorage("termsagreed") var agreedToTerms: Bool = false
    @AppStorage("emailverified") var verified: Bool = false
    @AppStorage("unread") var unread: Bool = false
    @AppStorage("messageScreen") var messageScreen: Bool = false
    @AppStorage("notifications") var notificationsEnabled: Bool = true
    @Published var shouldNavigate = false
    @Published var message = false
    @Published var channelID_cur = ""
    @Published var inAppNotification = false
    
    @Published var chatScreen = false
    @Published var currentChat = ""
    @Published var currentNotification = ""
    let gcmMessageIDKey = "gcm.message_id"
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        
        FirebaseApp.configure()
        
        // Setting Up Cloud Messaging...
        
       
        
        // Setting Up Notifications...
        
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
            
        } else {
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
            
        }

        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        // DO Something With Message Data Here....
      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
       
      }
        
      Messaging.messaging().appDidReceiveMessage(userInfo)
          
      if let channelID = userInfo["channelID"]{
          print("Channel ID: \(channelID)")
          channelID_cur = channelID as? String ?? ""
          shouldNavigate = true
      }
     
      // Print full message.
      print(userInfo)

      completionHandler(UIBackgroundFetchResult.newData)
    }
    
    // In order to receive notifications you need implement these methods...
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        Messaging.messaging().apnsToken = deviceToken
        
    }

}

// CLoud Messaging...
extension AppDelegate: MessagingDelegate{
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    
        // Store this token to firebase and retrieve when to send message to someone....
        let dataDict:[String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
        
        // Store token in Firestore For Sending Notifications From Server in Future...
        token = fcmToken ?? ""
        
        print(dataDict)
    }
}

// User Notifications...[AKA InApp Notifications...]

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo
    Messaging.messaging().appDidReceiveMessage(userInfo)
    // DO Something With MSG Data...


    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }
      
    

    print(userInfo)
      
      if let aps = userInfo["aps"] as? [String: AnyObject],
         let alert = aps["alert"] as? [String: AnyObject] {
          let title = alert["title"] as? String ?? ""
          currentNotification = title
          let body = alert["body"] as? String ?? ""
          print("Title: \(title)")
          print("Body: \(body)")
      }
      
      if let _ = userInfo["channelID"]{
              withAnimation {
                  inAppNotification = true
                  unread = true
              }
      }
      
      if chatScreen {
          if currentChat == currentNotification {
              currentNotification = ""
              SoftFeedback()
              completionHandler([.sound])
          } else {
              currentNotification = ""
              completionHandler([.list, .sound])
          }
      } else {
          currentNotification = ""
          completionHandler([.banner, .list, .sound,])
      }
      
     
  }
    

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo
      
    Messaging.messaging().appDidReceiveMessage(userInfo)
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }
    
      
      if let channelID = userInfo["channelID"]{
//          print("Channel ID: \(channelID)")
          channelID_cur = channelID as? String ?? ""
          shouldNavigate = true
          unread = true
      }
      
    // DO Something With MSG Data...
    print(userInfo)

    completionHandler()
  }
}
