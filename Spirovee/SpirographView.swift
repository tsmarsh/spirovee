//
//  SpirographView.swift
//  Spirovee
//
//  Created by Tom Marsh on 12/3/24.
//
import SwiftUI

struct SpirographView: View {
    let R: Double
    let r: Double
    let d: Double
    
    var body: some View {
        Canvas { context, size in
            let center = CGPoint(x: size.width/2, y: size.height/2)
            var path = Path()
            var first = true
            
            // Calculate points for one complete cycle
            for t in stride(from: 0, through: 2 * Double.pi * Double(lcm(Int(R), Int(r))) / R, by: 0.01) {
                let x = (R-r) * cos(t) + d * cos((R-r)/r * t)
                let y = (R-r) * sin(t) - d * sin((R-r)/r * t)
                
                let point = CGPoint(
                    x: center.x + x,
                    y: center.y + y
                )
                
                if first {
                    path.move(to: point)
                    first = false
                } else {
                    path.addLine(to: point)
                }
            }
            
            context.stroke(path, with: .color(.blue), lineWidth: 2)
        }
    }
}

// Helper function to calculate Least Common Multiple
func lcm(_ a: Int, _ b: Int) -> Int {
    return abs(a * b) / gcd(a, b)
}

// Helper function to calculate Greatest Common Divisor
func gcd(_ a: Int, _ b: Int) -> Int {
    var a = a
    var b = b
    while b != 0 {
        let temp = b
        b = a % b
        a = temp
    }
    return abs(a)
}
