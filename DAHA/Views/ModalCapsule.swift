//
//  ModalCapsule.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/7/23.
//

import SwiftUI

struct ModalCapsule: View {
    var body: some View {
        Capsule()
            .frame(width: 38, height: 6)
            .foregroundColor(.gray)
    }
}

struct ModalCapsule_Previews: PreviewProvider {
    static var previews: some View {
        ModalCapsule()
    }
}
