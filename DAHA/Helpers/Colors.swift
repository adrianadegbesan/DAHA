//
//  Colors.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import Foundation
import SwiftUI


extension Color {
    // extension for creating colours with hex values
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

//Saved hex colours
let greyBackground = "F6F6F6"
let whiteBackground = "ffffff"
let darkGrey = "484848"
let deepBlue = "0076FF"
let red_color = "FF0000"

let dark_scroll_background = "151517"
let light_scroll_background = "eeeeee"

let messageBubbleReceiver_dark = "26252A"
let messageBubbleReceiver_light = "E8E8EA"
 // Category Colors

let category_colors = [
    "Bikes": "001685",
    "Tech": "BB0F0F",
    "Clothing": "0FBB2A",
    "Rides": "00C5D6",
    "Services": "D89000",
    "Furniture": "5400D3",
    "Books": "03A597",
    "Outdoor":  "C5BF03",
    "Tickets": "D400D8",
    "General": "000000"
]


