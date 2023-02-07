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
    @EnvironmentObject var network: Network
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        if isActive{
                ContentView()
        } else {
            VStack{
                VStack{
                        Image("Logo")
                        .overlay(Rectangle().stroke(colorScheme == .dark ? .white : .clear, lineWidth: 2))
                        .padding(.bottom, 8)
                        Text("DOES ANYONE HAVE A...?")
                        .font(
                            .system(size:22, weight: .bold)
                        )
                }
                .padding(.bottom, screenWidth * 0.32)
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear{
                    withAnimation(.easeIn(duration: 0.8)){
                        self.size = 1
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
            .environmentObject(Network())
            .previewLayout(.sizeThatFits)
    }
}
