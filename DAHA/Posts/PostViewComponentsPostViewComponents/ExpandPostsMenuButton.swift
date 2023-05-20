//
//  ExpandPostsMenuButton.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 5/19/23.
//

import SwiftUI

struct ExpandPostsMenuButton: View {
    
    @State var preview: Bool
    @Binding var shouldNavigate: Bool
    
    var body: some View {
        if !preview {
            if #available(iOS 16, *){
                Button {
                    shouldNavigate = true
                } label: {
                    Label("Expand Post", systemImage: "arrowshape.right")
                }
            } else {
                Button {
                    shouldNavigate = true
                } label: {
                    Label("Expand Post", systemImage: "arrow.right")
                }
            }
        }
    }
}

//struct ExpandPostsMenuButton_Previews: PreviewProvider {
//    static var previews: some View {
//        ExpandPostsMenuButton()
//    }
//}
