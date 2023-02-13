//
//  Date.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/31/23.
//

import Foundation
import SwiftUI


extension Date {
    func timeAgoDisplay() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))

        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day

        if secondsAgo < minute {
            
            if secondsAgo == 1 {
                return "\(secondsAgo) second ago"
            }
            
            return "\(secondsAgo) seconds ago"
            
        } else if secondsAgo < hour {
            
            if secondsAgo / minute == 1 {
                return "\(secondsAgo / minute) min ago"
            }
            
            return "\(secondsAgo / minute) mins ago"
            
        } else if secondsAgo < day {
            
            if secondsAgo / hour == 1 {
                return "\(secondsAgo / hour) hr ago"
            }
            
            return "\(secondsAgo / hour) hrs ago"
            
        } else if secondsAgo < week {

            if secondsAgo / day == 1 {
                return "\(secondsAgo / day) day ago"
            }
            
            return "\(secondsAgo / day) days ago"
        }
        
        if secondsAgo / week == 1 {
            return "\(secondsAgo / week) week ago"
        }

        return "\(secondsAgo / week) weeks ago"
    }
}

extension Date {
    func toMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}


