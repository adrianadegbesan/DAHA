//
//  JoinedAtView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 3/4/23.
//

import SwiftUI
import Firebase

struct JoinedAtView: View {
    @AppStorage("joined") var joinedAt = ""
    
    
    var body: some View {
        HStack{
            Spacer()
            VStack{
                Text("Joined on \(joinedAt)")
                    .font(.system(size: 13, weight: .black))
                    .foregroundColor(Color(hex: deepBlue))
                Text("Version \(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "0")")
                    .font(.system(size: 13, weight: .black))
                    .foregroundColor(Color(hex: deepBlue))
            }
         
            Spacer()
        }
    }
}

struct JoinedAtView_Previews: PreviewProvider {
    static var previews: some View {
        JoinedAtView()
    }
}
