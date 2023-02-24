//
//  DMScreen.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import SwiftUI

struct DMScreen: View {
    
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("username") var username_system: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            ScrollView{
                Spacer().frame(height: screenHeight * 0.01)
                VStack(spacing: 0){
                    ForEach(1..<10, id: \.self){ preview in
                        MessagePreview()
                        Divider()
                            .frame(maxHeight: 0.5)
                            .overlay(Color(hex: darkGrey))
                    }
                 
                }
            }
          
        }
        .navigationTitle("Direct Messages")
    }
}

struct DMScreen_Previews: PreviewProvider {
    static var previews: some View {
        DMScreen()
    }
}
