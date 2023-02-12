//
//  Text.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import Foundation
import SwiftUI




extension Text {
    // extension for title text
    func titleText() -> some View {
        self
            .lineLimit(1)
            .minimumScaleFactor(0.01)
        .font(
            .system(size:17, weight: .bold)
        )
    }
    
    // extension for channel text
    func channelText() -> some View {
        self
            .lineLimit(1)
            .minimumScaleFactor(0.01)
            .font(
                .system(size:19, weight: .bold)
        )
            .foregroundColor(.white)
    }    
}


func isValidEmailAddress(emailAddressString: String) -> Bool {
    
    var returnValue = true
    let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
    
    do {
        let regex = try NSRegularExpression(pattern: emailRegEx)
        let nsString = emailAddressString as NSString
        let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
        
        if results.count == 0
        {
            returnValue = false
        }
        
    } catch let error as NSError {
        print("invalid regex: \(error.localizedDescription)")
        returnValue = false
    }
    
    return  returnValue
}

func getDomain(email: String) -> String{
    var temp_email = email
    
    if (temp_email == ""){
        return ""
    }
    let index = temp_email.firstIndex(of: "@")
    
    let substring = temp_email.suffix(from: index ?? temp_email.startIndex)
    temp_email = String(substring)
    
    return temp_email
}

extension String {
    func generateStringSequence() -> [String] {
        guard self.count > 0 else {return [] }
//        var sequences: [String] = []
//        for i in 1...self.count {
//            sequences.append(String(self.prefix(i)).lowercased())
//        }
//        return sequences
        var substrings = [String]()
        for i in 0 ..< self.count {
            for j in i+1 ... self.count {
                substrings.append(String(self[self.index(self.startIndex, offsetBy: i) ..< self.index(self.startIndex, offsetBy: j)]))
            }
        }
        
        substrings = substrings.map { $0.lowercased() }
        return substrings
    }
}

extension View {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}

extension View {
    func keyboardControl() -> some View {
        self
            .submitLabel(.return)
            .onSubmit {
                hideKeyboard()
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button(action: {
                        hideKeyboard()
                    }){
                            Text(Image(systemName: "multiply"))
                            .fontWeight(.bold)
                            .foregroundColor(.gray)
                    }
                }
            }
    }
}


