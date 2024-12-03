//
//  ContentView.swift
//  Spirovee
//
//  Created by Tom Marsh on 12/3/24.
//

import SwiftUI

struct ContentView: View {
    @State private var R: Double = 100  // Fixed circle radius
    @State private var r: Double = 40   // Moving circle radius
    @State private var d: Double = 50   // Distance from center
    
    var body: some View {
        VStack {
            SpirographView(R: R, r: r, d: d)
                .frame(width: 300, height: 300)
                .border(Color.gray, width: 1)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Fixed Circle (R): \(Int(R))")
                Slider(value: $R, in: 50...150)
                
                Text("Moving Circle (r): \(Int(r))")
                Slider(value: $r, in: 10...80)
                
                Text("Distance (d): \(Int(d))")
                Slider(value: $d, in: 10...100)
            }
            .padding()
        }
    }
}

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
            for t in stride(from: 0, through: 2 * Double.pi * lcm(Int(R), Int(r))/R, by: 0.01) {
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

#Preview {
    ContentView()
}
