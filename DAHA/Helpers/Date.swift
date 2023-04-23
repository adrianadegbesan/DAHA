//
//  Date.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/31/23.
//

import Foundation
import SwiftUI


extension Date {
    /*
     Time ago display function
     */
    func timeAgoDisplay() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))

        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let year = 365 * day

        if secondsAgo < minute {
            
            if secondsAgo == 1 || secondsAgo < 10{
                return "Just now"
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
            
        } else if secondsAgo < year {
            
            if secondsAgo / week == 1 {
                return "\(secondsAgo / week) week ago"
            }

            return "\(secondsAgo / week) weeks ago"
        }

        if secondsAgo / year == 1 {
            return "\(secondsAgo / year) year ago"
        }

        return "\(secondsAgo / year) years ago"
    }
}

extension Date {
    func toMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
    
    
    func dateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a   M/d/yyyy"
        return formatter.string(from: self)
    }
}



