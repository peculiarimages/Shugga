//
//  SugahExtensions.swift
//  Sugah
//
//  Created by Rodi on 9/30/22.
//

import SwiftUI
import HealthKit
import UIKit
import AVFAudio



extension Int {
    /// Returns the digits of the number in the given base.
    /// The array of digits is ordered from most to least significant.
    func digits(base: Int = 10) -> [Int] {
        if self < base {
            return [self]
        }
        var n = self
        var d: [Int] = []
        while n > 0 {
            d.insert(n % base, at:  0)
            n /= base
        }
        return d
    }
}


extension Double {
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
// for debugging

extension ShapeStyle where Self == Color {
    static var random: Color {
        Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}
