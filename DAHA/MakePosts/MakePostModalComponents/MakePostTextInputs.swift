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
    @Binding var type : String
    @FocusState var description_input : Bool
    
    var body: some View {
        VStack{
            TextField(type == "Request" ? "Willing to Pay" : "Price", text: $price)
                .onChange(of: price) { value in
                    if price.count > 5{
                        price = String(price.prefix(5))
                    }
                    post.price = price
                }
                .keyboardType(.numberPad)
                .textFieldStyle(OutlinedTextFieldStyle(icon: Image(systemName: "dollarsign")))
                .padding(.leading, screenWidth * 0.045)
                .padding(.trailing, screenWidth * 0.5)
                .padding(.bottom, 10)
            
            TextField("Title", text: $title)
                .onChange(of: title) { value in
                    if title.count > 30{
                        title = String(title.prefix(23))
                    }
                    post.title = title
                }
                .textFieldStyle(OutlinedTextFieldStyle(icon: Image(systemName: "cart.fill")))
                .submitLabel(.return)
                .onSubmit {
                    hideKeyboard()
                }
                .padding(.leading, screenWidth * 0.045)
                .padding(.trailing, screenWidth * 0.25)
            
            Text("\(title.count)/30")
                .foregroundColor(Color(hex: deepBlue))
                .padding(.leading, screenWidth * 0.39)
                .padding(.bottom, 10)
            
            ZStack {
                TextEditor(text: $description)
                    .focused($description_input)
                    .onChange(of: description){ value in
                        if description.count > 320{
                            description = String(description.prefix(320))
                        }
                        post.description = description
                        
//                        if description.last == "\n"{
//                            description = String(description.dropLast(1))
//                            post.description = description
//                            hideKeyboard()
//                        }
                    }
                    .frame(width: screenWidth * 0.6, height: screenHeight * 0.15)
                    .padding()
                    .overlay {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                    
                            .stroke(Color(UIColor.systemGray4), lineWidth: 2)
                    }
                    .padding(.trailing, screenWidth * 0.245)
                    .padding(.bottom, 10)
                if description == ""{
                     Text(" Description")
                        .foregroundColor(Color(UIColor.systemGray4))
                        .offset(x: -screenWidth * 0.305, y: -screenHeight * 0.0597)
                        .onTapGesture {
                            description_input = true
                        }
                }
                Text("\(description.count)/320")
                    .offset(x: screenWidth * 0.15, y: screenHeight * 0.110)
                    .foregroundColor(Color(hex: deepBlue))
//                    .padding(.top, scre)
            }
            .padding(.leading, 16)
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button(action: {
                    hideKeyboard()
                }){
                        Text(Image(systemName: "multiply"))
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                }
            }
        }

    }
    
    
}

struct MakePostTextInputs_Previews: PreviewProvider {
    static var previews: some View {
        let post: PostModel = PostModel(title: "", userID: "", username: "", description: "", condition: "", category: "", price: "", imageURLs: [], channel: "", savers: [], type: "", keywordsForLookup: [], reporters: [])
        MakePostTextInputs(post: .constant(post), type: .constant(""))
    }
}

