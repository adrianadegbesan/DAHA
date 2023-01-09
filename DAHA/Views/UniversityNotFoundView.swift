//
//  UniversityNotFoundView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import SwiftUI

struct UniversityNotFoundView: View {
    @Binding var domain : String
    @Binding var isPresented : Bool
    
    var body: some View {
        VStack {
            Text("SORRY!")
                .foregroundColor(Color.init(hex: deepBlue))
                .font(.system(size: 21, weight: .heavy))
                .padding()
                
            Text("We are not at your school yet.")
                .font(.system(size: 21, weight: .bold))
            
            GroupBox {
                Text("DAHA is not available \(domain). \nIf you think this is a mistake, please check that you have entered your correct .edu email.")
                    .foregroundColor(Color.init(hex: darkGrey))
                    .font(.system(size: 15, weight: .semibold))
            }
            .cornerRadius(17)
            .padding(.horizontal, 20)
            
            
            Text("Want DAHA to come to your school? Send us an email to let us know!")
                .foregroundColor(Color.init(hex: darkGrey))
                .font(.system(size: 13, weight: .regular))
                .padding(.horizontal, screenWidth * 0.1)
                .padding(.vertical)
        }
        .onTapGesture {
            isPresented = false
        }
    }
}

struct UniversityNotFoundView_Previews: PreviewProvider {
    
    static var previews: some View {
        UniversityNotFoundView(domain : .constant("@gonzaga.edu"), isPresented: .constant(true))
            .previewLayout(.sizeThatFits)
    }
}
