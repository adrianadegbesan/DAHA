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
    @StateObject var network = Network()
    @AppStorage("isDarkMode") private var isDarkMode = "System"
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                LaunchScreen()
            }
            .environmentObject(authentication)
            .environmentObject(firestoreManager)
            .environmentObject(network)
            .preferredColorScheme(isDarkMode == "On" ? .dark : (isDarkMode == "Off" ? .light : nil))
            /*Dark Mode Ternary Operator*/
        }
    }
}

