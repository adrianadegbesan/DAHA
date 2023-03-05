//
//  Modifiers.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 3/4/23.
//

import Foundation
import SwiftUI


extension Bool {
     static var iOS16: Bool {
         guard #available(iOS 16, *) else {
             return false
         }
         return true
     }
 }


