//
//  TextField.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import Foundation
import SwiftUI


extension TextField {
    // extension for title text
    func inputFields() -> some View {
        self
            .background(RoundedRectangle(cornerRadius: 5).fill(Color.white))
        .frame(width: screenWidth * 0.9)
        .padding(.horizontal, 40)
    }
    
}

/*Custom Text Field Style*/
struct OutlinedTextFieldStyle: TextFieldStyle {
    
    @State var icon: Image?
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        HStack {
            if icon != nil {
                icon
                    .foregroundColor(Color(UIColor.systemGray4))
            }
            configuration
        }
        .padding()
        .overlay {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(Color(UIColor.systemGray4), lineWidth: 2)
        }
    }
}

struct OvalTextFieldStyle: TextFieldStyle {
    
    @State var icon: Image?
    @Binding var text: String
    @Environment(\.colorScheme) var colorScheme
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        HStack {
            if icon != nil {
                icon
                    .foregroundColor(Color(UIColor.systemGray))
            }
            configuration
            Spacer()
            
            if text != "" {
                Text(Image(systemName: "multiply.circle.fill"))
                    .font(.system(size: 18.5, weight: .bold))
                    .foregroundColor(.gray.opacity(colorScheme == .dark ? 0.3 : 0.6))
                    .onTapGesture {
                        text = ""
                    }
                    .transition(.opacity)
                    .padding(.trailing, 3)
            }
            
                
         }
            .padding(10)
            .cornerRadius(20)
            .frame(height: 40)
//            .overlay{
//                RoundedRectangle(cornerRadius: 20).stroke(lineWidth: 1)
//            }
           
    }
}

public extension View {
    func modify<Content>(@ViewBuilder _ transform: (Self) -> Content) -> Content {
        transform(self)
    }
}

struct FirstResponderTextField : UIViewRepresentable {
    
    @Binding var text: String
    let placeholder: String
    
    class Coordinator: NSObject, UITextFieldDelegate {
        
        @Binding var text: String
        var becameFirstResponder = false
        
        init(text: Binding<String>){
            self._text = text
        }
        func textFieldDidChangeSelection(_ textField: UITextField) {
            text  = textField.text ?? ""
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }
    
    func makeUIView(context: Context) -> some UIView {
        let textField = UITextField()
        textField.delegate = context.coordinator
        textField.placeholder = placeholder
        return textField
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        if !context.coordinator.becameFirstResponder{
            uiView.becomeFirstResponder()
            context.coordinator.becameFirstResponder = true
        }
    }
    
    
}
