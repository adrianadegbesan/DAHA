//
//  ItemTypeView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/9/23.
//

import SwiftUI

struct ChooseTypeButton: View {
    @Binding var post: PostModel
    @State var selected: String = ""
    @State var isPresented: Bool = false
    @Environment(\.colorScheme) var colorScheme
    
    let types = ["Listing", "Request"]
    
    var body: some View {
        HStack {
            Button(action: {
                LightFeedback()
                if selected == "" {
                    isPresented = true
                } else {
                    withAnimation{
                        selected = ""
                    }
                }
            }) {
                if (selected == ""){
                    Text("Choose Post Type")
                            .lineLimit(1)
                            .font(.system(size: 13, weight: .bold))
                            .padding(10)
                            .background(Capsule().stroke(lineWidth: 5))
                            .padding(.trailing, 10)
                            .foregroundColor(.blue)
                } else {
                    Text(Image(systemName: "multiply.circle.fill"))
                        .font(.system(size: 13, weight: .bold))
                        .background(Circle().fill(.white))
                        .background(Circle().stroke(colorScheme == .dark ? .white : .black, lineWidth: 1))
                        .foregroundColor(.red)
                }
            
            }
            
            if (selected != ""){
                Label(post.type.uppercased(), systemImage: type_images[post.type] ?? "")
                    .lineLimit(1)
                    .foregroundColor(.white)
                    .font(.system(size: 13, weight: .bold))
                    .padding(10)
                    .background(Capsule().fill(.black))
                    .overlay( colorScheme == .dark ? Capsule().stroke(.white, lineWidth: 2) : Capsule().stroke(.clear, lineWidth: 3))
                    .padding(.trailing, 10)
            }
            
        }
        .sheet(isPresented: $isPresented){
                TypeModal(post: $post, selected: $selected)
        }
    }
}

struct ChooseTypeButton_Previews: PreviewProvider {
    static var previews: some View {
        let post: PostModel = PostModel(title: "", userID: "", username: "", description: "", condition: "", category: "", price: "", imageURLs: [], channel: "", savers: [], type: "")
        
        ChooseTypeButton(post: .constant(post))
    }
}
