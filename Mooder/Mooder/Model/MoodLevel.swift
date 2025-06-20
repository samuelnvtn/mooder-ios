//
//  MoodLevel.swift
//  Mooder
//
//  Created by Samuel Novotný on 21.06.2025.
//

import SwiftUI

enum MoodLevel: Int16 {
    case sad = 1
    case meh = 2
    case neutral = 3
    case okay = 4
    case happy = 5

    var color: Color {
        switch self {
        case .happy: return Color(hex: "#0F8977")
        case .okay: return Color(hex: "#3CAF9B")
        case .neutral: return Color(hex: "#84BEB0")
        case .meh: return Color(hex: "#FFB1A0")
        case .sad: return Color(hex: "#FF8E9C")
        }
    }
}

