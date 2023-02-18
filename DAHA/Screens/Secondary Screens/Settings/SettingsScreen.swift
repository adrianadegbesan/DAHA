//
//  SettingsScreen.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import SwiftUI

struct SettingsScreen: View {
    
    @AppStorage("isDarkMode") private var isDarkMode = "System"
    @State var shouldNavigateTerms = false
    
    var body: some View {
        
        VStack {
            List{
                DarkModeSetting()
                EditUsernameView()
                ChangePasswordView()
                NotificationsView()
                TermsSettingsView(shouldNavigate: $shouldNavigateTerms)
                EmailSettingsView()
                LogOutView()
                DeleteUserView()
                VersionView()
            }
            
            NavigationLink(destination: TermsSettingsScreen(), isActive: $shouldNavigateTerms){
                EmptyView()
            }
           
           
        }
        .navigationTitle("Settings")
    }
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
    }
}
