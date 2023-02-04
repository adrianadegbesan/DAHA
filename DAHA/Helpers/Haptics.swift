//
//  Haptics.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/3/23.
//

import Foundation
import SwiftUI


func HeavyFeedback() {
    let generator = UIImpactFeedbackGenerator(style: .heavy)
    generator.impactOccurred()
}

func MediumFeedback() {
    let generator = UIImpactFeedbackGenerator(style: .medium)
    generator.impactOccurred()
}

func LightFeedback() {
    let generator = UIImpactFeedbackGenerator(style: .light)
    generator.impactOccurred()
}

