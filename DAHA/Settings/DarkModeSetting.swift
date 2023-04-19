//
//  DarkModeSetting.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/14/23.
//

import SwiftUI

struct DarkModeSetting: View {
    @AppStorage("isDarkMode") private var isDarkMode = "System"
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                HStack{
                    Text(Image(systemName: "moon"))
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                    Spacer()
                }
                .frame(width: screenWidth * 0.1)
                
                Text("Dark Mode")
                Spacer()
                Picker("Mode", selection: $isDarkMode){
                    Text("On").tag("On")
                    Text("Off").tag("Off")
                    Text("System").tag("System")
                }
                .pickerStyle(SegmentedPickerStyle())
            }
//            Divider()
        }
  
    }
}

struct DarkModeSetting_Previews: PreviewProvider {
    static var previews: some View {
        DarkModeSetting()
    }
}
