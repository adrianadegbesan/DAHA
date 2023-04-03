//
//  NetworkImage.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 4/3/23.
//

import SwiftUI

struct NetworkImage: View {
    var body: some View {
        Image(systemName: "wifi.exclamationmark")
            .headerImage()
            .foregroundColor(.red)
    }
}

struct NetworkImage_Previews: PreviewProvider {
    static var previews: some View {
        NetworkImage()
    }
}
