//
//  SearchScreen.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import SwiftUI

// Search Screen
struct SearchScreen: View {
    
    @State var query = ""
    @State var category = ""
    @State var type = ""
    
    var body: some View {
        
        ZStack {
            VStack(spacing: 0) {
                HeaderView(title: "Search", showMessages: false, showSettings: false,showSearchBar: true, slidingBar: false, tabIndex: nil, tabs: nil)
                .frame(alignment: .top)
                TextField("Does Anyone Have A...?", text: $query)
                    .textFieldStyle(OutlinedTextFieldStyle(icon: Image(systemName: "magnifyingglass")))
                    .submitLabel(.search)
                    .onSubmit {
                        hideKeyboard()
                    }
                    .padding(.horizontal, screenWidth * 0.06)
                    .padding(.bottom, 25)
                HStack{
                    ChooseCategoryButton(selected: $category)
                        .padding(.trailing, 4)
                    ChooseTypeButton(selected: $type)
                }
                .padding(.bottom, 15)

                    
                Spacer()
            } //: VStack
        } //: ZStack
        .keyboardControl()
    }
}

struct SearchScreen_Previews: PreviewProvider {
    static var previews: some View {
        SearchScreen()
    }
}
