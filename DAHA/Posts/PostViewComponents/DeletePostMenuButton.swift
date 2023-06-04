//
//  DeletePostMenuButton.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 5/19/23.
//

import SwiftUI

struct DeletePostMenuButton: View {
    @EnvironmentObject var firestoreManager : FirestoreManager
    @State var post: PostModel
    @Binding var deletePresented: Bool
    
    var body: some View {
        Button(role: .destructive){
            deletePresented = true
        } label:{
            Label("Delete Post", systemImage: "trash")
        }
        .foregroundColor(.red)
        .buttonStyle(.plain)
    }
}

//struct DeletePostMenuButton_Previews: PreviewProvider {
//    static var previews: some View {
//        DeletePostMenuButton()
//    }
//}
