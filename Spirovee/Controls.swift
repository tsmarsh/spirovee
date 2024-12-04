//
//  Controls.swift
//  Spirovee
//
//  Created by Tom Marsh on 12/3/24.
//
import SwiftUI

struct ControlView : View {
    @Binding var R: Double // Fixed circle radius
    @Binding var r: Double // Moving circle radius
    @Binding var d: Double // Distance from center
    @Binding var t: Double
    @Binding var z: Double
    @Binding var points: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Fixed Circle (R): \(Int(R))")
            Slider(value: $R, in: 5...50, step: 1)
            
            Text("Moving Circle (r): \(Int(r))")
            Slider(value: $r, in: 5...50, step: 1)
            
            Text("Distance (d): \(Int(d))")
            Slider(value: $d, in: 1...100, step: 1)
            
            Text("Thickness (t): \(t)")
            Slider(value: $t, in: 0...10, step: 0.1)
//            
//            Text("Z: \(z)")
//            Slider(value: $z, in: 0...50, step: 1)
            
            Text("Accuracy: \(Int(points))")
            Slider(value: $points, in: 1000...50000, step: 1000)
        }
    }
}
