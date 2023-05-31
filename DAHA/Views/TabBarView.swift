//
//  TabBarView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import SwiftUI

// Custom Tab Bar View utilised throughout this app
struct TabBarView: View {
    
    // Binding that takes the selected index variable from the main screen page and links the tab view functionality of the TabBarView to the MainScreen
    @Binding var selectedIndex: Int
    
    // List of image names for the tab bar that the for each loop traverses
    let tabBarImageNames = ["house", "magnifyingglass", "bookmark", "person.circle"]
    
    var body: some View {
        VStack {
        Divider()
            .padding(.bottom, 12)
        
        HStack{
            // For Each Loop for creating the tab bar
            ForEach(0 ..< 4) { num in
                Button(action: {
                        selectedIndex = num
                }, label: {
                    Spacer()
                    Image(systemName: tabBarImageNames[num])
                        .tabItemIcon(selectedIndex: selectedIndex, num: num)
                    Spacer()
                })
                .buttonStyle(.plain)
            }
        }
        // Brings the icons closer together
        .padding(.horizontal, 30)
     }
  }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView(selectedIndex: .constant(0))
            .previewLayout(.sizeThatFits)
    }
}
