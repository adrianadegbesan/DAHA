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
        .font(
            .system(size:20, weight: .bold)
        )
    }
    
    // extension for channel text
    func channelText() -> some View {
        self
            .font(
                .system(size:20, weight: .bold)
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



