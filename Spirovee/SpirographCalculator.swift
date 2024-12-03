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
    static func calculatePoints(R: Int, r: Int, d: Int) -> [SpirographPoint] {
        let num_points = 5000
        
        guard R > 0 && r > 0 && R != r else {
            fatalError("R and r must be positive and not equal.")
        }
        
        var points: [SpirographPoint] = []
        
        let lcmValue = lcm(R, r)
        let thetaMax = 2.0 * .pi * (Double(lcmValue) / Double(r))
        let stepSize = thetaMax / Double(num_points)
        
        for t in stride(from: 0.0, through: thetaMax, by: stepSize) {
            let rr: Double = Double(R-r)
            let dr: Double = Double(r)
            let dd: Double = Double(d)
            
            let x = rr * cos(t) + dd * cos(rr/dr * t)
            let y = rr * sin(t) - dd * sin(rr/dr * t)
            points.append(SpirographPoint(x: x, y: y))
        }
        
        
        return points
    }
    
}

func lcm(_ a: Int, _ b: Int) -> Int {
    return (a / gcd(a, b)) * b
}
func gcd(_ a: Int, _ b: Int) -> Int {
    return b == 0 ? a : gcd(b, a % b)
}
