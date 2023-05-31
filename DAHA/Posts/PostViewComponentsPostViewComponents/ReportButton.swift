//
//  ReportView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/29/23.
//

import SwiftUI
import FirebaseAuth

struct ReportButton: View {
    @State var post: PostModel
    @Binding var reported: Bool
    @State private var report_modal: Bool = false
    @State private var success_alert: Bool = false
    @State private var error_alert: Bool = false
    @State private var description: String = ""
    @EnvironmentObject var firestoreManager : FirestoreManager
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        Button(action: {
            report_modal = true
        }){
            Image(systemName: reported ? "flag.fill" : "flag")
                .font(.system(size: 22, weight: .bold))
        }
        .foregroundColor(reported ? .red : (colorScheme == .dark) ? .white : .black)
        .buttonStyle(.plain)
        .sheet(isPresented: $report_modal){
            ReportModal(post: post, reported: $reported)
        }
        
    }
}

struct ReportButton_Previews: PreviewProvider {
    static var previews: some View {
        let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted", postedAt: nil, condition: "old", category: "Bikes", price: "$100", imageURLs: [], channel: "Stanford", savers: [], type: "", keywordsForLookup: [], reporters: [])
        
        ReportButton(post: post, reported: .constant(false))
    }
}
