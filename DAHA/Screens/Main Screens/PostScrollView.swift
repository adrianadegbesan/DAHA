//
//  PostScrollView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/11/23.
//

import SwiftUI

struct PostScrollView: View {
    
    @Binding var posts: [PostModel]
    @Binding var loading: Bool
    @State var screen: String
    @EnvironmentObject var firestoreManager : FirestoreManager
    @EnvironmentObject var network: Network
    
    var body: some View {
        ScrollView{
            
            if !network.connected {
                Text("Please check your internet connection")
                    .titleText()
            }
           else if loading {
                ProgressView()
            } else if posts.isEmpty{
                ProgressView()
            } else {
                
            }

        }
        .refreshable {

        }
        .onAppear{
            network.checkConnection()
        }
    }
}

struct PostScrollView_Previews: PreviewProvider {
    static var previews: some View {
        let posts : [PostModel] = []
        
        PostScrollView(posts: .constant(posts), loading: .constant(false), screen: "Home")
    }
}
