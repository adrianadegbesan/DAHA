//
//  LaunchScreen.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import SwiftUI

struct LaunchScreen: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        
        if isActive{
            ContentView()
        } else {
            VStack{
                VStack{
                        Image("Logo")
                        Text("DOES ANYONE HAVE A...?")
                        .font(
                            .system(size:25, weight: .bold)
                        )
                }
                .padding(.bottom, screenWidth * 0.32)
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear{
                    withAnimation(.easeIn(duration: 0.8)){
                        self.size = 0.9
                        self.opacity = 1.0
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

struct LaunchScreen_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreen()
            .previewLayout(.sizeThatFits)
    }
}
