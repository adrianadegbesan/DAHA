//
//  ProhibitedPostsView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 3/29/23.
//

import SwiftUI

struct ProhibitedPostsView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        ScrollView(showsIndicators: true) {
            
            VStack{
                Image("Logo")
                    .overlay(Rectangle().stroke(colorScheme == .dark ? .white : .clear, lineWidth: 2))
                    .padding(.bottom, 10)
                
                Text("By posting on DAHA, you acknowledge that this post is in compliance with our terms and conditions:")
                    .font(
                        .system(size:14, weight: .semibold)
                    )
                    .foregroundColor(.secondary)
                
                    .padding()
                
                VStack{
                    HStack{
                        Image(systemName: "fork.knife")
                            .font(.system(size: 35, weight: .bold))
                            .foregroundColor(.red)
                            .padding(.horizontal, 10)
                        Text("No Food or Beverages")
                            .font(.system(size: 18, weight: .semibold))
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                    
                    HStack{
                        Image(systemName: "person.fill")
                            .font(.system(size: 35, weight: .bold))
                            .foregroundColor(.red)
                            .padding(.horizontal, 10)
                        Text("No Personal/Sensitive Information")
                            .font(.system(size: 18, weight: .semibold))
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                    
                    HStack{
                        Image(systemName: "multiply")
                            .font(.system(size: 35, weight: .bold))
                            .foregroundColor(.red)
                            .padding(.horizontal, 10)
                        Text("No Dangerous/Illegal Items or Substances")
                            .font(.system(size: 18, weight: .semibold))
                        
                        Spacer()
                    }
                    .frame(height: 50)
                    .padding(.horizontal)
                    .padding(.bottom)
                    
                    HStack{
                        Image(systemName: "person.fill.xmark")
                            .font(.system(size: 35, weight: .bold))
                            .foregroundColor(.red)
                            .padding(.horizontal, 10)
                        Text("No Indecent Content")
                            .font(.system(size: 18, weight: .semibold))
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                    
                    HStack{
                        Image(systemName: "x.circle")
                            .font(.system(size: 35, weight: .bold))
                            .foregroundColor(.red)
                            .padding(.horizontal, 10)
                        Text("No Stolen Property")
                            .font(.system(size: 18, weight: .semibold))
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.bottom)

                }
                Text("and all the other prohibited items stated in the terms and conditions.")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.secondary)
                    .padding(.top, 10)
                    .padding(.horizontal, 35)
                
                Text("Violations of any of these rules may result in the permanent removal of access to your account")
                        .font(
                            .system(size:14, weight: .semibold)
                        )
                        .foregroundColor(.red.opacity(0.9))
                        .padding(.top, 10)
                        .padding(.horizontal, 35)
                
              }
          }
        }
        
}

struct ProhibitedPostsView_Previews: PreviewProvider {
    static var previews: some View {
        ProhibitedPostsView()
    }
}
