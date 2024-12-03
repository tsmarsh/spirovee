//
//  SpirographView.swift
//  Spirovee
//
//  Created by Tom Marsh on 12/3/24.
//
import SwiftUI

struct SpirographView: View {
    let R: Int
    let r: Int
    let d: Int
    
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
