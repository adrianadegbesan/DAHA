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
                .system(size:17.5, weight: .bold)
        )
            .foregroundColor(.white)
    }    
}

//Function used to check if an email is a valid email address
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

//Function used to splice domain from email
func getDomain(email: String) -> String{
    let temp_email = email
    
    if (temp_email == ""){
        return ""
    }
    let index = temp_email.firstIndex(of: "@")
    
    let domain = temp_email.suffix(from: index ?? temp_email.startIndex)
    
    let components = domain.split(separator: ".")
    
    if components.count >= 2 {
        let lastComponent = components.last!
        let secondLastComponent = components[components.count - 2]
        let tld = secondLastComponent + "." + lastComponent
        var result = String(tld)
        if result.first == "@"{
            result = String(result.dropFirst())
        }
        return result
    } else {
        return String(components.last ?? "")
    }
}
    
//    let substring = temp_email.suffix(from: index ?? temp_email.startIndex)
//    temp_email = String(substring)
//
//    return temp_email
//}

extension String {
    // Function used to generate string sequences for search functionality
    func generateStringSequence() -> [String] {
        guard self.count > 0 else {return [] }
        var substrings = [String]()
        for i in 0 ..< self.count {
            for j in i+1 ... self.count {
                substrings.append(String(self[self.index(self.startIndex, offsetBy: i) ..< self.index(self.startIndex, offsetBy: j)]))
            }
        }
        
        substrings = substrings.map { $0.lowercased()}
        return substrings
    }
}

extension View {
    // Function used to hide keyboard
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}

extension View {
    // Function used for keyboard control with exit button
    func keyboardControl() -> some View {
        self
            .submitLabel(.return)
            .onSubmit {
                hideKeyboard()
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button(action: {
                        hideKeyboard()
                    }){
                            ExitButton()
                    }
                }
            }
    }
}


