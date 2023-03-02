//
//  Email API.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/22/23.
//

import Foundation
import SwiftUI
import PostmarkSwift

/*
 Old function used for emailing API, (DISCONTINUED)
 */

func sendVerificationEmail(email: String, error_alert: Binding<Bool>, error_message: Binding<String>) async ->  Int  {

    var serverTokenString = ""
    
    if let emailToken = Bundle.main.infoDictionary?["EMAIL_TOKEN"] as? String {
        serverTokenString = emailToken
    } else {
        error_alert.wrappedValue = true
    }
    
    let code = Int.random(in: 100000..<999999)
    
    let client = PostmarkSwift.Client(serverToken: serverTokenString)
    
    let message = PostmarkSwift.OutgoingEmail(
        from: "team@joindaha.com",
        to: email,
        subject: "Verification Code",
        textBody: "Hello! Your verification code to create a DAHA Account is \(code)"
    )
    
    do {
        let result = try await client.send(message)
        print("Message was submitted for sending at \(result.submittedAt!) to recipient(s) \(result.to!) with ID \(result.messageID!)")
        return code
    }
    catch {
        error_alert.wrappedValue = true
        error_message.wrappedValue = error.localizedDescription
        print(error.localizedDescription)
    }
    return 0
}
