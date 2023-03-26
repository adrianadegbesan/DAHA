//
//  SFSymbolAnimation.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 3/25/23.
//
import SwiftUI


struct PostAnimation: View {
    @State private var bounceOffset: CGFloat = 0.0
    @State private var glowOpacity: Double = 0.0
    @State private var isAnimating: Bool = false
    @State var category: String
    @State var Images: [UIImage]
    @State private var size1 = 0.01
    @State private var size2 = 0.01
    @State private var size3 = 0.01
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            ZStack {
                Image(systemName: category_images[category] ?? "")
                    .resizable()
                    .scaledToFit()
                    .frame(width: Images.isEmpty ? 240 : 160, height: Images.isEmpty ? 120 : 80)
                    .foregroundColor(category == "General" ? .primary : Color(hex: category_colors[category] ?? "000000")) // Set your desired color here
                    .offset(y: bounceOffset)
            }
            .padding(.bottom, 10)
            
            HStack{
                ForEach(Images, id: \.self){ image in
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(12)
                        .overlay{
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(.primary, lineWidth: 2)
                        }
                        .offset(y: bounceOffset)
                        .padding(.horizontal, 10)
                    
                }
            }
            .frame(width: screenWidth * 0.95, height: screenHeight * 0.3)
            .padding(.bottom, 20)
            
            
//            if !Images.isEmpty{
//                HStack{
//                    Text(".")
//                        .font(
//                            .system(size:50, weight: .bold)
//                        )
//                        .scaleEffect(size1)
//                    Text(".")
//                        .font(
//                            .system(size:50, weight: .bold)
//                        )
//                        .scaleEffect(size2)
//                    Text(".")
//                        .font(
//                            .system(size:50, weight: .bold)
//                        )
//                        .scaleEffect(size3)
//                }
//                .onAppear{
//                    animateDots()
//                }
//            }
        }
        .onAppear {
            if !Images.isEmpty{
                withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                    bounceOffset = -50.0
                }
            }
        }
    }
    
    private func animateDots() {
         withAnimation(Animation.easeInOut(duration: 0.5).delay(0.5)) {
             size1 = 1
         }

         withAnimation(Animation.easeInOut(duration: 0.5).delay(1)) {
             size2 = 1
         }

         withAnimation(Animation.easeInOut(duration: 0.5).delay(1.5)) {
             size3 = 1
         }

         withAnimation(Animation.easeInOut(duration: 0.5).delay(2)) {
             size3 = 0
         }

         withAnimation(Animation.easeInOut(duration: 0.5).delay(2.5)) {
             size2 = 0
         }

         withAnimation(Animation.easeInOut(duration: 0.5).delay(3)) {
             size1 = 0
         }

         DispatchQueue.main.asyncAfter(deadline: .now() + 3.2) {
             animateDots()
         }
     }
}

struct SFSymbolAnimation_Previews: PreviewProvider {
    static var previews: some View {
        let images: [UIImage] = []
        
        PostAnimation(category: "Bikes", Images: images)
    }
}






