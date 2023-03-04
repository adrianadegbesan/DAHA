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
    @State var shouldNavigatePrivacy = false
    
    var body: some View {
        
        VStack {
            List{
                Section{
                    DarkModeSetting()
                    EditUsernameView()
                    ChangePasswordView()
                }
               
                Section{
                    NotificationsView()
                    TermsSettingsView(shouldNavigate: $shouldNavigateTerms)
                    PrivacyPolicyView(shouldNavigate: $shouldNavigatePrivacy)
                    EmailSettingsView()
                }
                
                Section{
                    LogOutView()
                    DeleteUserView()
                    JoinedAtView()
                }
              
                
            }
            .listStyle(.insetGrouped)
            
            NavigationLink(destination: TermsSettingsScreen(), isActive: $shouldNavigateTerms){
                EmptyView()
            }
            
            NavigationLink(destination: PrivacySettingsScreen(), isActive: $shouldNavigatePrivacy){
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
