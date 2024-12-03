//
//  SpirographCalculator.swift
//  Spirovee
//
//  Created by Tom Marsh on 12/3/24.
//

import Foundation

struct SpirographPoint {
    let x: Double
    let y: Double
}

class SpirographCalculator {
    static func calculatePoints(R: Double, r: Double, d: Double, stepSize: Double = 0.01) -> [SpirographPoint] {
        var points: [SpirographPoint] = []
        
        // Calculate points for one complete cycle
        let cycle = 2 * Double.pi * lcm(Int(R), Int(r))/R
        
        for t in stride(from: 0, through: cycle, by: stepSize) {
            let x = (R-r) * cos(t) + d * cos((R-r)/r * t)
            let y = (R-r) * sin(t) - d * sin((R-r)/r * t)
            points.append(SpirographPoint(x: x, y: y))
        }
        
        return points
    }
    
    // Helper function to calculate Least Common Multiple
    private static func lcm(_ a: Int, _ b: Int) -> Int {
        return abs(a * b) / gcd(a, b)
    }
    
    // Helper function to calculate Greatest Common Divisor
    private static func gcd(_ a: Int, _ b: Int) -> Int {
        var a = a
        var b = b
        while b != 0 {
            let temp = b
            b = a % b
            a = temp
        }
        return abs(a)
    }
}
