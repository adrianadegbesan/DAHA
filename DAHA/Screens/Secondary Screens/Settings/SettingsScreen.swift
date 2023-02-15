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
                    .listRowSeparator(.hidden)
                NotificationsView()
                    .listRowSeparator(.hidden)
                TermsSettingsView(shouldNavigate: $shouldNavigateTerms)
                    .listRowSeparator(.hidden)
                EmailSettingsView()
                    .listRowSeparator(.hidden)
                LogOutView()
                    .listRowSeparator(.hidden)
                DeleteUserView()
                    .listRowSeparator(.hidden)
                VersionView()
                    .listRowSeparator(.hidden)
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
