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
    @State var title: String
    @State var price: String
    @State var images: [UIImage]
    @State private var size1 = 0.01
    @State private var size2 = 0.01
    @State private var size3 = 0.01
    @State private var glowScale: CGFloat = 1.0
    @State private var currentColor: String = ""
    @State private var isColorInitialized: Bool = false
    
    @Environment(\.colorScheme) var colorScheme
    
    let lightColors = ["001685", "BB0F0F", "0FBB2A", "00C5D6", "D89000", "5400D3", "03A597", "C5BF03", "D400D8", "000000"]
      let darkColors = ["001685", "BB0F0F", "0FBB2A", "00C5D6", "D89000", "5400D3", "03A597", "C5BF03", "D400D8", "FFFFFF"]

    init(category: String, title: String, price: String, images: [UIImage]) {
           self._category = State(initialValue: category)
           self._title = State(initialValue: title)
           self._price = State(initialValue: price)
           self._images = State(initialValue: images)
           self._currentColor = State(initialValue: category_colors[category] ?? "000000")
       }
    
    var body: some View {
        VStack {
            VStack {
                ZStack {
                    if images.isEmpty{
                        glowingView(color: isColorInitialized ? Color(hex: currentColor) : .primary)
                    }
                   
                    Image(systemName: category_images[category] ?? "")
                        .resizable()
                        .scaledToFit()
                        .frame(width: images.isEmpty ? 240 : 160, height: images.isEmpty ? 120 : 80)
                        .foregroundColor(isColorInitialized ? Color(hex: currentColor) : .primary)
                        .opacity(isAnimating ? 0 : 1)
                        .animation(.easeInOut(duration: 0.5), value: isAnimating)
                        .onTapGesture {
                            if !images.isEmpty{
                                LightFeedback()
                                withAnimation {
                                    isAnimating.toggle()
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    withAnimation {
                                        currentColor = getNewColor()
                                        isAnimating.toggle()
                                    }
                                }
                            }
                        }
                       
                }
                .padding(.bottom, 10)
                
                if images.isEmpty{
                    
                    HStack{
                        
                        Text(title)
                            .font(.system(size: 21, weight: .bold))
                        
                        Image(systemName:"circle.fill")
                            .font(.system(size: 3.5, weight: .bold))
                            .foregroundColor(.secondary)
                        
                        Text(price != "Free" ? "$\(price)" : "Free")
                            .font(.system(size: 16.5, weight: .bold))
                            .foregroundColor(.secondary)
                        
                    }
                    .padding(.horizontal)
                }
                
                if images.count == 1 {
                    Image(uiImage: images[0])
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(12)
                        .overlay{
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(.primary, lineWidth: 2)
                        }
                        .frame(maxWidth: 180)
                        .padding(.horizontal, 10)
                } else if images.count > 1 {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .top){
                            
                            
                            ForEach(images, id: \.self){ image in
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(12)
                                    .overlay{
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(.primary, lineWidth: 2)
                                    }
                                    .frame(maxWidth: 180)
                                    .padding(.horizontal, 10)
                                
                            }
                        }
                        .padding()
                    }
                    .frame(maxHeight: 300)
                }
                
                
            }
            .offset(y: !images.isEmpty ? bounceOffset : 0)
            .onAppear {
                withAnimation(.easeIn(duration: 0.5)){
                    initializeColor()
                }
                if !images.isEmpty{
                    withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                        bounceOffset = -40.0
                    }
                   
                } else {
                    withAnimation(Animation.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                        glowScale = 1.3
                    }
                }
          }
            .padding(.bottom, 20)
            
            if !images.isEmpty{
                HStack{
                    
                    Text(title)
                        .font(.system(size: 21, weight: .bold))
                    
                    Image(systemName:"circle.fill")
                        .font(.system(size: 3.5, weight: .bold))
                        .foregroundColor(.secondary)
                    
                    Text(price != "Free" ? "$\(price)" : "Free")
                        .font(.system(size: 16.5, weight: .bold))
                        .foregroundColor(.secondary)
                    
                    if images.count > 1{
                        Spacer()
                    }
                    
                }
                .padding(.horizontal)
            }
       
        }
    }
    
    private func glowingView(color: Color) -> some View {
        Circle()
            .fill(
                RadialGradient(
                    gradient: Gradient(colors: [color.opacity(0.7), color.opacity(0.0)]),
                    center: .center,
                    startRadius: 1,
                    endRadius: 90
                )
            )
            .frame(width: 180, height: 180)
            .scaleEffect(glowScale)
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
    
    private func randomColor() -> String {
        let colors = colorScheme == .dark ? darkColors : lightColors
        return colors[Int.random(in: 0..<colors.count)]
    }

    private func getNewColor() -> String {
        var newColor = randomColor()
        let cur = currentColor
        while newColor == cur {
            newColor = randomColor()
        }
        currentColor = cur
        return newColor
    }
    
    private func initializeColor() {
           if category == "General" {
               currentColor = colorScheme == .dark ? "FFFFFF" : "000000"
           } else {
               currentColor = category_colors[category] ?? "000000"
           }
           isColorInitialized = true
       }
}

struct SFSymbolAnimation_Previews: PreviewProvider {
    static var previews: some View {
        let images: [UIImage] = []
        
        PostAnimation(category: "Bikes", title: "Bike", price: "Free", images: images)
    }
}






