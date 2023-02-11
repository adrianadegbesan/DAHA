//
//  ItemTypeView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/9/23.
//

import SwiftUI
import BottomSheet

struct ChooseTypeButton: View {
//    @Binding var post: PostModel
    @Binding var selected: String
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
                        .background(Circle().fill(.white).scaleEffect(colorScheme == .dark ? 1 : 0.6))
                        .background(Circle().stroke(colorScheme == .dark ? .white : .black, lineWidth: colorScheme == .dark ? 1 : 3))
                        .foregroundColor(.red)
                }
            
            }
            
            if (selected != ""){
                Label(selected.uppercased(), systemImage: type_images[selected] ?? "")
                    .lineLimit(1)
                    .foregroundColor(.white)
                    .font(.system(size: 13, weight: .bold))
                    .padding(10)
                    .background(Capsule().fill(.black))
                    .overlay( colorScheme == .dark ? Capsule().stroke(.white, lineWidth: 2) : Capsule().stroke(.clear, lineWidth: 3))
                    .padding(.trailing, 10)
            }
            
        }
        .bottomSheet(isPresented: $isPresented, detents: [.medium(), .large()]){
            TypeModal(selected: $selected)
        }
//        .sheet(isPresented: $isPresented){
//                TypeModal(selected: $selected)
//        }
    }
}

struct ChooseTypeButton_Previews: PreviewProvider {
    static var previews: some View {
//        let post: PostModel = PostModel(title: "", userID: "", username: "", description: "", condition: "", category: "", price: "", imageURLs: [], channel: "", savers: [], type: "")
        
        ChooseTypeButton(selected: .constant(""))
    }
}
