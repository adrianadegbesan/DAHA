//
//  DeadlineView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 5/21/23.
//

import SwiftUI

struct DeadlineView: View {
    @Binding var post: PostModel
    @State var selected: Bool = false
    @State private var showingDatePicker = false
    @State private var selectedDate = Date()
    @Environment(\.colorScheme) var colorScheme
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a M/d/yyyy"
        return formatter
    }
    
    var body: some View {
        HStack{
            if !selected{
                (Text(Image(systemName: "hourglass")) + Text(" ") + Text("Add Deadline"))
                    .lineLimit(1)
                    .foregroundColor(selected ? Color(hex: "#FFC107") : colorScheme == .dark ? .white : .black)
                    .font(.system(size: 14, weight: .bold))
                    .padding(10)
                    .background(Capsule().stroke( colorScheme == .dark ? .white : .black, lineWidth: 2))
                    .onTapGesture {
                        showingDatePicker = true
                    }
                    .padding(.trailing, 10)
            } else {
                Text(Image(systemName: "multiply.circle.fill"))
                    .font(.system(size: 13, weight: .bold))
                    .background(Circle().fill(.white).scaleEffect(colorScheme == .dark ? 1 : 0.6))
                    .background(Circle().stroke(colorScheme == .dark ? .white : .black, lineWidth: colorScheme == .dark ? 1 : 3))
                    .foregroundColor(.red)
                    .padding(.trailing, 10)
                    .onTapGesture {
                        LightFeedback()
                        withAnimation{
                            selected = false
                        }
                        
                    }
                
                ( Text(Image(systemName: "hourglass"))
                    .font(.system(size: 14, weight: .heavy))
                    .foregroundColor(Color(hex: "#FFC107")) + Text("  ") + Text(dateFormatter.string(from: selectedDate))
                        .font(.system(size: 14, weight: .bold))
                )
                
                
                .padding(10)
                .background(Capsule().stroke( colorScheme == .dark ? .white : .black, lineWidth: 2))
                
            }
          
        }
        .onChange(of: selected){ value in
            
            if selected {
                withAnimation{
                    post.deadline = selectedDate
                }
            } else {
                withAnimation{
                    post.deadline = nil
                }
            }
           
           
        }
        .sheet(isPresented: $showingDatePicker) {
          VStack {
              Text(Image(systemName: "hourglass"))
                .font(.system(size: 60, weight: .heavy))
                .foregroundColor(Color(hex: "#FFC107"))
                .padding(.bottom, 5)
               
              Text("Select a Deadline")
                  .font(.system(size: 28, weight: .heavy))
//                  .foregroundColor(Color(hex: deepBlue))
              DatePicker("Select a Deadline", selection: $selectedDate, in: Date()..., displayedComponents: [.date, .hourAndMinute])
                  .datePickerStyle(GraphicalDatePickerStyle())
                  .labelsHidden()
              
              HStack{
                  
                  Button{
                      selected = true
                      showingDatePicker = false
                  } label: {
                      Text("Done")
                          .font(.system(size: 15, weight: .bold))
                          .foregroundColor(Color(hex: deepBlue))
                          .padding(10)
                          .background(Capsule().stroke(Color(hex: deepBlue), lineWidth: 2))
                  }
                  .foregroundColor(.primary)
                  .padding()
                  
                  Button{
                      selected = false
                      showingDatePicker = false
                  } label: {
                      Text("Cancel")
                          .font(.system(size: 15, weight: .bold))
                          .foregroundColor(.red)
                          .padding(10)
                          .background(Capsule().stroke(.red, lineWidth: 2))
                  }
                  .foregroundColor(.primary)
                  .padding()
                  
              }
             
          }
//          .background(Color(.systemBackground))
//          .cornerRadius(15)
        }
    }
}

struct DeadlineView_Previews: PreviewProvider {
    static var previews: some View {
        let post: PostModel = PostModel(title: "", userID: "", username: "", description: "", condition: "", category: "", price: "", imageURLs: [], channel: "", savers: [], type: "", keywordsForLookup: [], reporters: [])
        
        DeadlineView(post: .constant(post))
    }
}
