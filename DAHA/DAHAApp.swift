//
//  DAHAApp.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import SwiftUI
import Firebase



@main
struct DAHAApp: App {
    @StateObject var authentication = AuthManager()
    @StateObject var firestoreManager = FirestoreManager()
    @StateObject var messagesManager = MessageManager()
    @StateObject var network = Network()
    @StateObject var notificationManager = NotificationManager()
    @StateObject var appState = AppState()
    @AppStorage("isDarkMode") private var isDarkMode = "System"
    @AppStorage("signedin") var isSignedIn: Bool = false
    @AppStorage("termsagreed") var agreedToTerms: Bool = false
    @AppStorage("emailverified") var verified: Bool = false
    @AppStorage("unread") var unread: Bool = false
    @AppStorage("messageScreen") var messageScreen: Bool = false
    

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
                LaunchScreen()
                    .environmentObject(authentication)
                    .environmentObject(firestoreManager)
                    .environmentObject(messagesManager)
                    .environmentObject(network)
                    .environmentObject(delegate)
                    .environmentObject(appState)
                    .preferredColorScheme(isDarkMode == "On" ? .dark : (isDarkMode == "Off" ? .light : nil))
                    /*Dark Mode Ternary Operator*/
        }
    }
}

