//
//  Email.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/14/23.
//

import Foundation
import UIKit
import MessageUI

/*
 Email Structs
 */

struct ComposeMailData {
  let subject: String
  let recipients: [String]?
  let message: String
  let attachments: [AttachmentData]?
}

struct AttachmentData {
  let data: Data
  let mimeType: String
  let fileName: String
}

