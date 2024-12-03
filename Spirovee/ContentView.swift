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
            
            let points = SpirographCalculator.calculatePoints(R: R, r: r, d: d)
            
            for point in points {
                let canvasPoint = CGPoint(
                    x: center.x + point.x,
                    y: center.y + point.y
                )
                
                if first {
                    path.move(to: canvasPoint)
                    first = false
                } else {
                    path.addLine(to: canvasPoint)
                }
            }
            
            context.stroke(path, with: .color(.blue), lineWidth: 2)
        }
    }
}

#Preview {
    ContentView()
}
