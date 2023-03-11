//
//  CategoryFilterIcon.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 3/11/23.
//

import SwiftUI

struct CategoryFilterIcon: View {
    
    @State var category : String
    @Binding var selected : String
    @State var screen : String
    @Binding var posts: [PostModel]
    @Binding var loading: Bool
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var firestoreManager : FirestoreManager
    
    var body: some View {
        
        Button(action: {
            SoftFeedback()
            if selected == category {
                withAnimation{
                    selected = ""
                    if screen == "Listings"{
                        loading = firestoreManager.listings_loading
                        posts = firestoreManager.listings
                    }
                    else if screen == "Requests"{
                        loading = firestoreManager.requests_loading
                        posts = firestoreManager.requests
                    }
                }
            } else {
                withAnimation{
                    selected = category
                    if screen == "Listings"{
                        Task{
                            await firestoreManager.getListingsFiltered(category: category)
                        }
                        loading = firestoreManager.listings_filtered_loading
                        posts = firestoreManager.listings_filtered
                        
                    }
                    else if screen == "Requests" {
                        Task {
                            await firestoreManager.getRequestsFiltered(category: category)
                        }
                        loading = firestoreManager.requests_filtered_loading
                        posts = firestoreManager.requests_filtered
                    }
                }
            }
           
        }){
            Label(category.uppercased(), systemImage: category_images[category] ?? "")
                .lineLimit(1)
                .foregroundColor(.white)
                .font(.system(size: 12, weight: .bold))
                .padding(9)
                .background(Capsule().fill(Color(hex: category_colors[category] ?? "000000")))
                .overlay(colorScheme == .dark ? Capsule().stroke(.white, lineWidth: (selected == category) ? 4 : 1.5) : Capsule().stroke(.black, lineWidth: (selected == category) ? 4 : 1.5))
                .overlay((colorScheme == .light && category == "General") ? Capsule().stroke(.gray, lineWidth: (selected == category) ? 4 : 1.5) : Capsule().stroke(.clear, lineWidth: (selected == category) ? 4 : 1.5))
                .padding(.trailing, 10)
        }
        
    }
}

struct CategoryFilterIcon_Previews: PreviewProvider {
    static var previews: some View {
        let screen = "Listings"
        let posts : [PostModel] = []
        
        CategoryFilterIcon(category: "General", selected: .constant("General"), screen: screen, posts: .constant(posts), loading: .constant(false))
    }
}
