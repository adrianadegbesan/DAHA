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
                Spacer().frame(height: 1)
                Text("Joined on \(joinedAt)")
                    .font(.system(size: 12, weight: .black))
                    .foregroundColor(Color(hex: deepBlue))
                Spacer().frame(height: 4)
                Text("Version \(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "0")")
                    .font(.system(size: 12, weight: .black))
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
