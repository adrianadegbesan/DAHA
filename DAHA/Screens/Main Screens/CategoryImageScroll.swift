//
//  CategoryImageScroll.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 5/8/23.
//

import SwiftUI

struct CategoryImageScroll: View {
  
      let categoryImages = [
          "Bikes": "bicycle",
          "Tech": "iphone",
          "Clothing": "tshirt.fill",
          "Rides": "car.fill",
          "Services": "person.2.fill",
          "Furniture": "house.circle",
          "Books": "text.book.closed.fill",
          "Outdoor":  "sun.max.fill",
          "Tickets": "ticket.fill",
          "General": "bag.fill"
      ]
    @State private var autoScrollOffset: CGFloat = 0
    @State private var manualScrollOffset: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(0..<100) { pass in
                        ForEach(categoryImages.keys.sorted(), id: \.self) { category in
                            CategoryItem(category: category, imageName: categoryImages[category]!)
                                .frame(width: geometry.size.width * 0.25)
                        }
                    }
                }
                .offset(x: -autoScrollOffset + manualScrollOffset)
                .onAppear {
                    scrollNext(geometry)
                }
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            manualScrollOffset = value.translation.width
                        }
                        .onEnded { value in
                            manualScrollOffset = 0
                        }
                )
            }
        }
        .clipped()
        .frame(height: screenHeight * 0.2)
    }
    
    func scrollNext(_ geometry: GeometryProxy) {
        let singleItemWidth = geometry.size.width * 0.5 + 20
        let totalWidth = singleItemWidth * CGFloat(categoryImages.count)
        let animationDuration: TimeInterval = 0.04

        Timer.scheduledTimer(withTimeInterval: animationDuration, repeats: true) { timer in
            withAnimation(.linear(duration: animationDuration)) {
                autoScrollOffset += 1

                if autoScrollOffset >= totalWidth {
                    autoScrollOffset = 0
                }
            }
        }
    }
}

struct CategoryImageScroll_Previews: PreviewProvider {
    static var previews: some View {
        CategoryImageScroll()
    }
}

struct CategoryItem: View {
    var category: String
    var imageName: String

    var body: some View {
        VStack {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 50)
//            Text(category)
//                .font(.caption)
        }
        .padding()
    }
}
