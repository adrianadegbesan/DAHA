//
//  MakePostTextInputs.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/31/23.
//

import SwiftUI

struct MakePostTextInputs: View {
    
    @State var price: String = ""
    @State var title: String = ""
    @State var description: String = ""
    @Binding var post: PostModel
    
    var body: some View {
        VStack{
            TextField("Price", text: $price)
                .onChange(of: price) { value in
                    if price.count > 5{
                        price = String(price.prefix(5))
                    }
                    post.price = "$\(price)"
                }
                .keyboardType(.numberPad)
                .textFieldStyle(OutlinedTextFieldStyle())
                .padding(.leading)
                .padding(.trailing, screenWidth * 0.6)
                .padding(.bottom, 10)
            
            TextField("Title", text: $title)
                .onChange(of: title) { value in
                    if title.count > 23{
                        title = String(title.prefix(23))
                    }
                    post.title = title
                }
                .textFieldStyle(OutlinedTextFieldStyle())
                .padding(.leading)
                .padding(.trailing, screenWidth * 0.288)
                .padding(.bottom, 10)
            
            ZStack {
                TextEditor(text: $description)
                    .onChange(of: description){ value in
                        if description.count > 200{
                            description = String(description.prefix(200))
                        }
                        post.description = description
                    }
                    .frame(width: screenWidth * 0.6, height: screenWidth * 0.3)
                    .padding()
                    .overlay {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                    
                            .stroke(Color(UIColor.systemGray4), lineWidth: 2)
                    }
                    .padding(.trailing, screenWidth * 0.24)
                    .padding(.bottom, 10)
                if description == ""{
                    Text("Description")
                        .foregroundColor(Color(UIColor.systemGray4))
                        .offset(x: -screenWidth * 0.2965, y: -screenHeight * 0.0535)
                }
            }
            .padding(.leading, 16)
        }
    }
}

struct MakePostTextInputs_Previews: PreviewProvider {
    static var previews: some View {
        let post: PostModel = PostModel(title: "", userID: "", username: "", description: "", condition: "", category: "", price: "", imageURLs: [], channel: "", savers: [])
        MakePostTextInputs(post: .constant(post))
    }
}
