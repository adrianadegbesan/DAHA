//
//  VersionView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/14/23.
//

import SwiftUI

struct VersionView: View {
    var body: some View {
        HStack{
            Spacer()
            Text("Version \(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "0")")
                .font(.system(size: 15, weight: .black))
                .foregroundColor(Color(hex: deepBlue))
            Spacer()
        }
    }
}

struct VersionView_Previews: PreviewProvider {
    static var previews: some View {
        VersionView()
    }
}
