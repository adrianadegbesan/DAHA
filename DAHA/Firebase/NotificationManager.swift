//
//  NotificationsManager.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 3/11/23.
//

import Foundation
import SwiftUI

class NotificationManager : ObservableObject {
    
    @Published var navigate : Bool = false
    @Published var screenToNavigateTo : String = ""
    
}
