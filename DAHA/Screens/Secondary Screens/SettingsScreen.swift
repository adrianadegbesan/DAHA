//
//  SettingsScreen.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import SwiftUI

struct SettingsScreen: View {
    
    @AppStorage("isDarkMode") private var isDarkMode = "System"
    
    var body: some View {
        
        VStack {
            List{
                HStack{
                    Text("Dark Mode")
                    Spacer()
                    Picker("Mode", selection: $isDarkMode){
                        Text("On").tag("On")
                        Text("Off").tag("Off")
                        Text("System").tag("System")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                EmailSettingsView()
                HStack{
                    Spacer()
                    Text("Version \(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "0")")
                        .font(.system(size: 15, weight: .black))
                        .foregroundColor(Color(hex: deepBlue))
                    Spacer()
                    
                }
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
