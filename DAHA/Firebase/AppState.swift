//
//  AppState.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 3/22/23.
//

import Foundation
import SwiftUI

class AppState: ObservableObject {
    
    @Published var isNavigationBarHidden : Bool = true
    @Published var profileStart : Bool = true
    @Published var messageScreen : Bool = false
    @Published var firstSignOn : Bool = false
    @Published var firstConnectionCheck : Bool = true
    @Published var exitedSearch : Bool = true
    @Published var homeStart : Bool = true
    
  
    
}
