//
//  RecentDMs.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/22/23.
//

import SwiftUI

struct RecentDMs: View {
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("username") var username_system: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            Spacer().frame(height: screenHeight * 0.02)
            ScrollView{
                VStack(spacing: 0){
                    ForEach(1..<6, id: \.self){ preview in
                        Divider()
                            .frame(maxHeight: 0.5)
                            .overlay(Color(hex: darkGrey))
                        MessagePreview()
                        Divider()
                            .frame(maxHeight: 0.5)
                            .overlay(Color(hex: darkGrey))
                    }
                 
                }
            }
          
        }
    }
}

struct RecentDMs_Previews: PreviewProvider {
    static var previews: some View {
        RecentDMs()
    }
}
