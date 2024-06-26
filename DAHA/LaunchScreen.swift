//
//  LaunchScreen.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import SwiftUI
import Shimmer

struct LaunchScreen: View {
    
    
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var firestoreManager : FirestoreManager
    
    @State private var size1 = 0.01
    @State private var size2 = 0.01
    @State private var size3 = 0.01
    @State private var size4 = 0.01
    
    @State private var shimmer: Bool = false

    
    var body: some View {
        if isActive{
            NavigationView{
                ContentView()
            }
            .navigationViewStyle(.stack)
        } else {
            VStack{
                VStack{
                    Image("Logo")
                        .overlay(Rectangle().stroke(colorScheme == .dark ? .white : .clear, lineWidth: 2))
                        .padding(.bottom, 8)
                     
                    
                    HStack(spacing: 1.2){
                        Text("DOES ANYONE HAVE A")
                            .font(
                                .system(size:22, weight: .bold)
                            )
                        
                        Text(".")
                            .font(
                                .system(size:22, weight: .bold)
                            )
                            .scaleEffect(size1)
                        Text(".")
                            .font(
                                .system(size:22, weight: .bold)
                            )
                            .scaleEffect(size2)
                        Text(".")
                            .font(
                                .system(size:22, weight: .bold)
                            )
                            .scaleEffect(size3)
                        Text("?")
                            .font(
                                .system(size:22, weight: .bold)
                            )
                            .scaleEffect(size4)
                    }
                    
                }
                .padding(.bottom, screenWidth * 0.32)
                .scaleEffect(size)
                .opacity(opacity)
                .shimmering (
                    active: shimmer,
                    animation: .easeIn(duration: 0.75)
                )
                /*Opacity and scale effect of whole image*/
                .onAppear{
                    withAnimation(.easeIn(duration: 0.65)){
                        self.size = 1
                        self.opacity = 1.0
                    }
                    /*First Appearance of Images*/
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.65){
                    withAnimation {
                        self.size1 = 1
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.25){
                    withAnimation {
                        self.size2 = 1
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.85){
                    withAnimation {
                        self.size3 = 1
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.45){
                    withAnimation {
                        self.size4 = 1
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.5){
                    withAnimation {
                        self.isActive = true
                        /*Change to ContentView*/
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
