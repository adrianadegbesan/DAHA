//
//  RequestsView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/16/23.
//

import SwiftUI

struct RequestsView: View {
    @EnvironmentObject var firestoreManager : FirestoreManager
    var body: some View {
        VStack{
            PostScrollView(posts: $firestoreManager.requests, loading: $firestoreManager.requests_loading, screen: "Requests", query: .constant(""), type: .constant(""), category: .constant(""))
        }
    }
}

struct RequestsView_Previews: PreviewProvider {
    static var previews: some View {
        RequestsView()
    }
}
